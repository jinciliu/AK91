#Task 3 
#Jinci LIU
#Sep 20, 2021

#Preparation
library(rio)
library(dplyr)
library(AER)
library(stargazer)
library(ggplot2)

rm(list =ls())
rootdir <-"C:\\Users\\jili4163\\Desktop\\Second_Year\\AE\\AS3"
setwd(rootdir)

#Input 
infile ="Build/Input/NEW7080.dta"

#Output
outfile1 = "Analysis/Input/AK91_clean.Rda"


# Prepare for building
file.copy("./Raw/NEW7080.dta", "./Build/Input/NEW7080.dta")


source("./Build/Code/clean.R") 

# Table reproduction
source("./Analysis/Code/Table.R")

# Figure V reproduction
source("./Analysis/Code/Figure.R")