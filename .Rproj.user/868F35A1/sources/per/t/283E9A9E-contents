# Library Loading
library(dplyr)
library(shiny)
library(ggplot2)
library(ggrepel)
library(plotly)

# Data Loading

greenhouse <- read.csv("Data/greenhouse.csv")[,-1]
population <- read.csv("Data/population.csv")[,-1]

 # Clean Date
greenhouse$time <- substr(greenhouse$time,1,4)
population$time <- substr(population$time,1,4)

 # Analysis of levels
levels(greenhouse$unit)
levels(greenhouse$airpol)
levels(greenhouse$geo)

 
# Uniform unit of measure

greenhouse[which(greenhouse$unit == 'THS_T'), 'values'] <- greenhouse[which(greenhouse$unit == 'THS_T'), 'values']/1000 

#Drop useless columns and distinct

greenhouse <- greenhouse %>% filter(unit == 'MIO_T') %>% select(-unit) %>% distinct()

# Keep only CO2 equivalents
greenhouse <- greenhouse %>% filter(airpol != 'CH4') %>% filter(airpol != 'N2O')


 # Task 1: population and gas emission

x <- colnames(greenhouse)
x[4] <- "gas"
colnames(greenhouse) <- x

x <- colnames(population)
x[3] <- "population"
colnames(population) <- x

rm(x)

# Filter out non-EU countries 
greenhouse <- greenhouse %>% filter(substring(geo,1,2) != 'EU') %>% filter(substring(geo,1,2) != 'IS')
greenhouse$geo <-as.character(greenhouse$geo)

population$geo <-as.character(population$geo)

green_popu <- greenhouse %>% inner_join(population, by = c('geo', 'time'))
green_popu <- green_popu %>% mutate_if(is.character, as.factor)

green_popu <- green_popu %>% filter(airpol == 'GHG') %>% select(-airpol) 

countries <- c('Austria', 'Belgium', 'Bulgaria', 'Cyprus', 'Czech Republic', 'Germany', 'Denmark', 'Estonia','Greece', 'Spain', 'Finland', 'France', 'Croatia',
               'Hungary', 'Ireland', 'Italy',  'Lithuania', 'Luxembourg', 'Latvia', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania',  'Sweden', 'Slovenia','Slovakia', 'United Kingdom' )

green_popu$population <- green_popu$population/1000000

green_popu <- data.frame(green_popu, countries, gas_per_pop = green_popu$gas/green_popu$population)


years_available <- green_popu %>% select(time) %>% distinct()

df<- green_popu %>% filter(time == '2019')





###################
# Changing composition EU
###################

###################

# Predict NAs through a Random Forest model
# index <- which(is.na(green_popu$gas))
# dataset <- green_popu[index,-4]
# dataset <- predict(my_model, dataset)
# 
# green_popu[which(is.na(green_popu$gas)),'gas'] <- as.numeric(dataset)
# 
# estimated <- 1:NROW(green_popu)
# estimated[which(estimated %in% index)] <- 'Yes'
# estimated[which(estimated != 'Yes')] <- 'No'
# 
# green_popu <- data.frame(green_popu, estimated)
# 
# 
# # Select Year
# 
# green_popu <- green_popu %>% filter(time == '2019') %>% select(-time)
# 
# ggp <- ggplot(data = green_popu, mapping = aes(x=population, y=gas)) +
#   geom_point(aes(colour=geo), alpha=0.6) + geom_text(aes(label= geo),hjust=0, vjust=0)+ facet_wrap(~ airpol)
#   
# print(ggp)
