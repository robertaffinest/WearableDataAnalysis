
## Overview

This repository contains the code and documentation for the final project of the "Getting and Cleaning Data" course on Coursera, part of the Data Science Specialization offered by Johns Hopkins University.

The purpose of this project is to clean and analyze data collected from the accelerometers of Samsung Galaxy S smartphones, creating a tidy dataset.

## Dataset

The data used in this project is the **Human Activity Recognition Using Smartphones Dataset**, available from the UCI Machine Learning Repository.
The dataset contains sensor data collected from 30 subjects while performing six different activities (walking, walking_upstairs, walking_downstairs, sitting, standing and laying) using the accelerometers and gyroscopes of Samsung Galaxy S smartphones worn by the participants.

A full description of the dataset is available at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
The original dataset can be accessed here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

## Files in This Repository

- `run_analysis.R`: The R script that processes the data and creates a tidy dataset.
- `CodeBook.md`: A codebook that describes the variables, data, and transformations performed to clean the dataset.
- `tidydataset.txt`: The final tidy dataset output file, which contains the average of each variable for each activity and each subject.

## How to Run the Script

1. Clone this repository to your local machine.

2. Download the dataset:
   - The `run_analysis.R` script automatically downloads and unzips the dataset from the [UCI HAR Dataset](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
   - Alternatively, you can manually download the dataset from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and place it in the working directory.

3. Run the `run_analysis.R` script to generate the final tidy dataset:
   ```r
   source("run_analysis.R")
   ```

4. The final tidy dataset will be saved as `tidydataset.txt` in your working directory.

## Expected Output

The script performs the following steps:
1. Merges the training and test datasets.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to label the activities in the dataset.
4. Appropriately labels the dataset with descriptive variable names.
5. Creates a second, independent tidy dataset that contains the average of each variable for each activity and each subject.

## Final Tidy Dataset

The final dataset, `tidydataset.txt`, contains:
- **180 observations** (one for each combination of 30 subjects and 6 activities).
- **68 variables**: These include subject IDs, activity names, and the mean values for 66 feature measurements (e.g., accelerometer and gyroscope data).

### How to Load the Final Tidy Dataset

To load the final tidy dataset into R:
```r
final_data <- read.table("tidydataset.txt", header = TRUE)
```

## Project Structure

```
WearableDataAnalysis/
│
├── CodeBook.md              # Detailed description of the variables and data transformations
├── tidydataset.txt         # The final tidy dataset
├── README.md                # This file
└── run_analysis.R           # R script to clean and process the data
```

## Acknowledgments

- The dataset is provided by the UCI Machine Learning Repository: [Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
- Special thanks to Coursera and the "Getting and Cleaning Data" course instructors for guiding this project.
```
