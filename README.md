# Getting and Cleaning Data - Coursera - Project 1

## Project Description
The aim of this project is to write a script to produce a tidy dataset from the Human Activity Recognition Using Smartphones Dataset which is accessible here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A description of the data is available here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

### Files included

#### run_analysis.R
This file contains an R script that will produce a tidy data set from the raw data files available from the UCI-HAR data available from the URL above.

If the UCI-HAR zip has been extracted, and its contents are in the same directory as the R script when run, then a tidy dataset will be produced called UCI-HAR-tidy.txt

This file can then be read into R using read.table("UCI-HAR-tidy.txt")

#### CodeBook.md
This file explains what the variables in the tidy datset correspond to.

#### README.md
This file, that you are reading, right now. 


## Project requirements and decisions and steps to achieve them
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


### 1. Merges the training and the test sets to create one data set

To achieve this, each of the data files for the training and test data sets were read into R data frames using the read.table function. 

It was noted at this point that each of the files in the training set contained 7352 observations (rows), and each of the files in the test set contained 2947 observations. This meant that we could probably join each of the files in each set by combining the columns to create a wider dataset. The cbind function was used to achieve this.

It was also noted that the corresponding files in each of the train and test sets contained the same number of columns(variables) i.e 561 vars in x_test.txt and x_train.txt, 1 var in y_test.txt and y_train.txt, and 1 var in subject_train.txt and subject_test.txt. This indicated that one set of data could be appended to the other, row by row. The rbind function was used to add rows like this.


### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

The next thing to do was to pull out only the measurements we need, i.e. the mean and standard deviation measurements. One of the files, features.txt contains all the names of the features that were tracked. These names mapped onto variables in the x_test and y_test files. Names typically looked like this: tBodyAcc-mean()-X and tBodyAcc-std()-Y, which represented the means and standard deviations of the original set of measurements taken. So it looked like they values could be extracted using text matching on the variable names. A decision was made to extract anything that looked like mean() and std(), but not things like meanFreq() or gravityMean, as these seemed to more closely match what was required.

A combination of make.names, and grep functions were used to achieve this.


### 3. Uses descriptive activity names to name the activities in the data set
This was achieved by mapping the activity names e.g. WALKING, STANDING etc. to the numbers in the activity column that we merged with the data set in step 1. The labels were read from the activity_labels.txt file, and the substitution was based on the value in each row for that column.

### 4. Appropriately labels the data set with descriptive variable names.
In step 2 only the data we wanted to keep was extracted from the data set. Here the names associated with the extracted vars was needed. Using the colnames function it was possible to change the default variable names created in the R import to the ones provided in the features.txt file. Care was taken to remove any invalid characters that R might have trouble with, but while still maintained readability. The Activity and Subject columns were manually renamed

### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
This was achieved with the aggregate function so that we could group by activity and subject and determine the mean. The result was output to a text file



