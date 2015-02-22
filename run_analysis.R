
trainingData = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
trainingData[,562] = read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
trainingData[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testingData = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testingData[,562] = read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
testingData[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])


wholeData = rbind(training, testing)

cols <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[cols,]
cols <- c(cols, 562, 563)
wholeData <- wholeData[cols,]

colnames(wholeData) <- tolower(c(features$V2, "Activity", "Subject"))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  wholeData$activity <- gsub(currentActivity, currentActivityLabel, wholeData$activity)
  currentActivity <- currentActivity + 1
}

wholeData$activity <- as.factor(wholeData$activity)
wholeData$subject <- as.factor(wholeData$subject)

tidy = aggregate(wholeData, by=list(activity = wholeData$activity, subject=wholeData$subject), mean)

tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")