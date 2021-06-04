---
title: "README"
author: "vk"
date: "5/26/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```



## Getting and Cleaning Data

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.You will be required to submit:
a tidy data set as described below
a link to a Github repository with your script for performing the analysis
codeBook.md that describes the variables, the data, and any work that you performed to clean up the data
README.md that explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:


http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Good luck!

## Code explanations
Created a directory (UCI HAR Dataset) containing all the data for this project.

Downloaded the zipfile  from the link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
unzipped it.

The dataset includes the following files:
=========================================

- 'README.txt': Information about the data set

- 'features_info.txt': Information about  the features. 

- 'features.txt': List of all features.

- 'activity_labels.txt': mapping of activity labels with their activity name.

- 'train/subject_train.txt': ID's of the subjects in training set

- 'train/X_train.txt': sensor data for the Training set.

- 'train/y_train.txt': Activity labels(1-6) for the traing set.

- 'test/subject_test.txt': ID's of the subjects in testing set

- 'test/X_test.txt': Sensor dats for the test set.

- 'test/y_test.txt': Test labels.

- 'Inertial Signals': directory containing accelerometer and gyroscope data (x,y and z) for test and training sets.



# 1) Read features and activity labels
```
featuresData: Features data from the 2nd column of the file features.txt
activityLabelsData: activity lables from the file activity_labels.txt

featuresFile <- "features.txt" 
featuresData <- read.csv(featuresFile, sep="",header= FALSE)[2] # features names are in 2nd column, (561,1)
#activityLabelsFile <- list.files(uciDir)[1]
activityLabelsFile <- "activity_labels.txt" 
activityLabelsData <- read.csv(activityLabelsFile,sep="",header=FALSE) # dim 6,2
```

# 2) Read subject id's, training data and corresponding activities
subjectTrainData : subject ID's
xTrainData:       sensor data 
yTrainData:       activity labels

```   ## Read subject id's, training data and corresponding activities
   xTrainDataFile <- "X_train.txt"
   yTrainDataFile <- "y_train.txt"
   subjectTrainDataFile <- "subject_train.txt"
   subjectTrainData <- read.csv(subjectTrainDataFile, sep="", header=FALSE) # 7352,1
   xTrainData <- read.csv(xTrainDataFile, sep = "", header = FALSE) # 7352, 561
   yTrainData <- read.csv(yTrainDataFile, sep = "", header = FALSE) # labels 7352,1
```
#3) rename columns of training data and subjectTrainData

```
names(subjectTrainData) <- "SubjectID"
names(yTrainData) <- "ActivityLabel"
names(xTrainData) <- featuresData[,1]
```
#4) merge subject Id's,activity labels and traing data to form a complete data set of training data

```
mergedTrainData <- cbind(subjectTrainData,modyTrainData,xTrainData) # 7352, 563
```
# 5) mergedTestData: repeat the steps 2-4 for test data to form a complete data set for the testing
 
 ```
 #... skipping code similar to the training data shown above.
 mergedTestData <- cbind(subjectTestData,yTestData,xTestData)
 ```
# 6) mergedData: merge test and train data 
 ```
 mergedData <- rbind(mergedTestData,mergedTrainData) # 10299, 563
```

# 7) mergedSubSet: Extracts only the measurements on the mean and standard deviation for each measurement.
```
names(mergedData) <- featuresData[ ,1]
mergedSubSet <- mergedData[ grepl("subject|activity|std|mean", names(mergedData), ignore.case = TRUE) ] #10299,88
```
# 8) Use descriptive activity names to name the activities in the data set

```
mergedSubSet$ActivityLabel <- trimws(activityLabelsData[mergedSubSet$ActivityLabel,2])
```
# 9) Rename columns meaningfully
```
names(mergedSubSet) <- gsub("Acc", "Accelerometer", names(mergedSubSet))
names(mergedSubSet) <- gsub("BodyBody", "Body", names(mergedSubSet))
#etc
```
# 10) Tidy Data
```
tidyData <- mergedSubSet %>% group_by( SubjectID, ActivityLabel) %>% summarize_each(tibble::lst(mean))
write.table(tidyData, "./tidy_wearable.txt", row.names= FALSE, quote=FALSE)
```
