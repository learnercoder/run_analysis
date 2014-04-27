run_analysis
============

Course Era assignment work
==================

Pls Note:
- Install 'reshape' and 'reshape2' packages 
- The directory "UCI HAR Dataset" should be in the working directory of your R ( getwd() )
- The script processes data for mean and std columns, meanFreq columns have also been ignored
- The script has also been commented with each step explained correctly, please refer that in case of any confussion

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



