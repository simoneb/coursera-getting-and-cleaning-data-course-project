library(plyr)
library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt",
                       as.is = TRUE,
                       col.names = c("id", "feature"))

activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         col.names = c("id", "activity"))

readset <- function(path) {
  read.table(path,
             header = FALSE, 
             col.names = features$feature,
             check.names = FALSE)
}

readsetactivities <- function(path) {
  join(read.table(path, col.names = "id"), activities, by = "id")
}

readsetsubjects <- function(path) {
  read.table(path, col.names = "subject")
}


train.set <- readset("UCI HAR Dataset/train/X_train.txt")
train.activities <- readsetactivities("UCI HAR Dataset/train/y_train.txt")
train.subjects <- readsetsubjects("UCI HAR Dataset/train/subject_train.txt")
train.fullset <- cbind(activity = train.activities$activity, 
                       train.subjects,
                       train.set)

test.set <- readset("UCI HAR Dataset/test/X_test.txt")
test.activities <- readsetactivities("UCI HAR Dataset/test/y_test.txt")
test.subjects <- readsetsubjects("UCI HAR Dataset/test/subject_test.txt")
test.fullset <- cbind(activity = test.activities$activity, 
                      test.subjects,
                      test.set)

merged.set <- rbind(train.fullset, test.fullset)
merged.meanstdonly <- merged.set[, grep("mean\\(\\)|std\\(\\)|activity|subject", 
                                        colnames(merged.set), value = TRUE)]

merged.meanstdonly %>% group_by(activity, subject) %>% summarise_each(funs(mean))
