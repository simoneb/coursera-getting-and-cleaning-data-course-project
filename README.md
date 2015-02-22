Coursera Getting and Cleaning Data Course Project
========

This document explains how the script works.

## Prerequisites

In order to run the script you should clone this repository and make sure that the R packages `plyr` and `dplyr` are installed.

You'll also need to have the original Samsung set data in a folder named *UCI HAR Dataset* in the repository directory. The original set wasn't included because too big to be conveniently transferred via Git.

## How it works

### Preparation

The script creates two common variables:

- `features`: holds the meaningful names of the features, from the `features.txt` file
- `activities`: holds the descriptive names of the activities, from the `activity_labels.txt` file

The script also defines three functions for the operations to be executed on the test and training sets:

- `readset`: reads the data of the set given the path to the CSV file in a data frame and assigns `features` to variable names, as to give them menaingful names
- `readsetactivities`: reads and joins the labels of each test set (either `y_text.txt` or `y_train.txt`) with `activities`, in order to give numeric activities in each set a descriptive name
- `readsetsubjects`: reads the subjects of each set into a data frame

### Set creation

For each of the test and train sets a grouping variable is created which contains 4 variables:

- `set`: the result of executing `readset` on either `X_test.txt` or `X_train.txt`
- `activities`: the result of executing `readsetactivities` on either `y_test.txt` or `y_train.txt`
- `subjects`: the result of executing `readsetsubjects` on either `subject_test.txt` or `subject_train.txt`
- `fullset`: the result of `cbind`ing `activities`, `subjects` and `set`

### Set merging

Then the two `fullset`s are *merged* by binding all their rows together with `rbind` and only the columns containing *means* and *stds* of measures (in addition to subjects and activities) are extracted with a regular expression

### Final result

The final result is obtained by grouping the merged and column-filtered data frame by subject and activity and computing the mean of all the remaining rows for each group