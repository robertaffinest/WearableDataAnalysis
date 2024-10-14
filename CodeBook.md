# CodeBook for the WearableDataAnalysis Project

## Overview

This codebook outlines the data and transformations performed for the project "Getting and Cleaning Data"
as part of the Coursera Data Science Specialization.
The raw data originates from the "Human Activity Recognition Using Smartphones" dataset.
This document details the steps taken to process the raw data and create a tidy dataset.

## Source Data

The dataset used in this project was collected from accelerometers and gyroscopes embedded in Samsung Galaxy S smartphones.
A full description of the dataset is available at: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The original dataset can be accessed here: [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


## Study Design

The experiment involved 30 volunteers who performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone on their waist. The embedded sensors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The dataset contains the measurements and activity labels for both the training and test sets.

## Data Files

- `features.txt`: Contains the names of 561 feature variables measured during the experiment.
- `activity_labels.txt`: Links activity IDs with descriptive activity names.
- `X_train.txt`, `X_test.txt`: The datasets for training and test features.
- `y_train.txt`, `y_test.txt`: Labels (activity codes) for the training and test datasets.
- `subject_train.txt`, `subject_test.txt`: Subject identifiers for the training and test sets.

## Variables

### Original Variables

- **561 Feature Variables**: These include time and frequency domain signals captured by the accelerometer and gyroscope sensors. Example features include:
  - `tBodyAcc-mean()-X`: Time-domain body acceleration mean value in the X direction.
  - `tBodyAcc-std()-Y`: Time-domain body acceleration standard deviation in the Y direction.
  - `fBodyGyro-meanFreq()-Z`: Frequency-domain body gyroscope mean frequency in the Z direction.

### Activity Labels
The activities performed by the subjects are encoded as integers (1-6), which are mapped to their descriptive names:
  1. WALKING
  2. WALKING_UPSTAIRS
  3. WALKING_DOWNSTAIRS
  4. SITTING
  5. STANDING
  6. LAYING

### Subject IDs
Each subject is identified by an integer between 1 and 30, representing the individual volunteer in the study.

## Data Cleaning Process

The following transformations were applied to the raw data:

1. **Merging the Training and Test Sets**:
   - The training (`X_train`, `y_train`, `subject_train`) and test (`X_test`, `y_test`, `subject_test`) datasets were combined to create one dataset using `rbind()` and `cbind()`.

2. **Extracting Mean and Standard Deviation Measurements**:
   - From the merged dataset, only the measurements that represent the mean (`mean()`) and standard deviation (`std()`) were retained. This was done using the `contains()` function to filter the relevant columns.

3. **Using Descriptive Activity Names**:
   - The numeric activity codes (1-6) in the dataset were replaced with descriptive activity names by mapping them to the `activity_labels.txt` file.

4. **Labeling the Data Set with Descriptive Variable Names**:
   - The variable names were made more descriptive by expanding abbreviations and removing special characters using the following substitutions:
     - `Acc` → `Accelerometer`
     - `Gyro` → `Gyroscope`
     - `BodyBody` → `Body`
     - `Mag` → `Magnitude`
     - `^t` → `Time`
     - `^f` → `Frequency`
     - `-mean()` → `Mean`
     - `-std()` → `STD`

5. **Creating a Second, Independent Tidy Dataset**:
   - A second tidy dataset was created where the average of each variable was calculated for each activity and each subject.

## Final Dataset Structure

The final tidy dataset contains 180 observations and 68 variables:
- **180 Observations**: Each observation corresponds to a unique combination of subject (30 individuals) and activity (6 activities), resulting in 30 x 6 = 180 rows.
- **68 Variables**: These include the subject identifier, the activity label, and 66 mean and standard deviation measurements from the original feature set.

### Key Variables in the Final Dataset

- `subject`: The identifier of the volunteer (1-30).
- `activity`: The activity performed (one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
- 66 feature variables representing the mean values of the accelerometer and gyroscope data (e.g., `TimeBodyAccelerometerMeanX`, `FrequencyBodyGyroscopeSTDZ`, etc.).

## How to Load the Final Dataset

To load the tidy dataset, you can use the following R command:
```r
final_data <- read.table("tidydataset.txt", header = TRUE)
```
