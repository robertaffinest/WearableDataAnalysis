# According to the Peer-graded Assignment of the "Getting and Cleaning Data Course Project",
# this R script, run_analysis.R, performs the following tasks:
# 1.	Merges the training and the test sets to create one data set.
# 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.	Uses descriptive activity names to name the activities in the data set
# 4.	Appropriately labels the data set with descriptive variable names. 
# 5.	From the data set in step 4, creates a second, independent tidy data set
#     with the average of each variable for each activity and each subject.

# Utility function to load data 
loadData <- function(data_path, activity_path, subject_path, features_needed, feature_names) {
  data <- fread(data_path)[, features_needed, with = FALSE]  # Load measurements
  activity <- fread(activity_path, col.names = "activity")  # Load activities
  subject <- fread(subject_path, col.names = "subject_no")  # Load subjects
  setnames(data, colnames(data), feature_names)  # Rename columns
  return(cbind(activity, subject, data))  # Combine and return data
}

# Set up environment 
library("data.table")
library(dplyr)

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_zip_file <- file.path(path, "dataset.zip")  # Local path for the zip file

# Avoid to download if the local file already exists.
if (!file.exists(local_zip_file)){
  download.file(url, local_zip_file)
}  

# Avoid to unzip if the data folder already exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(local_zip_file) 
}

# Load features and activity labels 
features_labels <- fread(file.path(path, "UCI HAR Dataset/features.txt"),
                         col.names = c("index", "feature_names"))

activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"),
                         col.names = c("class_labels", "activity_names"))

# Reading training datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features_labels$feature_names)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Reading test datasets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features_labels$feature_names)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

#Step 1 : Merging the test and training sets to create one data set

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

#Step 2:Extracts only the measurements on the mean and standard deviation for each measurement.
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


#Step 3: Uses descriptive activity names to name the activities in the data set.
TidyData$code <- activity_labels[TidyData$code, 2]

#Step 4: Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
