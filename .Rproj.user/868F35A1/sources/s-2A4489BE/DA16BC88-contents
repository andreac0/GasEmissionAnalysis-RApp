library(eurostat)
library(dplyr)

greenhouse <- get_eurostat('env_air_gge') %>% filter(time == '2019-01-01')
population <- get_eurostat('tps00001') %>% filter(time == '2019-01-01')

write.csv(greenhouse, file = "./greenhouse.csv")
write.csv(population, file = "./population.csv")

greenhouse <- read.csv("data/greenhouse.csv")
population <- read.csv("data/population.csv")
