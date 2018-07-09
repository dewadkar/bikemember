# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

hello <- function() {
  print("Hello, world!")install.packages("XML")
}

  library(dplyr)
  library(zoo)
  library(lubridate)
  library(XML)
  tripdata <- read.csv("R/input/201805-capitalbikeshare-tripdata.csv")
  View(tripdata)
  colnames(tripdata)
  tripdata <- tripdata[!(is.na(tripdata$End.station) | tripdata$End.station==""), ]

  # External data
  xmlfile <- xmlTreeParse('R/input/stations.xml',useInternalNodes = TRUE)
  topxml <- xmlRoot(xmlfile)
  topxml <- xmlSApply(topxml, function(x) xmlSApply(x, xmlValue))
  station_data <- data.frame(t(topxml), row.names=NULL)
  station_data$terminalName <- as.numeric(station_data$terminalName)
  station_data$lat <- as.numeric(station_data$lat)
  station_data$long <- as.numeric(station_data$long)
  station_data$name <- as.character(station_data$name)
  View(station_data)
  write.csv(station_data,file = "R/input/station_data.csv")

  temp <- tripdata
  # write.csv(tripdata,file = "df1.csv")
  # View(temp)
  # View(station_data)
  # View(tripdata)
  # glimpse(station_data)
  # temp <- cbind("ss_id","ss_terminalName","ss_lat","ss_long","ss_nbBikes","ss_nbEmptyDocks")
  # glimpse(temp)


  temp$name <- temp$Start.station
  dim_desc(tripdata)
  df <- merge(temp,station_data,by="name",all.x = TRUE)
  df$name <- df$End.station
  df1 <- merge(df,station_data,by="name",all.x = TRUE,suffixes ="es")
  dim_desc(df1)
  write.csv(df1,file = "R/input/df1.csv")
  colnames(df1)

  cols <- c("Member.type","Duration","terminalNamees","lates","longes","nbBikeses",
            "nbEmptyDockses","terminalNameNA","latNA","longNA","nbBikesNA","nbEmptyDocksNA")

  df.fl <- df1[,c(cols)]
  dim_desc(df.fl)

  install.packages('caTools')
  library(caTools)
  split <- sample.split(df.fl$Member.type, SplitRatio = 0.75)
  split
  #get training and test data
  train <- subset(df.fl, split == TRUE)
  test <- subset(df.fl, split == FALSE)

  train[is.na(train)] <- 0.00001
  dim_desc(train)
  dim_desc(test)


  #logistic regression model
  model <- glm (Member.type ~ ., data = train, family = binomial)
  summary(model)
  predictions <- predict(model,test[,-1],type="response")


  x = train[,-1]
  y= train[,1]
  sum(is.na(train))
  sum(is.na(y))
  x[is.na(x)] <- 0


  #Fitting the Naive Bayes model
  library(e1071)
  nbmodel = train(x,y,'nb',trControl=trainControl(method='cv',number=2))
  nbmodel
  predict(nbmodel$finalModel,x[50,])
  table(predict(nbmodel$finalModel,x[1:50,])$class,y[1:50])

