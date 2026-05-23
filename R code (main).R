# Installation of Packages
install.packages("dplyr")
install.packages("tidyr")
install.packages("forcats")
library(dplyr)
library(tidyr)
library(forcats)

# Data import
MHdata <- read.csv("Melbourne_housing.csv")

# Data cleaning
## First, I delete unnecessary columns that are not going to be employed
MHdata <- MHdata[,-c(1,2,5:7,9,13,14,16:18,20)]

## Second, I delete the rows that have NA in columns that represent factors we'll study
MHdata <- MHdata[!is.na(MHdata$Price) &
                 !is.na(MHdata$YearBuilt) &
                 !is.na(MHdata$Bedroom) &
                 !is.na(MHdata$Bathroom) &
                 !is.na(MHdata$Car),]

## Next, I'd like to check whether all values in the remaining columns would make sense.
## For instance, they wouldn't, if there are e.g. merely 1-5 rows with this value.
## In this case, we'll summarize the values with few repetitions into one factor per column as 'other'.
MHdata %>%
  select(ParkingArea,Regionname,Car,Bathroom,Bedroom,Type,Rooms) %>%
  lapply(table)
## We can see there are indeed some values having very few repetitions in the data.
## Thus, we need to collect those values under one per column so that in the model they all have one factor each.
MHdata <- MHdata %>%
  mutate(across(c(Car,Bathroom,Bedroom,Rooms), as.character)) %>%
  mutate(across(c(Car,Bathroom,Bedroom,Rooms),
                ~fct_lump_min(., min = 30, other_level = "Other")))
##Check if it works
MHdata %>%
  select(ParkingArea,Regionname,Car,Bathroom,Bedroom,Type,Rooms) %>%
  lapply(table)
## We see now a value 'Other' in 4 columns for those values that were in 30 or less observations in data.
##From now we can assign only one factor to those 'rare' values.
