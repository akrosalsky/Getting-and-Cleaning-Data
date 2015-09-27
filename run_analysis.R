# run_analysis.R
library(dplyr)

# merge the training and test sets
train <- read.table("train/subject_train.txt")
test <- read.table("test/subject_test.txt")
sbj <- rbind(train, test)

train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")
x <- rbind(train, test)

train <- read.table("train/y_train.txt")
test <- read.table("test/y_test.txt")
y <- rbind(train, test)

# Extract only the mean and standard deviation for each measurement

features <- read.table("features.txt")
mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x <- x[, mean_std]
names(x) <- features[mean_std, 2]
names(x) <- gsub("\\(|\\)", "", names(x))
names(x) <- tolower(names(x))

# Use descriptive activity names to label columns

activities <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
activities[, 2] = gsub("_", "", tolower(activities[, 2]))
y[,1] = activities[y[,1], 2]
names(y) <- "activity"

# label the data set with descriptive variable names.
names(sbj) <- "subject"
cleaned <- cbind(sbj, y, x)

# create a second, independent tidy data set with the average of each variable
# for each activity and each subject

cleaned %>%
        tbl_df %>%
        group_by(subject, activity) %>%
        summarize_each(funs(mean)) %>%
        write.table("average_tidy_data.txt", row.names = FALSE)