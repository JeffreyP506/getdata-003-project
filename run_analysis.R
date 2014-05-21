unzip("getdata_projectfiles_UCI HAR Dataset.zip")

features <- read.table("./UCI HAR Dataset/features.txt")
features_selected <- features[c(grep('mean()', features$V2),grep('std()', features$V2)),]

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
label_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
test <- cbind(data_set="test", subject_test, label_test, data_test)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
data_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
label_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
train <- cbind(data_set="train", subject_train, label_train, data_train)

data <- rbind(test, train)
data_selected <- data[,c(c(1,2,3), features_selected$V1+3)]
names(data_selected) <- c("Data.set", "Subject.identity", "Activity.label", as.character(features_selected$V2))
data_selected$Activity.label <- as.character((factor(data_selected$Activity.label, labels = activity_labels$V2)))
write.table(data_selected, "UCI_HAR_Dataset_cleaned.txt", row.names=FALSE)

mean_by_subj_act <- aggregate(data_selected[,4:82], by=list(data_selected$Subject.identity, data_selected$Activity.label),FUN=mean)
names(mean_by_subj_act)[1:2] <- c("Subject.identity", "Activity.label")
write.table(mean_by_subj_act, "UCI_HAR_Dataset_cleaned_mean_by_subj_act.txt", row.names=FALSE)
