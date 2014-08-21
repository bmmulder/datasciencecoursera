**Data Source**

The original data can be downloaded at the following link [Samsung dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
For the detailed description of the data, refer to the following link [Data description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

*For user convenience the script run_analysis.R will download and unpack the data into a data folder within the current work directory.*

**Dataset Directory**

A dataset directory in the current working directory is set up on sourcing the script and called "data/".

**Merging the training and the test set**

The merging procedure consists of the steps;

1. Load X_train.txt, y_train.txt, and subject_train.txt and create a traing set.
2. Load X_test.txt, y_test.txt, and subject_test.txt and create a test set.
3. Append the test set to the training set, creating a dataset variable.
4. A new dataset is created extracting with only columns with mean() and std() in their name. 	
5. The dataset is written to a tab-delimited file called "movementmonitor.txt".

**Adding labels to columns**

The values of activities are assigned to a variable by reading activity_labels.txt file.

**Analysis of the data**

1. A new dataset activity.subject is created containing a pivot of for each subject and activity.
2. A mean is applied on this dataset to result in table called average.activity.subject with the average for each activities and subjects.
3. The table is written to the table to the file called "activity_averages.txt".

**Description of the output file average_table.txt**

Row variables 

1. The row variables Show the mean for each measurement. 
2. The feature label description should be referred to "feature_info.txt" in the original data source.


Column variables

The column variables show a combination of activity and subject.

1. Activity were classified into 6 classes (WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
2. Subjects (volunteers) were indicated with a number from 1 to 30. 
3. The column labels are shown as the form of activity and subject split by a period. For example, "WALKING.1" denotes the condition of WALKING and subject 1.