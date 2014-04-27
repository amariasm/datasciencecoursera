# R script for Getting and Cleaning Data Project
# It should work provided that you unzipped UCI HAR Dataset into the same directory
# The link for UC HAR Dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# 1. Preparing column for "Subject" variable
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
subj <- rbind(subj_train, subj_test)
names(subj) <- "subject"

# 2. Preparing columns for "features" variables
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
X <- rbind(X_train, X_test)
feat <- read.table("UCI HAR Dataset/features.txt", header=F)
feat_ind <- grep("-mean\\(\\)|-std\\(\\)", feat[, 2])
X <- X[, feat_ind]
names(X) <- feat[feat_ind, 2]
names(X) <- gsub("\\(|\\)", "", names(X))

# 3. Preparing column for "activity" variable
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
Y <- rbind(y_train, y_test)
activ <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)
activ[, 2] = gsub("_", "", as.character(activ[, 2]))
Y[,1] = activ[Y[,1], 2]
names(Y) <- "activity"

# 4. Combining all the variables into one dataset
dataset <- cbind(subj, Y, X)
write.table(dataset, "dataset.txt")

# 5. Creating a 2nd tidy data set with the average of each variable for each activity and each subject.
library(reshape)
melted <- melt(dataset, id.vars = c("subject", "activity"))
avg_dataset <- cast(subject + variable ~ activity, data = melted, fun=mean)
write.table(avg_dataset, "avg_data.txt")
