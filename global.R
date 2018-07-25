library(data.table)
library(ggplot2)
library(shiny)
library(dplyr)
library(tidyverse)
library(shinydashboard)
library(scales)
library(rsconnect)
library(lubridate)
library(leaflet)
library(ggmap)
library(plotly)
library(googleVis)
library(maps)
library(mapdata)
library(htmltools)
# setwd('C:/Users/Shani Fisher/Documents/Bootcamp/Shiny_proj')

# cleaning the data and getting rid of the NA's and Uppercase
homes = fread("data/brooklyn_dataset.csv", nrows=28000, fill=TRUE)
homes = homes[rowSums(is.na(homes)) < 4,]
homes$neighborhood = tolower(homes$neighborhood)
homes$address = tolower(homes$address)
homes$building_class_category = tolower(homes$building_class_category)

# Adding a new column based on renevations
homes = homes %>% 
  mutate(year_alter = ifelse(YearAlter2 >= 1990, 'Renevation_2', 
                             ifelse(YearAlter >=1990, 'Renevations_1', 'When_Built')))


# adding long and lat based on Zipcode from the Zipcode data
library(zipcode)
data(zipcode)
zipcode$zip = as.numeric(zipcode$zip)
colnames(zipcode)[1] = 'ZipCode'
homes = inner_join(homes, zipcode)
summary(zipcode)


# reducing sale_price by 1m
homes = homes %>% 
  mutate(sale= sale_price/1000000)

# For the colors on map_2(leaflet) using tax class and region
pal <- colorFactor(c("blue", "green", 'orange', 'purple'), domain = c("1", "2", '3', '4'))

# Added column according to price amount
homes = homes %>% mutate(sale_range= (ifelse(sale<=50, 'inexpensive', ifelse(sale<=100, 'regular', ifelse(sale<=175, 'middle', ifelse(sale<=260, 'expensive', 'very expensive'))))))



