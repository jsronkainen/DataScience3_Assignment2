#Install packages, if needed
#The first block of code just makes sure, you have the downloader package installed, and if not it proceeds to install it. Note that the reusults of this code chunk are deliberately hidden, as it is just so boring and takes half of the document. 
list.of.packages <- c("downloader", "ggplot2", "timeDate", "gridExtra", "plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(downloader)
library(ggplot2)
library(timeDate)
library(gridExtra)
library(plyr)

# Download and unzip the data
destfile="./Fprojectfiles.zip"
if (!file.exists(destfile)){
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile, method="curl")
unzData<-unzip("Fprojectfiles.zip", exdir = "./data/")
}

# Get the csv file names and let's create a bulk data frames named after the original txt files
#We do it separately for each directory
#These create all needed data frames such as features, y_test, y_train etc. 
#However, the most important data is not clean enough (X_test and Y_test)
#and we need to deal with them separately afterwards
csv_files_data <- list.files(path = "./data/UCI HAR dataset/", pattern = "*.txt", full.names=TRUE)
list2env(setNames(lapply(csv_files_data, read.csv), basename(tools::file_path_sans_ext(csv_files_data))), globalenv())

csv_files_data_test <- list.files(path = "./data/UCI HAR dataset/test", pattern = "*.txt", full.names=TRUE)
list2env(setNames(lapply(csv_files_data_test, read.csv), basename(tools::file_path_sans_ext(csv_files_data_test))), globalenv())

csv_files_data_train <- list.files(path = "./data/UCI HAR dataset/train", pattern = "*.txt", full.names=TRUE)
list2env(setNames(lapply(csv_files_data_train, read.csv), basename(tools::file_path_sans_ext(csv_files_data_train))), globalenv())

#So this is the place where we deal with those broken datasets
#Essentially, we form 561 columns with variables with items of length 16
X_train<-read.fwf("./data/UCI HAR dataset/train/X_train.txt", widths=c(rep(16, 561)))
X_test<-read.fwf("./data/UCI HAR dataset/test/X_test.txt", widths=c(rep(16, 561)))

#Get column names for X_train and X_test
features <- read.table("./data/UCI HAR dataset//features.txt", sep=" ")
#Remove the non needed row number
features<-features[-1]

#Naming the columns of X_train and X_test
colnames(X_train)<-features[,1]
colnames(X_test)<-features[,1]

#Extracting only the measurements on the mean and standard deviation from each measurement
#There is probably a much more elegant solution for this, but I just selected the 
#suitable columns by hand, as it was fairly fast operation
x_train<-X_train[c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214,215, 227, 228, 240, 241, 253,254, 266:271, 345, 350, 373,374,375, 424:429, 452:454, 503,504, 513, 516,517, 529, 530, 539, 542,543, 555:561)]
x_test<-X_test[c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214,215, 227, 228, 240, 241, 253,254, 266:271, 345, 350, 373,374,375, 424:429, 452:454, 503,504, 513, 516,517, 529, 530, 539, 542,543, 555:561)]

#Adding each data frame information on subject and the activity
x_train$subject<-subject_train[,1]
subject_test<-rbind(subject_test, 24)
x_test$subject<-subject_test[,1]
x_train$activity<-y_train[,1]

#x_test has a one missing value and it has been replaced 
#by the value just before it (assuming it is the same person)
y_test<-rbind(y_test, 2)
x_test$activity<-y_test[,1]

#To give the activities a descriptive names, we must create a small function
transform<-function(x){
        if(x==1) y<-"walking" else
        if(x==2) y<-"walking_upstairs" else
        if(x==3) y <-"walking_downstairs" else 
        if(x==4) y<-"sitting" else
        if(x==5) y<-"standing" else
        if(x==6) y<-"laying" else y<-NA
return(y)
}

#And let's now give activities descriptive names in data frams x_test and x_train
x_train$activityDescr<-lapply(x_train$activity, transform)
x_test$activityDescr<-lapply(x_test$activity, transform)

#And now, let's merge the data into one massive (but clean) dataset
x_trainAndtest<-rbind(x_train, x_test)

#And let's save that into a csv file
x_trainAndtestMatrix<-as.matrix(x_trainAndtest)
write.csv(x_trainAndtestMatrix, file="x_trainAndtest.csv", row.names=FALSE)

# And finally, let's create a second, independent tidy 
# data set with the average of each variable for each activity and each subject.

#This is pretty easy with aggregate function
#We just first remove column causing errors
#x_trainAndtest<-x_trainAndtest[,-c(80)]
x_averagesSubjectActivity<-aggregate(x_trainAndtest, by=list(x_trainAndtest$activity, x_trainAndtest$subject), mean)
#We just add back the activity descriptions
x_averagesSubjectActivity$activityDescr<-lapply(x_averagesSubjectActivity$activity, transform)
#and write a new clean tidy data set into csv file
#And let's save that into a csv file
x_averagesSubjectActivity<-as.matrix(x_averagesSubjectActivity)
write.csv(x_averagesSubjectActivity, file="x_averagesSubjectActivity.csv", row.names=FALSE)
