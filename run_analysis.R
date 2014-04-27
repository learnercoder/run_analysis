#load the installed packages
library(reshape)
library(reshape2)

# The directory "UCI HAR Dataset" should be in the working directory of your R 

#get all the paths for all Train ( X , y , subject ) and Test ( X, Y, subject) variables
xtestpath <- 'UCI HAR Dataset\\test\\X_test.txt'
ytestpath <- 'UCI HAR Dataset\\test\\y_test.txt'
subtestpath <- 'UCI HAR Dataset\\test\\subject_test.txt'
xtrainpath <- 'UCI HAR Dataset\\train\\X_train.txt'
ytrainpath <- 'UCI HAR Dataset\\train\\y_train.txt'
subtrainpath <- 'UCI HAR Dataset\\train\\subject_train.txt'
  
# read all the test and train data
xtest <- read.table(xtestpath,stringsAsFactors=FALSE)
ytest <- read.table(ytestpath,stringsAsFactors=FALSE)
xtrain <- read.table(xtrainpath,stringsAsFactors=FALSE)
ytrain <- read.table(ytrainpath,stringsAsFactors=FALSE)
subtest <- read.table(subtestpath,stringsAsFactors=FALSE)
subtrain <- read.table(subtrainpath,stringsAsFactors=FALSE)

# Bind the X, Y and Subject data together respectively
# The ordered is preserved as we are not sorting and rbinding in the order -  ?Train and ?Test
xdata <- rbind(xtrain,xtest)
ydata<-rbind(ytrain,ytest)
subdata<-rbind(subtrain,subtest)
colnames(subdata) <- "subject"

# Reading activity_labels.txt and naming them appropriately for activity data ('ydata')
activitylabelpath <- 'UCI HAR Dataset\\activity_labels.txt'
activitylabel <- read.table(activitylabelpath)
colnames(activitylabel) <- c("activity_id","activity_name")
colnames(ydata) <- "activity_id"
ydata <- merge(ydata,activitylabel,by ='activity_id',sort=FALSE)  #keeping sort=FALSE to preserve the order

# reading the features.txt file to label the column Names correctly for X data
ftrspath <- 'UCI HAR Dataset\\features.txt'
ftrs <- read.table(ftrspath,stringsAsFactors=FALSE)
ftrs <- read.table(ftrspath)
ftrs <- t(ftrs[2])
colnames(xdata)<- ftrs

#From all the measurements, getting only the mean and standard dev variables, meanFreq columns are ignored
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

