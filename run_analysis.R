# According to the Peer-graded Assignment of the "Getting and Cleaning Data Course Project",
# this R script, run_analysis.R, performs the following tasks:
# 1.	Merges the training and the test sets to create one data set.
# 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.	Uses descriptive activity names to name the activities in the data set
# 4.	Appropriately labels the data set with descriptive variable names. 
# 5.	From the data set in step 4, creates a second, independent tidy data set
#     with the average of each variable for each activity and each subject.

# Load necessary library
library(data.table)

# Helper function to load and combine subject, activity, and measurement data
# for either the "train" or "test" dataset. Only the mean and standard deviation
# measurements are loaded based on the passed `mean_std_indices`.
load_dataset <- function(type, mean_std_indices) {
  # Load measurements (X data) with only mean and std columns based on indices
  x_data <- fread(file.path("UCI HAR Dataset", type, paste0("X_", type, ".txt")))[, ..mean_std_indices]
  # Load activity data (Y data), setting the column name to 'activity'
  y_data <- fread(file.path("UCI HAR Dataset", type, paste0("y_", type, ".txt")), col.names = "activity")
  # Load subject data, setting the column name to 'subject'
  subject_data <- fread(file.path("UCI HAR Dataset", type, paste0("subject_", type, ".txt")), col.names = "subject")
  # Combine subject, activity, and measurements into one dataset using cbind
  return(cbind(subject_data, y_data, x_data))
}

# Set the working directory and data paths
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_zip_file <- file.path(path, "dataset.zip")

# Download and unzip the dataset only if needed
if (!file.exists(local_zip_file)) {
  download.file(url, local_zip_file, method = "curl")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip(local_zip_file)
}

# Load features and activity labels
features <- fread(file.path("UCI HAR Dataset", "features.txt"), col.names = c("index", "feature_names"))
activity_labels <- fread(file.path("UCI HAR Dataset", "activity_labels.txt"), col.names = c("activity", "activity_names"))

# Extract the indices of columns that have mean and standard deviation measurements
mean_std_indices <- grep("(mean|std)\\(\\)", features$feature_names)

train_data <- load_dataset("train", mean_std_indices)
test_data <- load_dataset("test", mean_std_indices)  

# Step 1: Merge the training and test sets to create one data set
merged_data <- rbind(train_data, test_data)

# Step 2: Apply descriptive activity names
merged_data$activity <- factor(merged_data$activity, levels = activity_labels$activity, labels = activity_labels$activity_names)

# Step 3: Appropriately label the data set with descriptive variable names
feature_names <- features$feature_names[mean_std_indices]
feature_names <- gsub("^t", "Time", feature_names)
feature_names <- gsub("^f", "Frequency", feature_names)
feature_names <- gsub("Acc", "Accelerometer", feature_names)
feature_names <- gsub("Gyro", "Gyroscope", feature_names)
feature_names <- gsub("Mag", "Magnitude", feature_names)
feature_names <- gsub("BodyBody", "Body", feature_names)
feature_names <- gsub("-mean\\(\\)", "Mean", feature_names, ignore.case = TRUE)
feature_names <- gsub("-std\\(\\)", "STD", feature_names, ignore.case = TRUE)
setnames(merged_data, c("subject", "activity", feature_names))

# Step 4: Create a second, independent tidy data set with the average of each variable for each activity and each subject
final_data <- merged_data[, lapply(.SD, mean), by = .(subject, activity)]

# Step 5: Write the final tidy data set to a file
write.table(final_data, "tidydataset.txt", row.names = FALSE)
