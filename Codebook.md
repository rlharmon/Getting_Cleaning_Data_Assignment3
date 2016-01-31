CodeBook for assignment3 
=============================

Data source
-----------
This is a link to actual datafiles, https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  
The original data was developed by UCI to measure a set of 6 specific activities wearing a tracking device.  Exact details can be found here, http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Feature Selection 
-----------------
We limited the overal measure_features to:
* mean(): mean value
* std(): standard deviation

Data Information
----------------
Each set of dataset collected (train and test) is broken by the same row value.  This means that each dataset had the same number of observations.  This made binding Features(x_test/train), Activities(y_test,train), and Participants(subject_test/train) possible without ientifying dataset keys to match.
The main merged dataset contains, 10,299 observations and 68 variables.
The tiday data, tidydat.txt contains 35 observations and 68 variables.

Instructions
------------
Self contained script run_analysis.R this will create a tidydataset with the mean calculated for the subject and activities observerd.
