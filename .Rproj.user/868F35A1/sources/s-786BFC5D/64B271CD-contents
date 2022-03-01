library(eurostat)
library(dplyr)

greenhouse <- get_eurostat('env_air_gge')

# Keep only category which is under analysis
greenhouse <- greenhouse[which(greenhouse$src_crf == 'TOTX4_MEMONIA'),] %>% select(-src_crf)

population <- get_eurostat('tps00001') [,-1]

write.csv(greenhouse, file = "data/greenhouse.csv")
write.csv(population, file = "data/population.csv")

greenhouse <- read.csv("data/greenhouse.csv")
population <- read.csv("data/population.csv")

