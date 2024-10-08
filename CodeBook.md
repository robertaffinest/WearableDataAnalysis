# Code Book for Human Activity Recognition Dataset

This code book provides a detailed description of the variables, the transformations performed on the data, and summaries relevant to the analysis.

## Dataset Overview

The dataset consists of measurements collected from the accelerometers of the Samsung Galaxy S smartphone. The data captures various human activities such as walking, sitting, and standing.

## Variables Description

### Main Dataset Variables

| Variable Name                  | Description                                                      | Unit                |
|--------------------------------|------------------------------------------------------------------|---------------------|
| `subject`                      | Identifier for each subject in the dataset.                     | Integer             |
| `activity`                     | Activity label (e.g., WALKING, SITTING)                        | Categorical         |
| `tBodyAcc_mean_X`             | Mean of body acceleration along the X-axis.                     | g (gravity)         |
| `tBodyAcc_mean_Y`             | Mean of body acceleration along the Y-axis.                     | g (gravity)         |
| `tBodyAcc_mean_Z`             | Mean of body acceleration along the Z-axis.                     | g (gravity)         |
| `tBodyAcc_std_X`              | Standard deviation of body acceleration along the X-axis.       | g (gravity)         |
| `tBodyAcc_std_Y`              | Standard deviation of body acceleration along the Y-axis.       | g (gravity)         |
| `tBodyAcc_std_Z`              | Standard deviation of body acceleration along the Z-axis.       | g (gravity)         |
| ...                            | ... (Add other variables as needed)                             | ...                 |

### Activity Labels

| Activity Code | Activity Name     |
|---------------|--------------------|
| 1             | WALKING            |
| 2             | WALKING_UPSTAIRS   |
| 3             | WALKING_DOWNSTAIRS |
| 4             | SITTING            |
| 5             | STANDING           |
| 6             | LAYING             |

## Data Transformations

1. **Merging Datasets**: The training and test datasets were merged to create a single dataset.
2. **Extracting Measurements**: Only the measurements on the mean and standard deviation were retained for analysis.
3. **Labeling Activities**: Activity codes were replaced with descriptive activity names.
4. **Descriptive Variable Names**: Variable names were updated to be more descriptive and understandable.
5. **Creating Tidy Dataset**: A new tidy dataset was created, summarizing the average of each variable for each activity and subject.

## Summary of the Dataset

The final dataset contains measurements for each subject and activity, facilitating analysis and insights into human activity patterns based on accelerometer data.

## References

- UCI Machine Learning Repository: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
