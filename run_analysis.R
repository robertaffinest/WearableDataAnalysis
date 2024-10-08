
# ------------------------------------------------------------------------------
# Function to check, install, and load a package
load_package <- function(pkg) {
  # Check if the package is installed
  if (!require(pkg, character.only = TRUE)) {
    # Try to install the package if it's not found
    tryCatch({
      install.packages(pkg)  # Install the package
      library(pkg, character.only = TRUE)  # Load the package
      cat(paste("Successfully installed and loaded:", pkg, "\n"))
    }, error = function(e) {
      # Error handling in case the package fails to install
      cat(paste("Error installing package:", pkg, "\n"))
      cat("Error message: ", e$message, "\n")
    })
  } else {
    # If the package is already installed, just load it
    cat(paste(pkg, "is already loaded.\n"))
  }
}

# ENVIRONMENT SETUP ------------------------------------------------------------

# Load data.table, reshape2, and gsubfn packages
load_package("data.table")
load_package("reshape2")
load_package("gsubfn")

# DOWNLOAD THE DATA FOR THE PROJECT --------------------------------------------

# Set the working directory path
path <- getwd()  # Get the current working directory

# Define the URL of the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Create the path for the local ZIP file
local_zip_file <- file.path(path, "dataset.zip")

# Try downloading the file and check for errors
tryCatch({
  # Download the dataset from the given URL
  download.file(url, local_zip_file)
  cat("File downloaded successfully.\n")
}, error = function(e) {
  # Handle download error
  cat("Error in downloading file: ", e$message, "\n")
  stop("Exiting due to download failure.")
})

# Try unzipping the file and check for errors
tryCatch({
  # Unzip the downloaded file
  unzip(zipfile = local_zip_file)
  cat("File unzipped successfully.\n")
}, error = function(e) {
  # Handle unzip error
  cat("Error in unzipping file: ", e$message, "\n")
  stop("Exiting due to unzip failure.")
})

# Check if the directory "UCI HAR Dataset" exists after unzipping
dataset_dir <- file.path(path, "UCI HAR Dataset")
if (file.exists(dataset_dir)) {
  cat("Dataset directory found: ", dataset_dir, "\n")
} else {
  cat("Dataset directory not found. Please check if the file was unzipped correctly.\n")
}

# -----------------------------------------------------------------------------
# The final 'measurements' vector will contain descriptive names for the mean and std features.

# Load activity labels from the dataset
activityLabels <- fread(
  file.path(path, "UCI HAR Dataset/activity_labels.txt"), # Construct file path
  col.names = c("classLabels", "activityNames") # Set column names
)

# Load features (measurements) from the dataset
features <- fread(
  file.path(path, "UCI HAR Dataset/features.txt"), # Construct file path
  col.names = c("index", "featureNames") # Set column names
)

# Extract features that contain 'mean' or 'std' in their names
# grep returns the indices of matches for the given pattern
featuresNeeded <- grep("(mean|std)\\(\\)", features[, featureNames])

# Select the feature names corresponding to the extracted indices
measurements <- features[featuresNeeded, featureNames]

# Rename the selected features for better understanding
# Using gsub to replace patterns in the feature names
measurements <- gsub("^t", "Time", measurements)           # Replace 't' prefix with 'Time'
measurements <- gsub("^f", "Frequency", measurements)      # Replace 'f' prefix with 'Frequency'
measurements <- gsub("Acc", "Accelerometer", measurements) # Replace 'Acc' with 'Accelerometer'
measurements <- gsub("Gyro", "Gyroscope", measurements)    # Replace 'Gyro' with 'Gyroscope'
measurements <- gsub("Mag", "Magnitude", measurements)     # Replace 'Mag' with 'Magnitude'
measurements <- gsub("BodyBody", "Body", measurements)     # Replace 'BodyBody' with 'Body'
measurements <- gsub("\\(\\)", "", measurements)           # Remove parentheses

# -----------------------------------------------------------------------------


