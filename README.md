run_analysis
============

Course Era assignment work
==================

Assumptions:
- Install 'reshape' and 'reshape2' packages 
- The directory "UCI HAR Dataset" should be in the working directory of your R ( getwd() )
- The script processes data for mean and std columns, meanFreq columns have also been ignored

========================

Explanation :

- First load the shape and reshape packages
- The data could be viewed as Train ( X, Y, Subject ) and Test ( X, Y and Subject ), these together would form tidy data later on
- We first read the files Train(X.y,Sub) and Test (X,y,sub)

- We have to combine all the 3 data. in the final form Train data and Test data would be Combined. Within each of train and test data, we will combine the columns of X, Y and Sub in each. So essentially its is like a rbind(Train,Test) and each Test and Train is like :  Train = cbind(Xtrain, YTrain,SubTrain ).
 
- We are hence row binding each of X , Y and Sub variables first and would do a cbind later. 
- NOTE: The order of rows are preserverd since we are doing a rbind of Train,Test data for each of them

- The next step is to label the activity_data correctly. Merge function has been used to merge the activity_labels.txt file with the Y data set and a new column has been added to Y data set by the name "activity_name

- For the X data,  we label the column names correctly from data from "features.txt". 'colnames()' function is used for this

- Use grep function on column names in X data to retreive columns that have 'mean()' and 'std()' characters

- Merge the X, Y and Subject data togehter to form the main data set  - 'datafinal'

- Make the names of the column in 'datafinal' more informative. THe names have been simplied based on pure english readability and might be scientifically incorrect

- Use melt and cast functions to create tidy data which is average each column for unique combination of Subject + activity name

- Write the tidy data  to a 'tidydata.txt' file in your working directory








# Reading activity_labels.txt and naming them appropriately for activity data ('ydata')
activitylabelpath <- 'UCI HAR Dataset\\activity_labels.txt'
activitylabel <- read.table(activitylabelpath)
colnames(activitylabel) <- c("activity_id","activity_name")
colnames(ydata) <- "activity_id"
ydata <- merge(ydata,activitylabel,by ='activity_id',sort=FALSE)  #keeping sort=FALSE to preserve the order

#From all the measurements, getting only the mean and standard dev variables, meanFreq columns are ignored
# reading the features.txt file
ftrspath <- 'UCI HAR Dataset\\features.txt'
ftrs <- read.table(ftrspath,stringsAsFactors=FALSE)
ftrs <- read.table(ftrspath)
ftrs <- t(ftrs[2])
colnames(xdata)<- ftrs

#subsetting the data by pattern matching on col names using grep function 
subsetmean <- xdata[,grep("mean\\(\\)",colnames(xdata))]
subsetstd <- xdata[,grep("std\\(\\)",colnames(xdata))]
xdata<- cbind(subsetmean,subsetstd)

#Column binding the X,Y and Subject data together to form the fina data
data<-cbind(ydata,xdata)
datafinal<-cbind(subdata,data)

# Correct naming of columns
test <- colnames(datafinal)
test<- sub("tBodyAcc","Time Body Acceleration ",test[])
test<- sub("tGravityAcc","Time Gravity Acceleration ",test[])
test<- sub("tBodyGyro","Time Body Gyroscope ",test[])
test<- sub("tGravityGyro","Time Gravity Gyroscope ",test[])
test<- sub("fBodyAcc","Frequency Body Acceleration ",test[])
test<- sub("fGravityAcc","Frequency Gravity Acceleration ",test[])
test<- sub("fBodyGyro","Frequency Body Gyroscope ",test[])
test<- sub("fGravityGyro","Frequency Gravity Gyroscope ",test[])
test<- sub("fBodyBodyAcc","Frequency Body Body  Acceleration ",test[])
test<- sub("fBodyBodyGyro","Frequency Body Body Gyroscope ",test[])
test<- sub("-mean\\(\\)"," Mean ",test[])
test<- sub("-std\\(\\)"," Standard Dev ",test[])
test<- sub("-std"," Standard Dev ",test[])

colnames(datafinal) <- test

# Melting and Casting the data to get Mean for each parameter vs each comination of  Subject + Activity
data2 <- melt(datafinal,id.vars =c("subject","activity_id","activity_name"))
tidy <- cast(data2, subject+activity_id+activity_name ~variable,mean)

#Writing down the final file - it gets saved in your working directory
write.table(tidy, "tidydata.txt")

