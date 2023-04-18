#install.packages("arules")
#install.packages("arulesViz")

require(arules)
require(arulesViz)


data = read.csv("Data.csv")
data = as.matrix(data[,-1])

#{Xt=1} => {Zt+1=1}
x = list()
for (i in (1:98)){
  data2 = cbind(data[-1, (-i)], data[-nrow(data), i])
  colname = colnames(data)[i]
  colnames(data2)[98] = colname
  data2 = as.matrix(data2)
  rule = apriori(data2, parameter = list(supp=0.3, conf = 0.5, 
                                         minlen = 2), appearance = list(lhs = colname))
  
  d = as(rule, "data.frame")
  # deal with no rows
  if(dim(d)[1] != 0){
    x = c(x, d[1])
  }
}

#all association rules
for( i in x){
  print(i)
}

#{Xt=1, Yt=1} => {Zt+1=1}
y = list()
for (i in (1:97)){
  data3 = cbind(data[-1, (-i)], data[-nrow(data), i])
  colname = colnames(data)[i]
  colnames(data3)[98] = colname
  data3 = as.matrix(data3)
  
  
  for(j in (i:(98-1))){
    data4 = cbind(data3[, (-j)], data[-nrow(data), j+1])
    colname = colnames(data)[j+1]
    colnames(data4)[98] = colname
    data4 = as.matrix(data4)
    
    rule = apriori(data4, parameter = list(supp=0.22, conf = 0.5, minlen = 3), 
                   appearance = list(lhs = c(colnames(data4)[97], colnames(data4)[98])))
    
    d = as(rule, "data.frame")
    # deal with no rows
    if(dim(d)[1] != 0){
      y = c(y, d[1])
    }
  }
}

#all association rules
for(i in y){
  print(i)
}

