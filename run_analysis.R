run_analysis<-function() {
  #read format files
  setwd("C:/Users/Brandon/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
  features<-read.table("features.txt")
  activities<-read.table("activity_labels.txt")
  
  #read data from the test folder
  setwd("C:/Users/Brandon/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test")
  x_test<-read.table("X_test.txt")
  y_test<-read.table("Y_test.txt")
  subj_test<-read.table("subject_test.txt")
  
  #read data from the train folder
  setwd("C:/Users/Brandon/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train")
  x_train<-read.table("X_train.txt")
  y_train<-read.table("Y_train.txt")
  subj_train<-read.table("subject_train.txt")
  
  #merge training and test data
  x_result<-rbind(x_test,x_train)
  y_result<-rbind(y_test,y_train)
  subj_result<-rbind(subj_test,subj_train)
    
  #use descriptive names for values in data set
  names(x_result)<-features[,2]
  
  #merge subject and activity with measurements
  fd<-cbind(subj_result,y_result,x_result)
  
  #name first two columns: subject and activity
  names(fd)[1:2]<-c("subject","activity")
  
  #select columns having to do with the mean and standard deviation of variables
  fdnames<-names(fd)
  std_ind<-grepl("-std()",fdnames)
  mean_ind<-grepl("-mean()",fdnames)
  
  #remove columns with substring "meanFreq"
  bad_mean_ind<-grepl("-meanFreq",fdnames)
  mean_ind[bad_mean_ind]<-FALSE
  
  #combine mean_ind and std_ind into one vector with all desired indices
  all_ind<-as.logical(mean_ind+std_ind)
  
  #add back in the subject and activity columns to label each observation
  all_ind[1:2]=TRUE
  
  #extract these columns from fd
  newdata<-fd[fdnames[all_ind]]
  
  #give activity appropriate name
  act<-as.matrix(newdata['activity'])
  act2<-activities[act,2]
  newdata['activity']<-act2
  
  #create second, indepedent tidy data set with the average of each variable
  #for each activity and each subject
  DF=as.data.frame(newdata)
  subject<-DF$subject
  activity<-DF$activity
  aggdata<-aggregate(DF,by=list(subject,activity),FUN=mean,na.rm=TRUE)
  aggdata$activity<-NULL
  aggdata$subject<-NULL
  names(aggdata)[1:2]<-c("subject","activity")
  
    
  
  #write data to the results folder
  setwd("C:/Users/Brandon/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/result")
  write.table(aggdata,file="tidydata.txt",row.names=FALSE)
  aggdata
}
