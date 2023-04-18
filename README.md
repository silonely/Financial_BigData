# Financial_BigData
## Three Different Machine Learning Model
### 1. Random Forest
If we use all the column in dataset to build a random forest model (ntree = 500, mtry = 3).

=> The predict accuracy is 45.29%.
#### 1-1 Optimized by "e1071" Package: 
Import the "e1071" package to improve the performance.

By using the tune.randomForest, the best parameter is using ntree = 300 or 500 and mtry = 20 when ntree is between 100 and 2000.

=> The predict accuracy is 42.30%, lower than the first model.

Maybe the overfitting happened because the learning rate is too high.

#### 1-2 Optimized by Gini Coefficient:
Using the columns has the higher MeanDecreaseGini to build the model(ntree = 300, mtry = 6).

=>The predict accuracy is 42.53%.

#### 1-3 Using Decision Trees:
Because the performance didn't get a lot of improvement, I try to use Decision Trees to analysis the reason.
Using the same columns in the former model to build the decision tree model.

=> The result: training accuracy has 82% accuracy, but the predict has only 42.53%.

=> The reason may be the dataset is not suitable for random forest and decision tree.

### 2. Stacking Ensemble
First, using ggplot2 to see the data distribution of all columns.
Then, Using the high distribution columns to build model.

#### [KNN / Decision Tree / Random Forest] + Random Forest:
In the first layer, choose knn, decision tree and random forest as the first layer algorithm.
In the second layer only use random forest.

=> The predict accuracy is 50.34%.

#### [KNN / Decision Tree / Random Forest] + KNN:
The first layer is as the same as the former model.
The second use knn instead of random forest. The reason is to compare the performance.

=> The predict accuracy is 53.33%.

#### [KNN / Decision Tree / Random Forest] + Decision Tree:
The first layer doesn't change.
The second layer is decision tree.

=> The predict accuracy is 61.38% (the highest accuracy)

#### [KNN / Decision Tree / Random Forest] + adaBoost:
The first layer doesn't change.
The second layer is adaBoost

=> The predict accuracy is 53.56%

#### Conclusion
Stacking Ensemble can increase the accuracy, and the result is better than the random forest.
If we build a new random forest model by using the columns in this section, the accuracy is higher than all the random forest models that we builded in the last section.

=> The predict accuracy is 50.80%.

### Association Rule
First, find all the association rule in the dataset but not include the date column.
=> The rule is {X=1} => {Y+1=1}, means a certain stock will affect another stock.
=> When support=0.3, confidence=0.5, there is 24 association rules in the dataset.


#### Rule = {Xt=1, Yt=1} => {Zt+1=1}:
When support=0.22, confidenct=0.5, there is 37 rules in the dataset.
=> In the rules we can find the certain category stock will affect another category stock.
