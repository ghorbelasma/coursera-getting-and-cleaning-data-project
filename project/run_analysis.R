
## unzip the dataset:
unzip("data.zip")

## read activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features <- as.character(features[,2])


# Extract only the data on mean and standard deviation
featuresInd <- grep(".*mean.*|.*std.*", features)
features <- features[featuresInd]


# Clean the features names
features = gsub('-mean', 'Mean', features)
features = gsub('-std', 'Std', features)
features <- gsub('[-()]', '', features)




# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresInd]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

colnames(train)=features
train <- cbind(subject=trainSubjects[,1], activity=trainActivities[,1], train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresInd]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

colnames(test)=features
test <- cbind(subject=testSubjects[,1], activity=testActivities[,1], test)

## combine both data sets

allData <- rbind(train, test)

##  turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = as.character(activityLabels[,2]))
allData$subject <- as.factor(allData$subject)

## The average of each variable for each activity and each subject.
##install.packages("reshape2")
##library(reshape2)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

