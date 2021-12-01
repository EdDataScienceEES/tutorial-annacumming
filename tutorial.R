####################################
# Spearman's Rank Correlation in R #
####################################

# This tutorial explores the link between experimental design, statistical 
# analysis and the writing of scientific reports with a focus on linear models 
# and non-parametric alternatives such as Spearman's rank correlation.

# Created by Anna Cumming #
# s1950955@ed.ac.uk       #
# University of Edinburgh #
# 28/11/2021              #

# For the coding part of this tutorial we will use this dataset on Peruvian 
# soils which I sourced from this website: 
# https://figshare.com/collections/Using_DNA_to_assess_errors_in_tropical_tree_
# identifications_How_often_are_ecologists_wrong_and_when_does_it_matter_/3309534
# We will test whether the data on total base saturation and sand content
# meets the assumptions of our chosen linear model (linear regression), 
# run a Spearman's rank correlation when we find it doesn't and inpterpret and
# visualise these results.

# Libraries----
# Install libraries by removing # in front of the following lines of code
# if you don't have them already. 
# install.packages(tidyverse)
# install.packages(report)
# install.packages(ggpubr)

# Run libraries.
library(tidyverse) # runs packages like dplyr and ggplot2
library(report)  # used here to provide interpretations of statistical test outputs
library(ggpubr)  # customise ggplot2 plots

# Import Dataset----
# If you are not accessing the repository using Github Desktop then set the 
# working directory to the zip file you downloaded from this repository
# (remember to extract files first). You can find the file source by right
# clicking on it within your file explorer, going to properties and checking the
# location. Bear in mind that R uses forward slashes so you can't just copy the 
# file path.
# Set working directory.
setwd("C:/Users/Anna Cumming/OneDrive/Academic/DS/tutorial-instructions") 
# change the location to where you put the folder 

# Load Peruvian soils dataset.
soils<- read.csv("data/Peruvian_soils.csv")  # call the dataset object soils
                                             # from the data folder
glimpse(soils)  # check it out

# Tidy and Explore Dataset----
# Keep only the columns we need using select().
soils <- soils %>% 
         select("Survey", "Total_Base_Saturation", "Sand")  # keep only columns 
                                                            # with these titles
glimpse(soils)  # see how it has changed

# Test Assumptions----
# We will test the assumptions of a linear regression on the relationship
# sand content (explanatory) and total base saturation (response).

# Visualise this relationship as a scatter plot.
(scatter <- ggplot(soils,
              aes(x = Sand, y = Total_Base_Saturation)) +
    geom_point(colour = "orange") +  # make the datapoints orange
    theme_bw() +  # remove grey background
    theme(panel.grid = element_blank()) +  # remove gridlines 
    labs( x="Sand Content (%)", y="Total Base Saturation (%)"))  # add axis labels

# Just from looking at the plot we might think that total base saturation
# declines with sand content. But you will also note that this relationship is
# not very strong if it does exist.

# Run a Shapiro-Wilk test to check if residuals follow a normal distribution.
shapiro.test(soils$Total_Base_Saturation)
# If the residuals of our response variable were normally distributed the 
# p-value would be greater than 0.05 so our data does not fit this assumption.

# We can see this just by looking at the distribution of the response variable.
hist(soils$Total_Base_Saturation)  # plot the distribution of total base saturation 

# It might be possible to fix this with some data transformation (step 6) though
# so let's check the other assumptions to see how much of an issue we are 
# dealing with.

# Create plots we can analyse to test the dataset meets the assumptions of a
# linear model.
sand_TBS <- lm(Total_Base_Saturation~Sand, data=soils)  # run linear regression
plot(sand_TBS) # follow the instruction in the R console to view each plot

# Run Statistical Tests----

# Run linear regression (just to compare outputs).
linear_regression <- lm(Total_Base_Saturation~Sand, data=soils)  # run linear 
                                                                 # regression
summary(linear_regression)  # reveal output statistics of linear regression

# Run Spearman's rank correlation.
cor.test(soils$Sand, soils$Total_Base_Saturation, data=soils,
                     method="spearman",  # define type of correlation
                     exact= FALSE)  # to this to alleviate warnings

# Results Interpretation----
# Interpret results of linear regression using report().
report(linear_regression) # produce a statement describing outputs 

# Create Final Plots----
# Plot linear regression
(regression_plot <- ggscatter(soils, x = "Sand", y = "Total_Base_Saturation",
      color = "blue") + # colour the points blue
      geom_smooth(method = "lm", color = "blue") +  # create a blue linear regression
      stat_regline_equation(label.x = 3, label.y = 7) +  # display equation of
                                                         # linear regression
                                                         # at these co-ordinates
      theme_bw() +  # remove grey background
      theme(panel.grid = element_blank()) +  # remove gridlines
      labs(x = "Sand Content (%)", y = "Total Base Saturation (%) "))  # add axis labels

# Save linear regression plot.
ggsave(file = "graphics/regression_plot.jpg",  # name and location of plot
       regression_plot,  # object you're saving
       width = 12,
       height = 8)  # save plot as JPEG with these dimensions

# Create a scatter plot with Spearman's rank correlation statistics displayed.
(spearman_plot <- ggscatter(soils, x = "Sand", y = "Total_Base_Saturation",
                            color = "orange",  # colour points orange
          add = "reg.line",   # add a regression line
          conf.int = TRUE,  # display the confidence interval/ribbon
          cor.coef = TRUE,  # display the correlation coefficient and p-value
          cor.method = "spearman",  # display a Spearman coefficient
          xlab = "Sand Content (%)", ylab = "Total Base Saturation(%)"))  # add axis labels

# Save Spearman's rank correlation plot.
ggsave(file = "graphics/spearman_plot.jpg",  # name and location of plot
       spearman_plot,  # object you're saving
       width = 12,
       height = 8)  # save plot as JPEG with these dimensions
