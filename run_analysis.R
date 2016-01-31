message("load libraries")
library("data.table")

message("setting up environment, directory, download, unzip files..")
setwd("~/coursera/gcd_assignment3")
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

f_path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(f_path, recursive=TRUE)


#load feature data
message("loading feature data and grepping for mean and std")
#Reading features into frame provide better col_names and then grep for mean() and std() and create df
dfFullFeatures <- read.table(file.path(f_path, "features.txt"),head=FALSE)
#set names here and returns a vector
vFeatureNames <- dfFullFeatures$V2[grepl("mean\\(\\)|std\\(\\)",dfFullFeatures$V2)]
#this is a character string to allow for selecting on features
selectedNames<-c(as.character(vFeatureNames))

#load activity data
message("loading activity data")
dfActivityLabels <- read.table(file.path(f_path, "activity_labels.txt"),header = FALSE)
setnames(dfActivityLabels, names(dfActivityLabels), c("activityKey", "activityValue"))

#load the test data
message("loading test data: subject, feature=x, activity=y")
dfSubjectTest <- read.table(file.path(f_path, "test" , "subject_test.txt" ),header = FALSE)
dfFeatureTest <- read.table(file.path(f_path, "test" , "X_test.txt" ),header = FALSE)
dfActivityTest <- read.table(file.path(f_path, "test" , "Y_test.txt" ),header = FALSE)

#load the training data
message("loading train data: subject, feature=x, activity=y")
dfSubjectTrain <- read.table(file.path(f_path, "train" , "subject_train.txt" ),header = FALSE)
dfFeatureTrain <- read.table(file.path(f_path, "train" , "X_train.txt" ),header = FALSE)
dfActivityTrain <- read.table(file.path(f_path, "train" , "Y_train.txt" ),header = FALSE)

#rbind subject(persons who did the activity), rename cols, ls(and train together and remove individual df
message("rbinding subject test and train data")
dfSubject <- rbind(dfSubjectTest, dfSubjectTrain)
setnames(dfSubject, "V1", "subject")
if(exists("dfSubjectTest")){rm("dfSubjectTest")}
if(exists("dfSubjectTrain")){rm("dfSubjectTrain")} 

#rbind feature(what was the measure) data ls(and train together and remove individual df
#need to get the correct col_names based on dfFullFeatures
#susetting data before binding with subject and activity
message("rbinding feature test and train data, the features have already been fitlered to mean and std")
dfFeatures <- rbind(dfFeatureTest, dfFeatureTrain)
names(dfFeatures) <- dfFullFeatures$V2
dfFeatures <- subset(dfFeatures, select = selectedNames)
if(exists("dfFeatureTest")){rm("dfFeatureTest")}
if(exists("dfFeatureTrain")){rm("dfFeatureTrain")} 

#bind activity(activity happening walking, standing, etc.) ls(and train together and remove individual df
message("rbinding activity test and train data, also merging activity labels")
dfActivity <- rbind(dfActivityTest, dfActivityTrain)
setnames(dfActivity, "V1", "activityKey")
dfActivity <- merge(dfActivity, dfActivityLabels, by="activityKey", all.x = TRUE)
if(exists("dfActivityTest")){rm("dfActivityTest")}
if(exists("dfActivityTrain")){rm("dfActivityTrain")} 
   
#cbind together the subjects and activities performed, remove dfSub and dfAct
#each row in the individual sets is the same so, can bind values together, key is rowid
message("cbind subject and activity frames")
dfSubjectActivity <- cbind(dfSubject, dfActivity$activityValue)
setnames(dfSubjectActivity, "dfActivity$activityValue", "activity")
#cbind features with the subject and activitiy
#same as above is true, key is rowid
message("cbind features with subject and activity")
dfFinal <- cbind(dfSubjectActivity, dfFeatures)
write.table(dfFinal, file = "./tidydata_main.txt",row.name=FALSE)

message("use aggregate function to create the mean value for the new tidy set, saving data to disc")
dfFinal2<-aggregate(dfFinal, by=list(dfFinal$subject, dfFinal$activity), FUN = mean)

write.table(dfFinal2, file = "./tidydata.txt",row.name=FALSE)