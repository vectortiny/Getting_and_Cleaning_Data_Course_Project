# setwd() set working dir

library(dplyr)
library(tidyr)

# download and unzip raw data
data_zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_zip <- "UCI_HAR.zip"
download.file(data_zip, file_zip)
unzip(file_zip)

# set paths
data_folder   <- "UCI HAR Dataset"
features_path <- paste(data_folder, "features.txt",        sep = "/")
activity_path <- paste(data_folder, "activity_labels.txt", sep = "/")
test_folder   <- paste(data_folder, "test",  sep = "/")
train_folder  <- paste(data_folder, "train", sep = "/")

# read activity_labels
activity_labels <- read.delim(activity_path, header = FALSE, sep = " ")
names(activity_labels) <- c("label_id", "activity")

# read features
features <- read.delim(features_path, header = FALSE, sep = " ")
n_features <- nrow(features)

###################
# 0. Prepare data #
###################

#############
# TEST DATA #
#############
# read test set
X_test <- read.fwf(
  paste(test_folder,"X_test.txt", sep = "/")
  , header = FALSE
  , widths = rep(16, n_features)
)
# read test subjects
subject_test <- read.delim(
  paste(test_folder,"subject_test.txt", sep = "/")
  , header = FALSE
  , sep = " "
)
# read test labels
y_test <- read.delim(
  paste(test_folder,"y_test.txt", sep = "/")
  , header = FALSE
  , sep = " "
)
# set column names of test data
names(X_test) <- features[,2]
names(subject_test) <- "subject"
names(y_test) <- "label_id"
## combine test data
test_data <- as.data.frame(cbind(subject_test,y_test,X_test))

# remove unneeded dataframes
rm("X_test", "subject_test", "y_test")

##############
# TRAIN DATA #
##############
# read train set
X_train <- read.fwf(
  paste(train_folder,"X_train.txt", sep = "/")
  , header = FALSE
  , widths = rep(16, n_features)
)
# read train subjects
subject_train <- read.delim(
  paste(train_folder,"subject_train.txt", sep = "/")
  , header = FALSE
  , sep = " "
)
# read train labels
y_train <- read.delim(
  paste(train_folder,"y_train.txt", sep = "/")
  , header = FALSE
  , sep = " "
)
# set column names of train data
names(X_train) <- features[,2]
names(subject_train) <- "subject"
names(y_train) <- "label_id"
## combine train data
train_data <- as.data.frame(cbind(subject_train,y_train,X_train))

# remove unneeded dataframes
rm("X_train", "subject_train", "y_train")

####################################################################
# 1. Merges the training and the test sets to create one data set. #
####################################################################
data_one <- rbind(test_data, train_data)

#####################################################
# 2. Extracts only the measurements on the mean and #
#    standard deviation for each measurement.       #
#####################################################
data_mean_std <- select(data_one, subject, label_id, contains(c("mean()", "std()")))

##############################################################################
# 3. Uses descriptive activity names to name the activities in the data set. #
##############################################################################
data_activity <- left_join(
  data_mean_std
  , activity_labels
  , by = "label_id"
) %>%
  select(-label_id)

#########################################################################
# 4. Appropriately labels the data set with descriptive variable names. #
#########################################################################

# 0. Prepare data

###############################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set #
#    with the average of each variable for each activity and each subject.    #
###############################################################################

tidy_data <-
  group_by(data_activity, subject, activity) %>%
  summarize_if(is.numeric, mean, na.rm = TRUE) %>%
  as_tibble() %>%
  pivot_longer(
    cols = contains(c("mean()", "std()"))
    , names_to = "feature"
    , values_to = "average"
  )

#########################################################
# Prepare to upload the tidy data set created in step 5 #
#########################################################
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

