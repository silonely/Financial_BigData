data = read.csv("Data.csv")

sapply(data, class)

data$均線上方 = as.factor(data$均線上方)
data$均量上方 = as.factor(data$均量上方)
data$up.5days = as.factor(data$up.5days)

train = data[1:1207,-c(1)]
test = data[1208:1642,-c(1)]

#randomForest not optimized
#install.packages("randomForest")
require(randomForest)
data.rf = randomForest(up.5days~., data = train, ntree = 500, mtry = 3, importance = TRUE)
varImpPlot(data.rf)

train.rf.predict = predict(data.rf, train)
confusion.train.rf = table(train$up.5days, train.rf.predict, deparse.level = 2)
confusion.train.rf
(confusion.train.rf[1,1]+confusion.train.rf[2,2])/sum(confusion.train.rf)*100

test.predict.rf = predict(data.rf, test)
confusion.test.rf = table(test$up.5days, test.predict.rf, deparse.level = 2)
confusion.test.rf
(confusion.test.rf[1,1]+confusion.test.rf[2,2])/sum(confusion.test.rf)*100

#install.packages("e1071")
require(e1071)
tune = tune.randomForest(up.5days~., data = train, mtry = 20, ntree = c(100, 300, 500, 1000, 1500, 2000))
summary(tune)
#best parameters:
#mtry ntree
#20   500(300)

data.rf = randomForest(up.5days~., data = train, ntree = 500, mtry = 20, importance = TRUE)
data.rf$importance
varImpPlot(data.rf, scale = FALSE)
train.predict = predict(data.rf, train)
confusion.train = table(train$up.5days, train.predict, deparse.level = 2)
confusion.train

test.predict = predict(data.rf, test)
confusion.test = table(test$up.5days, test.predict, deparse.level = 2)
confusion.test
(confusion.test[1,1]+confusion.test[2,2])/sum(confusion.test)*100


#randomForest optimized
# = data[1:1207, c("借券賣出餘額", "融券", "融資", "EMA45", "最高價", "收盤價", "均量10日", "開盤價", "最低價", "外資", "up.5days")]
train.adjusted = data[1:1207, c("借券賣出餘額", "融券", "融資", "EMA45", "最高價", "收盤價", "up.5days")]
adjusted.rf = randomForest(up.5days~., data = train.adjusted, ntree = 300, mtry = 6)
train.adjusted.rf.predict = predict(adjusted.rf, train.adjusted)

confusion.train.adjusted.rf = table(train.adjusted$up.5days, train.adjusted.rf.predict, deparse.level = 2)
confusion.train.adjusted.rf

test.adjusted = data[1208:1642, c("借券賣出餘額", "融券", "融資", "EMA45", "最高價", "收盤價", "up.5days")]
#test.adjusted = data[1208:1642, c("借券賣出餘額", "融券", "融資", "EMA45", "最高價", "收盤價", "均量10日", "開盤價", "最低價", "外資", "up.5days")]
test.adjusted.predict.rf = predict(adjusted.rf, test.adjusted)

confusion.test.adjusted.rf = table(test.adjusted$up.5days, test.adjusted.predict.rf, deparse.level = 2)
confusion.test.adjusted.rf
(confusion.test.adjusted.rf[1,1]+confusion.test.adjusted.rf[2,2])/sum(confusion.test.adjusted.rf)*100

#decision tree
#install.packages("rpart")
#install.packages("rpart.plot")
require(rpart)
require(rpart.plot)

f1 = up.5days~借券賣出餘額+融券+融資+EMA45+最高價+收盤價
data.rpart = rpart(f1, method = "class", data = train, minsplit = 10, cp = 0.005, maxdepth = 10)

rpart.plot(data.rpart)
train.predict = predict(data.rpart, type = "class")
test.predict = predict(data.rpart, test, type = "class")
confusion.train = table(train$up.5days, train.predict, deparse.level = 2)
confusion.train
(confusion.train[1,1]+confusion.train[2,2])/sum(confusion.train)*100
confusion.test = table(test$up.5days, test.predict, deparse.level = 2)
confusion.test
(confusion.test[1,1]+confusion.test[2,2])/sum(confusion.test)*100

