data = read.csv("Data.csv")

data$up.5days = as.factor(data$up.5days)
data$均線上方 = as.factor(data$均線上方)
data$均量上方 = as.factor(data$均量上方)

train = data[2:1207,]
test = data[1208:1642,]

#作圖
#install.packages('ggplot2')
require('ggplot2')
ggplot(data = train, aes(x=借券賣出餘額))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha=0.4)
ggplot(data = train, aes(x=融券))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha=0.4)
ggplot(data = train, aes(x=融資))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha=0.4)
ggplot(data = train, aes(x=EMA45))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=最高價))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=收盤價))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=最低價))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=外資))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=成交量))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=買進家數))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=賣出家數))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=自營商))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=主力))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=交易家數))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=控盤者))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=三大法人))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha = 0.8)
ggplot(data = train, aes(x=投信))+geom_density()+
  geom_density(data = test, fill = "purple")+geom_density(alpha=0.4)


#stacking predict using knn, rpart and rf as base layer
#install.packages('caretEnsemble')
#install.packages('caret')
require(caret)
require(caretEnsemble)

control = trainControl(method = 'cv', number = 10, savePredictions='final',
                       classProbs = TRUE)
algorithmList = c('knn', 'rpart', 'rf')
set.seed(1125)
models = caretList(up.5days~EMA45變動率+最高價變動率+最低價變動率+
                    收盤價變動率+交易家數變動率+買進家數變動率+
                    賣出家數變動率+借券賣出餘額變動率, 
                  data = train, trControl = control, 
                  methodList = algorithmList)
results = resamples(models)
summary(results)
#views
modelCor(results)
splom(results)

#meta layer using random forest
stackControl = trainControl(method = 'cv', number = 10, 
                            savePredictions='final', classProbs = TRUE)
set.seed(314)
stack.rf = caretStack(models, method='rf', metric = 'Accuracy',
                      trControl = stackControl)
print(stack.rf)
rf.pre = predict(stack.rf, newdata = test)
confusion.matrix = table(test$up.5days, rf.pre, deparse.level = 2)
confusion.matrix
(confusion.matrix[1,1]+confusion.matrix[2,2])/sum(confusion.matrix)*100

#meta layer using knn
stack.knn = caretStack(models, method='knn', metric = 'Accuracy',
                       trControl = stackControl)
print(stack.knn)
knn.pre = predict(stack.knn, newdata = test)
knn.confusion.matrix = table(test$up.5days, knn.pre, deparse.level = 2)
knn.confusion.matrix
(knn.confusion.matrix[1,1]+knn.confusion.matrix[2,2])/sum(knn.confusion.matrix)*100

#meta layer using rpart
stack.rpart = caretStack(models, method='rpart', metric = 'Accuracy',
                         trControl = stackControl)
print(stack.rpart)
rpart.pre = predict(stack.rpart, newdata = test)
rpart.confusion.matrix = table(test$up.5days, rpart.pre, deparse.level = 2)
rpart.confusion.matrix
(rpart.confusion.matrix[1,1]+rpart.confusion.matrix[2,2])/sum(rpart.confusion.matrix)*100
#meta layer using adaboost
stack.ada = caretStack(models, method = 'adaboost', metric = 'Accuracy',
                       trControl = stackControl)
ada.pre = predict(stack.ada, newdata = test)
ada.confusion.matrix = table(test$up.5days, ada.pre, deparse.level = 2)
ada.confusion.matrix
(ada.confusion.matrix[1,1]+ada.confusion.matrix[2,2])/sum(ada.confusion.matrix)*100


#only use random forest
require(e1071)
rf_train = data[2:1207,-c(1)]
rf_test = data[1208:1642,-c(1)]

tune = tune.randomForest(up.5days~EMA45變動率+最高價變動率+最低價變動率+
                           收盤價變動率+交易家數變動率+買進家數變動率+
                           賣出家數變動率+借券賣出餘額變動率,
                         data = rf_train, mtry = c(2:8), ntree = c(100, 300, 500, 1000))
summary(tune)
require('randomForest')
rf = randomForest(up.5days~EMA45變動率+最高價變動率+最低價變動率+
                    收盤價變動率+交易家數變動率+買進家數變動率+
                    賣出家數變動率+借券賣出餘額變動率,
                  data = rf_train, ntree = 100, mtry = 8, 
                  importance = TRUE)
rf.predict = predict(rf, rf_train)
rf.confusion.train = table(rf_train$up.5days, rf.predict, deparse.level = 2)
rf.confusion.train
rf.test.predict = predict(rf, rf_test)
rf.test.confusion.matrix = table(rf_test$up.5days, rf.test.predict, deparse.level = 2)
rf.test.confusion.matrix
(rf.test.confusion.matrix[1,1]+rf.test.confusion.matrix[2,2])/sum(rf.test.confusion.matrix)*100


