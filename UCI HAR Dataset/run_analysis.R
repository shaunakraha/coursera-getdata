require(plyr)
testSubject <- read.table('test/subject_test.txt', col.names=c('Subject'))
trainSubject <- read.table('train/subject_train.txt', col.names=c('Subject'))
subjects <- rbind(testSubject,trainSubject)
xTest <- read.table('test/X_test.txt')
xTrain <- read.table('train/X_train.txt')
x <- rbind(xTest,xTrain)
features <- read.table('features.txt', col.names=c('index', 'labels'))
labels <- features$labels
colnames(x) <- labels
feature_selected <- as.character(features$labels[grepl('mean()|std()', features$labels)])
feature_selected <- as.character(feature_selected[!grepl('meanFreq()', feature_selected)])
features_means_stds <- x[,c(feature_selected)]
activitiesTest <- read.table('test/y_test.txt')
colnames(activitiesTest) <- 'Activity'
activitiesTrain <- read.table('train/y_train.txt')
colnames(activitiesTrain) <- 'Activity'
activities <- rbind(activitiesTest, activitiesTrain)
activities$Activity[activities$Activity=='1'] <- 'WALKING'
activities$Activity[activities$Activity=='2'] <- 'WALKING_UPSTAIRS'
activities$Activity[activities$Activity=='3'] <- 'WALKING_DOWNSTAIRS'
activities$Activity[activities$Activity=='4'] <- 'SITTING'
activities$Activity[activities$Activity=='5'] <- 'STANDING'
activities$Activity[activities$Activity=='6'] <- 'LAYING'
names(features_means_stds) <- gsub('Acc','Acceleration', names(features_means_stds))
names(features_means_stds) <- gsub('Mag','Magnitude', names(features_means_stds))
names(features_means_stds) <- gsub('Freq','Frequency', names(features_means_stds))
names(features_means_stds) <- gsub('-mean','Mean', names(features_means_stds))
names(features_means_stds) <- gsub('-std','StandardDeviation', names(features_means_stds))
names(features_means_stds) <- gsub('\\(|\\)','', names(features_means_stds), perl=TRUE)
all_data <- cbind(subjects,activities,features_means_stds)
average_variables <- ddply(all_data, c("Subject","Activity"), numcolwise(mean))
write.table(average_variables, file = "average_variables.txt", row.name=FALSE)