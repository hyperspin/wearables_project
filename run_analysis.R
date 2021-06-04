# wearables project final.
library(dplyr)
datasetinfo <- "http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions"

projectURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Read features and labels data
# Pl. set uciDir to the parent directory for testing. Thanks.
uciDir <- setwd("/Users/kumarnv/Rprojects/gettingData/projectGettingData/UCI HAR Dataset/wearables_project")
setwd(uciDir)

featuresFile <- "features.txt" 
featuresData <- read.csv(featuresFile, sep="",header= FALSE)[2] # features names are in 2nd column, (561,1)
activityLabelsFile <- "activity_labels.txt" 
activityLabelsData <- read.csv(activityLabelsFile,sep="",header=FALSE) # dim 6,2

# read train data
xTrainDataFile <- "X_train.txt"
yTrainDataFile <- "y_train.txt"
subjectTrainDataFile <- "subject_train.txt"
trainDir <- "./train/"
setwd(trainDir)
subjectTrainData <- read.csv(subjectTrainDataFile, sep="", header=FALSE) # 7352,1
names(subjectTrainData) <- "SubjectID"
xTrainData <- read.csv(xTrainDataFile, sep = "", header = FALSE) # 7352, 561
names(xTrainData) <- featuresData[,1]
yTrainData <- read.csv(yTrainDataFile, sep = "", header = FALSE) # labels 7352,1
names(yTrainData) <- "ActivityLabel"

# Merge subjectInfo, ActivityInfo & Sensor Data for training
mergedTrainData <- cbind(subjectTrainData,yTrainData,xTrainData) # 7352, 563

## Read  test Data
setwd(uciDir)
testDir <- "./test/"
dirPath <- testDir  
xTestDataFile <- "X_test.txt"
yTestDataFile <- "y_test.txt"
subjectTestFile <- "subject_test.txt"
setwd(testDir)
subjectTestData <- read.csv(subjectTestFile, sep = "", header = FALSE) # 2947,1
names(subjectTestData) <- "SubjectID"
xTestData <- read.csv(xTestDataFile, sep = "", header = FALSE) # it looks for files in the currentdir
yTestData <- read.csv(yTestDataFile, sep = "", header = FALSE) # labels 2947,1
names(xTestData) <- featuresData[,1]
names(yTestData) <- "ActivityLabel"
setwd(uciDir)

# merge Subject info, activity labels and sensor data for test
mergedTestData <- cbind(subjectTestData,yTestData,xTestData)

#merge test and train data
mergedData <- rbind(mergedTrainData,mergedTestData)

#  Extract only the measurements on the mean and standard deviation for each measurement.
mergedSubSet <- mergedData[ grepl("Subject|activity|std|mean", names(mergedData), ignore.case = TRUE) ] #10299,88

#  Use descriptive activity names to name the activities in the data set
mergedSubSet$ActivityLabel <- trimws(activityLabelsData[mergedSubSet$ActivityLabel,2])

# Rename columns meaningfully
names(mergedSubSet) <- gsub("Acc", "Accelerometer", names(mergedSubSet))
names(mergedSubSet) <- gsub("BodyBody", "Body", names(mergedSubSet))
names(mergedSubSet) <- gsub("Mag", "Magnitude", names(mergedSubSet))
names(mergedSubSet) <- gsub("gravity", "Gravity", names(mergedSubSet))
names(mergedSubSet) <- gsub("-mean", "Mean", names(mergedSubSet))
names(mergedSubSet) <- gsub("^t", "Time", names(mergedSubSet))
names(mergedSubSet) <- gsub("^f", "Frequency", names(mergedSubSet))
names(mergedSubSet) <- gsub("std()", "STD", names(mergedSubSet))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable
#for each activity and each subject
tidyData <- mergedSubSet %>% group_by( SubjectID, ActivityLabel) %>% summarize_each(tibble::lst(mean))
write.table(tidyData, "./tidy_wearable.txt", row.names= FALSE, quote=FALSE)



