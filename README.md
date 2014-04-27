
Overview of run_analysis.R 
========================== 

This R script gathers the various files included included in the Samsung smart phone sensor readings found in UCI data directories and merges them into a single data frame.  The resulting data is then aggregated per subject and activity to create a summary data set of the means of only those measures involving means and standard deviations.   


Requirements 
===================== 

The following are required in order for the script to run as intended.

* the UCI data in a folder found in the working directory
* IMPORTANT: the {plyr} package must be installed

###  input files and respective locations in the UCI folders

* measures data:  "UCI HAR Dataset/test/X_test.txt"
* measures data:  "UCI HAR Dataset/train/X_train.txt"
* activity per obs:  "UCI HAR Dataset/test/y_test.txt"
* activity per obs: 	"UCI HAR Dataset/train/y_train.txt"
* measure names:	"UCI HAR Dataset/features.txt"
* activity verbiage:	"UCI HAR Dataset/activity_labels.txt"
* subject per obs:	"UCI HAR Dataset/train/subject_train.txt"
* subject per obs:	"UCI HAR Dataset/test/subject_test.txt"

(please consult the UCI documentation for specific overview of each file)



What does it do?
================================== 

### order of operations 

* imports all data
* sets all column names
* merges subject and activity data with training/test measures 
* uses grep() to find all columns with "[Ss]td" or "[Mm]ean" in name
* subsets based on grep logic above
* uses ddply() and numcolwise() to aggregate data by subject/activity
* saves data resulting from ddply function

Note that the use of regular expression pattern matching results in 86 measurement columns including the "angle" measurements with  "mean" in the column name.

The use of ddply() highlights the utility of the R ecosystem; a great variety of functionality is already developed!  

#### final "tidy" data 

The resulting data set is saved in the working directory as "tidy.txt".
