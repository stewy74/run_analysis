
# read all required data files
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")

ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")

vnames <- read.table("UCI HAR Dataset/features.txt")
activites <- read.table("UCI HAR Dataset/activity_labels.txt")

subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subtest <-  read.table("UCI HAR Dataset/test/subject_test.txt")

# set col names
colnames(subtrain) <- c("subject")
colnames(subtest) <- c("subject")

colnames(ytrain) <- c("activity_code")
colnames(ytest) <- c("activity_code")
colnames(activites) <- c("code", "activity")

# convert rows of the vname column 2 into a vector
# and then place into main datasets as column names
# (...tricky... the double brackets will return a vector  
# while single bracket would only return a data frame!!)
colnames(xtest)  <- as.vector(vnames[[2]])
colnames(xtrain)  <- as.vector(vnames[[2]])

# join activity "id" with its desc  
ytestlabels <- merge(activites, ytest, by.x="code", by.y="activity_code")
ytrainlabels <- merge(activites, ytrain, by.x="code", by.y="activity_code")

# remove "id" code leaving only single column with activity desc
ytestok <- subset(ytestlabels, select = -c(code))
ytrainok <- subset(ytrainlabels, select = -c(code))

# join subject list with the activites
subytest <- cbind(subtest, ytestok)
subytrain <- cbind(subtrain, ytrainok)

# join subjects and activities with the main data 
newtest <- cbind(subytest, xtest)
newtrain <- cbind(subytrain, xtrain)

# append test and training data together
all <- rbind(newtest, newtrain)

# filter out all the std and mean measures...
# note that this code keeps relevant "angle" measures also
gstd <- grep("*[Ss]td*", as.character(colnames(all)))
gmean <- grep("*[Mm]ean*", as.character(colnames(all)))

# gmerge is an index of columns we want to keep
# sorting places the columns back in original order
gmerge <- sort(c(1, 2, gstd, gmean))

# use col index to build new data frame
meanstd <- all[,gmerge]

# now things get interesting with the "tidy" data
# ...ddply() does all the heavy lifting for us!
# numcolwise() ensures mean() runs on the columns instead of rows...
library(plyr) # both ddply and numcolwise found in plyr package
tidy <- ddply(meanstd, .(subject, activity), numcolwise(mean))

# save the tidy data
write.table(tidy, "tidy.txt")



