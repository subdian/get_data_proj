#1 Concatenate the training and the test sets to create one data set, by common names
#1.1 Read in all the training data files
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
sub_train <- read.table("train/subject_train.txt")

#1.2 Use cbind to concatenate the files - add the y training data (the labels) as the first column since it will be nicer to have them at the front
train_y_sub <- cbind(y_train, sub_train)

#1.3 Add the subject number as the second column
train_y_sub_x <- cbind(train_y_sub, x_train)

#1.4 Read in all the test data files
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
sub_test <- read.table("test/subject_test.txt")

#1.5 Use cbind to concatenate the files - add the y training data (the labels) as the first column since it will be nicer to have them at the front
test_y_sub <- cbind(y_test, sub_test)

#1.6 Add the subject number as the second column
test_y_sub_x <- cbind(test_y_sub, x_test)

#1.7 Contenate the rows of each of our data frames now
combined_train_test <- rbind(train_y_sub_x, test_y_sub_x)


#2 Extracts only the measurements on the mean and standard deviation for each measurement
#2.1 Read in feature names from features file
feature_names <- read.table("features.txt")

#2.2 Remove unwanted characters from the names
feature_names_valid <- make.names(feature_names[,2])

#2.3 Get rows which now have .mean. or .std. using regular expression
col_nums <- grep("\\.mean\\.|\\.std\\.",feature_names_valid)

#2.4 Get the tidy names we're interested in 
tidy_feature_names <- feature_names_valid[col_nums]

#2.5 Tidy them further
tidy_feature_names <- gsub("(\\.\\.\\.)|(\\.\\.)", ".", tidy_feature_names)
tidy_feature_names <- gsub("\\.$", "", tidy_feature_names)

#2.6 Select only these columns from the merged dataset 
# - Add 2 to shift it by two columns as we added to columns to the front of our data frame earlier for Activity & Subject
cols <- c(1,2, col_nums+2)
mean_std_data <- combined_train_test[,cols]



#3 Uses descriptive activity names to name the activities in the data set
# Basically we want to substitute the activity names in the file activity_labels.txt with the y data column in our data frame

#3.1 Read the activity labels file
activity_labels <- read.table("activity_labels.txt")

#3.2 Remove unwanted columns, so now we just have the labels
activity_labels <- activity_labels[,2]

#3.3 Substitute
mean_std_data[ ,1] <- activity_labels[mean_std_data[,1]]



#4 Appropriately labels the data set with descriptive variable names. 
#4.1 Lets do the first two manually
colnames(mean_std_data)[1] <- "Activity"
colnames(mean_std_data)[2] <- "Subject"

#4.2 Now apply the tidy feature names to the rest of the columns
colnames(mean_std_data)[3:68] <- tidy_feature_names



#5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#5.1 Use aggregate function to group and average the data
tidy_mean_df <- aggregate(.~Subject+Activity, FUN=mean, data=mean_std_data)

#5.2 Output data set to file
write.table(tidy_mean_df, "UCI_HAR_tidy.txt")


