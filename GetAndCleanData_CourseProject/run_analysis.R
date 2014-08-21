# read the question and code this step by step

getExistingDir <- function(main, sub){
      
      if (str_trim(main)=='' | str_trim(sub)==''){
            stop('The arguments for the folder and subfolder cannot be empty')
      }
      else{
            # create dir if it doesn't exist
            dir.create(file.path(main, sub), showWarnings=FALSE) 
            paste(main, '/', sub, sep="")
      }
}

getZippedData <- function(dirname, filename, url) {

      
      # set the working directory
      setwd(dirname)
      
      # create temp file
      temp <- paste(dirname, filename, sep="")
      
      # download the zip into the temp file
      download.file(url, temp)
      
      # unzip the file in the working directory
      unzip(temp)
      
      # cleanup the temp file
      unlink(temp)
      rm(temp)
}


getInterimSet <- function(dat, sub, act, dirlist) {
      
      # read set
      data_ <- read.table(as.matrix(dirlist)[grep(dat, as.matrix(dirlist)), ], header = FALSE, sep = "")

      # read activities
      act_ <- read.table(as.matrix(dirlist)[grep(act, as.matrix(dirlist)), ], header = FALSE, sep = "")
      
      # read subjects for test
      sub_ <- read.table(as.matrix(dirlist)[grep(sub, as.matrix(dirlist)), ], header = FALSE, sep = "")
      
      # add activities and subjects to testdata
      cbind(act_, sub_, data_)
            
}

# download and unzip data in folder of choice
folder <- getwd()
file <- "UCIHARDataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# be sure the output folder exists
setwd(getExistingDir(folder,'data'))

# get and unzip file
getZippedData(paste(folder, '/data', sep=""), file, url)

# lets see what we have unzipped
dirlist <- dir(path = paste(folder, '/data', sep=""), full.names = TRUE, recursive = TRUE)

# we have all files in a vector
# need only a few files

# get test
dat <- '/X_test.txt'; act <- '/y_test.txt'; sub <- '/subject_test.txt'
testdat <- getInterimSet(dat, sub, act, dirlist)

# get train
dat <- '/X_train.txt'; act <- '/y_train.txt'; sub <- '/subject_train.txt'
traindat <- getInterimSet(dat, sub, act, dirlist)

# merge train and test 
mergedset <- rbind(testdat, traindat)

# cleanup
rm(traindat)
rm(testdat)

# read features in vector, second line in the features file
features <- read.table(as.matrix(dirlist)[grep('/features.txt', as.matrix(dirlist)), ], header = FALSE, sep = "", stringsAsFactors=F)[,2]

# tidy up the features
# replace minus by periods
# remove parenthesis
features <- gsub("-", ".", features)
features <- gsub("\\(\\)", "", features)

# add two column names at the front
collabels <- c('activity', 'subject', features)


# for our analysis we need only mean and std on each measure
# get cols of interest, we need only means and standarddeviations of measures
# assumption that these features are ending in mean and std
featofinterest <- grepl('activity\\>|subject\\>|mean()\\>|std()\\>', features)
      
# add features for column names
names(mergedset) <- collabels

# read activites in vector
activities <- read.table(as.matrix(dirlist)[grep('/activity_labels.txt', as.matrix(dirlist)), ], header = FALSE, sep = "", stringsAsFactors=T)

# add factor to the dataset
mergedset$activity <- factor(mergedset$activity, labels=activities$V2)

# here we have one tidy dataset for future analysis
# it contains all activities, subjects, measurement 
# and descriptive columnnames for all measurements
# for the tidy dataset of our interest we need to strip columns

# extract only columns of interest into new dataset
dataset <- mergedset[c(featofinterest)]

# write our tidy dataset file
write.table(dataset, 'movementmonitor.txt', col.names=NA)

# make a new table containing 
# the average of each activity grouped by subject, nice way to pivot data
activity.subject <- split(dataset, list(dataset$activity, dataset$subject), drop = TRUE)
average.activity.subject <- sapply(activity.subject, function (x) colMeans(x[, 3:length(dataset)]))

# write out table to file, without rownames
write.table(average.activity.subject, 'activity_averages.txt',row.name=FALSE)