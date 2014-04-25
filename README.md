GetCleanDataAssignment
======================

A solution to the Get Clean Data Assignment.
****************************************************
Created by: Takaya Brunner
Date Created: 2014-04-24
R: 3.0.3

****************************************************
Description:
This piece of code takes data from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and transforms it into a tidy dataset. The data is tidied in the following way:
A) Downloads the plyr and reshape2 packages.
B) Combines training and test data sets.
C) Extracts only the measurements mean() and std().
D) Replaces the activity ID with the actual activity performed.
E) Renames the field names and utilizes the Name Key below.
F) Collapses the dataset on Subject and Activity. 
   Multiple values for a Subject/Activity pair within a single field are averaged.

****************************************************
Assumptions:
1) Data has already been downloaded and folder exists in Working Directory.
2) The order of fields within the x_train and x_test data sets match.
3) The order of the fields within the features table, matches the order of the 
   fields within x_train and x_test.
4) The order of records within the subject_* and y_* data sets 
   properly matches the order of records within x_* data sets.
5) The only fields we care about are those with field names containing mean() or std().
6) Assumes you have internet to download the reshape2 and plyr packages.


****************************************************
Data Field Definitions
	Subject		-	Subject ID.
	Activity	-	Activity performed by Subject when data was captured.
	
	Name Key
		Prefix t	-	indicates Time.
		Prefix f 	-	indicates Fast Fourier Transform was applied.
		Acc 		-	indicates and accelerometer was used.
		Gyro		-	indicates a gyroscope was used.
		Body		-	indicates body acceleration signals.
		Gravity		-	indicates gravity acceleration signals.
		Jerk		-	indicates Jerk signals.
		Mag		-	indicates magnitude calculated using Euclidean norm.
		-XYZ		-	indicates if data was captured on X, Y or Z axes.
		Mean		-	mean of data is displayed.
		StdDev		-	Standard Deviation of data is displayed.
		_		-	Underscore indicates a space.

****************************************************
Output:
The script ouputs a text file that is comma delimited without row names 
in a file titled "tidyData.txt" into your current working directory.
