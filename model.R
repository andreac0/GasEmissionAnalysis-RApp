# Building model to predict NA values

dataset <- green_popu[which(!is.na(green_popu$gas)),] %>% filter(airpol != 'HFC_PFC_NSP_CO2E') %>% filter(airpol != 'NF3_CO2E')


#Avoid undersampling
n <- dataset %>% group_by(airpol) %>% count()
train <- data.frame()
test <- data.frame()
for (i in as.character(unlist(n[,1]))){
  
  temp <- dataset %>% filter(airpol == i)
  index <- sample(nrow(temp), nrow(temp)*4/5)
  
  train <- rbind(train,temp[index,])
  test <- rbind(test,temp[-index,])
}  


n = lm(gas ~ ., data = train)


# Random Forest
library(randomForest)
(rf_fit <- randomForest(gas ~ ., data = train))
plot(rf_fit)

data_gr <- train %>%
  mutate(set="train") %>%
  bind_rows(test %>% mutate(set="test"))

data_gr$fit <- predict(rf_fit, data_gr)
ggp <- ggplot(data = data_gr, mapping = aes(x=fit, y=gas)) +
  geom_point(aes(colour=set), alpha=0.6) +
  geom_abline(slope=1, intercept = 0) +
  geom_smooth(method = "lm", se = FALSE, aes(colour=set), alpha=0.6)
print(ggp)


set.seed(100)
oob_err <- double(4)
test_err <- double(4)

#mtry è il numero di variabili scelte caualmente ad ogni split
for(mtry in 1:4) {
  rf <- randomForest(gas ~ . , data = train, mtry=mtry,ntree=400) 
  oob_err[mtry] <- rf$mse[400] #Errore per tutti gli alberi adattati
  
  pred <- predict(rf,test) #Previsioni sul set di test per ciascun albero
  test_err[mtry] <- with(test, mean( (gas - pred)^2)) #Mean Squared Error per l'insieme di test
}

# Errore sull'insieme di Test
test_err

ds_gr <- data_frame(type=c(rep("test", length(test_err)), rep("oob", length(oob_err))),
                    mtry = c(1:length(test_err), 1:length(oob_err)),
                    error=c(test_err, oob_err))

ggp <- ggplot(data = ds_gr, mapping = aes(x=mtry,y=error)) +
  geom_line(aes(colour=type)) +
  geom_point(aes(colour=type)) + 
  ggtitle("OOB e Errore di test error Vs. Numero di variabili negli split (mtry)")

print(ggp)


set.seed(100)
(rf_fit <- randomForest(gas ~ ., data = train, mtry=3))

data_gr <- train %>%
  mutate(set="train") %>%
  bind_rows(test %>% mutate(set="test"))

data_gr$fit <- predict(rf_fit, data_gr)

mse <- data_gr %>%
  filter(set=="test") %>%
  summarise(mse = mean((fit-gas)^2)) %>%
  pull()

print(mse)

ggp <- ggplot(data = data_gr, mapping = aes(x=fit, y=gas)) +
  geom_point(aes(colour=set), alpha=0.6) +
  geom_abline(slope=1, intercept = 0) +
  geom_smooth(method = "lm", se = FALSE, aes(colour=set), alpha=0.6)
print(ggp)

saveRDS(rf_fit, "model.rds")
my_model <- readRDS("model.rds")
