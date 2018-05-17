# DataScience3_Assignment2
Peer reviewed assignment for the Coursera course Getting and Cleaning data

## Purpose
This repository contains cleaned and aggregated data from research 'Human Activity Recognition Using Smartphones Dataset' published on 2012 by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.

###Original research
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

### This repository
In the original research, the data is distibuted over numerous txt files which cannot be easily read. Thus, the aim of this repository is to provide two clean and neat dataset aggregaged from the published datasets. 

## Contained files 
This repository contains the following parts:
README.md file
CodeBook.md (explains the data manipulations and variables)
run_analysis.R (A full replicable R script for data acquiring and manipulation.)
x_trainAndtest.csv (This file contains all the results from the original research with descriptive column names making it a 'human readable document.)
x_averagesSubjectActivity.csv (A neat and concise dataset containing aggregaged averaged results grouped by the user and the acivity. )
Fprojectfiles.zip (All original files)

## Script
All data manipulation and cleaning has been done using a provided R script (run_analysis.R). 

