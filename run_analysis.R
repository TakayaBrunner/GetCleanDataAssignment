## load library
library(plyr)
library(reshape2)

## Load the lookup tables into the system
activity_labels <- read.table(file=file.path("UCI HAR Dataset"
                                            ,"activity_labels.txt")
                            , header = FALSE)

features <- read.table(file=file.path("UCI HAR Dataset"
                                     ,"features.txt")
                              , header = FALSE)

## Load the TRAIN data into the system.
subject_train <- read.table(file=file.path("UCI HAR Dataset/train"
                                          ,"subject_train.txt")
                           , header = FALSE)

x_train <- read.table(file=file.path("UCI HAR Dataset/train"
                                    ,"X_train.txt")
                      , header = FALSE)

y_train <- read.table(file=file.path("UCI HAR Dataset/train"
                                    ,"y_train.txt")
                            , header = FALSE)
## Load the TEST data into the system.
subject_test <- read.table(file=file.path("UCI HAR Dataset/test"
                                           ,"subject_test.txt")
                            , header = FALSE)

x_test <- read.table(file=file.path("UCI HAR Dataset/test"
                                     ,"X_test.txt")
                      , header = FALSE)

y_test <- read.table(file=file.path("UCI HAR Dataset/test"
                                     ,"y_test.txt")
                      , header = FALSE)

## Add fields and change field names for TRAIN
        ## add the field names to x_train
        names(x_train) <- features[,"V2"]
        
        ## add the columns y_train and set column name to y_train
        x_train <- cbind(y_train, x_train)
        names(x_train)[1] <- "activity"
        
        ## add the columns subject_train and set column name to subject_train
        x_train <- cbind(subject_train, x_train)
        names(x_train)[1] <- "subject"

## Add fields and change field names for TEST
        ## add the field names to x_train
        names(x_test) <- features[,"V2"]
        
        ## add the columns y_train and set column name to y_train
        x_test <- cbind(y_test, x_test)
        names(x_test)[1] <- "activity"
        
        ## add the columns subject_train and set column name to subject_train
        x_test <- cbind(subject_test, x_test)
        names(x_test)[1] <- "subject"

## combine the two test and train tables into one table.
agg_data <- rbind(x_test,x_train)

## creates a list of all the fields containing either std() or mean()
## also sorts the list so we can get the like fields to line up together.
field_list <- sort(c(  grep("subject",names(agg_data))
                     , grep("activity",names(agg_data))
                     , grep("std\\(\\)",names(agg_data))
                     , grep("mean\\(\\)",names(agg_data))
                     )
                   )

## creates a smaller data set containing only the fields we care about
## I.e. fields containing mean() or std()
sub_data <- agg_data[, field_list]

## Melts the data set on the two variables subject and activity
sub_dataMelt <- melt(sub_data,id=c("subject","activity"))

## Re-organizes the data set and calculates an average on the variables.
sub_dataCast <- dcast(sub_dataMelt,subject + activity ~ variable, mean)

## Adds the activity field values into the dataset.
sub_dataCast <- merge(activity_labels, sub_dataCast, by.x="V1",by.y="activity"
                      , all=TRUE)

## drop field V1 from sub_dataCast
sub_dataCast <- sub_dataCast[,!names(sub_dataCast) %in% "V1"]

## Create and reorder the tidyDataset
col_idx <- grep("subject",names(sub_dataCast))

tidyData <- sub_dataCast[, c(col_idx,(1:ncol(sub_dataCast))[-col_idx])]

## Create a Name list that will be used to cleaned the variable names.
NameList <- names(tidyData)
NameList[1:2] <- c("Subject","Activity")
NameList <- gsub("-mean\\(\\)","_Mean",NameList)
NameList <- gsub("-std\\(\\)","_StdDev",NameList)
NameList <- gsub("-","_",NameList)

## Assign the cleaned name list to the names in tidyData
names(tidyData) <- NameList

## Sorts tidyData on Subject then Activity
tidyData <- tidyData[order(tidyData[,"Subject"],tidyData[,"Activity"]), ]

## Outputs the resulting tidyData table into the Working Directory
write.table(tidyData,"tidyData.txt",row.names=FALSE, sep=",")

## Complete
