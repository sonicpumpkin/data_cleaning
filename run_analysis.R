#read in
setwd("/Users/sonicpumpkin/Documents/Coursera/data cleaning/UCI HAR Dataset")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
id_test<-read.table("./test/subject_test.txt")
id_train<-read.table("/./train/subject_train.txt")
###########################################################################################
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
###########################################################################################
#find features
features<-read.table("/Users/sonicpumpkin/Documents/Coursera/data cleaning/UCI HAR Dataset/features.txt")
ft_means<-features[grep("-mean()",features$V2,fixed=TRUE),]
ft_std<-features[grep("-std()",features$V2,fixed=TRUE),]
ft_include<-rbind(ft_means,ft_std)
#select features for TEST
x_test2<-x_test[,ft_include$V1]
colnames(x_test2)<-ft_include$V2
#add indicator test (0)/train (1) for TEST
x_test2$test<-1
#combined with id and label
colnames(id_test)<-"subject_id"
colnames(y_test)<-"label"
test_final<-cbind(x_test2,id_test,y_test)

#select features for TRAIN
x_train2<-x_train[,ft_include$V1]
colnames(x_train2)<-ft_include$V2
#add indicator test (0)/train (1) for TRAIN
x_train2$test<-0
#combined with id and label
colnames(id_train)<-"subject_id"
colnames(y_train)<-"label"
train_final<-cbind(x_train2,id_train,y_train)
###########################################################################################
#1.Merges the training and the test sets to create one data set.
###########################################################################################
test_train<-rbind(test_final,train_final)


###########################################################################################
#4. Appropriately labels the data set with descriptive variable names.
###########################################################################################
test_train$label_desc<-factor(test_train$label, labels =c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                                            "SITTING","STANDING","LAYING"))
###########################################################################################
#5.From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
###########################################################################################
library('dplyr')
final_means<-test_train %>% group_by(subject_id,label_desc) %>% summarise_all(funs(mean))
final_means<-subset(final_means,select=-c(test,label))
write.table(final_means,file = 'final_data.txt',row.names = FALSE)
