# Utility function to check, install, and load a package -----------------------
loadPackage <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    tryCatch({
      install.packages(pkg)  # Install the package
      library(pkg, character.only = TRUE)  # Load the package
      message("Successfully installed and loaded: ", pkg)
    }, error = function(e) {
      message("Error installing package: ", pkg)
      message("Error message: ", e$message)
    })
  }
}

# Utility function to download and unzip a file --------------------------------
downloadAndUnzip <- function(url, dest_file) {
  tryCatch({
    download.file(url, dest_file)  # Download the file
    message("File downloaded successfully.")
    unzip(dest_file)  # Unzip the downloaded file
    message("File unzipped successfully.")
  }, error = function(e) {
    message("Error in downloading/unzipping: ", e$message)
    stop("Exiting due to download/unzip failure.")
  })
}

# Utility function to load data ------------------------------------------------
loadData <- function(data_path, activity_path, subject_path, features_needed, feature_names) {
  data <- fread(data_path)[, features_needed, with = FALSE]  # Load measurements
  activity <- fread(activity_path, col.names = "activity")  # Load activities
  subject <- fread(subject_path, col.names = "subject_no")  # Load subjects
  setnames(data, colnames(data), feature_names)  # Rename columns
  return(cbind(activity, subject, data))  # Combine and return data
}

# Set up environment -----------------------------------------------------------
loadPackage("data.table")
path <- getwd()  # Get current working directory
url <- paste0("https://d396qusza40orc.cloudfront.net/",
              "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
local_zip_file <- file.path(path, "dataset.zip")  # Local path for the zip file

downloadAndUnzip(url, local_zip_file)  # Download and unzip dataset

# Load features and activity labels -----------------------------------------
activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"),
                         col.names = c("class_labels", "activity_names"))

features_labels <- fread(file.path(path, "UCI HAR Dataset/features.txt"),
                  col.names = c("index", "feature_names"))

# Select the features that contain 'mean()' or 'std()' in their names
features_needed <- grep("(mean|std)\\(\\)", features_labels[, feature_names])
measurements <- features_labels[features_needed, feature_names]

# Rename the measurements for better readability
measurements <- gsub("^t", "Time", measurements)            # Replace 't' with 'Time'
measurements <- gsub("^f", "Frequency", measurements)       # Replace 'f' with 'Frequency'
measurements <- gsub("Acc", "Accelerometer", measurements)  # Replace 'Acc' with 'Accelerometer'
measurements <- gsub("Gyro", "Gyroscope", measurements)     # Replace 'Gyro' with 'Gyroscope'
measurements <- gsub("Mag", "Magnitude", measurements)      # Replace 'Mag' with 'Magnitude'
measurements <- gsub("BodyBody", "Body", measurements)      # Replace 'BodyBody' with 'Body'
measurements <- gsub("\\(\\)", "", measurements)            # Remove parentheses

# Load and process train and test data --------------------------------------
train_data <- loadData(file.path(path, "UCI HAR Dataset/train/X_train.txt"),
                       file.path(path, "UCI HAR Dataset/train/y_train.txt"),
                       file.path(path, "UCI HAR Dataset/train/subject_train.txt"),
                       features_needed, measurements)

test_data <- loadData(file.path(path, "UCI HAR Dataset/test/X_test.txt"),
                      file.path(path, "UCI HAR Dataset/test/y_test.txt"),
                      file.path(path, "UCI HAR Dataset/test/subject_test.txt"),
                      features_needed, measurements)

# Combine train and test data -----------------------------------------------
combined_data <- rbind(train_data, test_data)

# Label the 'activity' column with descriptive activity names
combined_data[["activity"]] <- factor(combined_data[["activity"]],
                                      levels = activity_labels[["class_labels"]],
                                      labels = activity_labels[["activity_names"]])

# Convert 'subject_no' to factor
combined_data[["subject_no"]] <- as.factor(combined_data[["subject_no"]])

# Reshape and calculate mean for each subject and activity ------------------
melted_data <- melt.data.table(combined_data, id = c("subject_no", "activity"))
tidy_data <- dcast(melted_data, subject_no + activity ~ variable, mean)

# Write the tidy data to a file ---------------------------------------------
fwrite(tidy_data, file = "tidy_data.txt")
