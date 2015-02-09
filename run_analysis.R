#########################################################################################
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#########################################################################################
library("plyr")
################################################################
# read in all data
################################################################
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")
x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")
subject_train<-read.table("train/subject_train.txt")
activities<-read.table("activity_labels.txt")
features<-read.table("features.txt")
################################################################
# merge the training and test sets
################################################################
x_merged<-rbind(x_test, x_train)
y_merged<-rbind(y_test, y_train)
subject_merged<-rbind(subject_test, subject_train)
################################################################
# rename the x_merged columns with the feature table
################################################################
colnames(x_merged)<-features[,2]
################################################################
# rename y and subject column
################################################################
colnames(y_merged)<-"activity"
colnames(subject_merged)<-"subject"
################################################################
# rename y_merged rows to friendly names
################################################################
y_merged[, 1]<- activities[y_merged[,1], 2]
################################################################
# extract only the measurements on the mean and standard deviation for each measurement. 
################################################################
filtered<-x_merged[,grepl("-std\\(\\)|-mean\\(\\)", colnames(x_merged))]
################################################################
# combine all of the data
################################################################
alldata<-cbind(subject_merged, y_merged, filtered)
################################################################
# create independent tidy data set with the average of each variable for each activity and each subject
################################################################
tidydata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 3:68]))
write.table(tidydata, "tidy.txt", row.names = FALSE)

