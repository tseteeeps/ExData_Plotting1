##install.packages("LaF") #needed if LaF package is not installed,
library("LaF")

#read first two rows to get its column names and type 
first2rows <- read.table("household_power_consumption.txt", header = TRUE, nrows = 2, sep=";")
colNames<-colnames(first2rows)
colTypes<- sapply(first2rows, class)

fileNm<-"household_power_consumption.txt"
laf <- laf_open_csv(fileNm,  column_names=colNames,sep=";", column_types=colTypes, skip=1)
d<- laf$Date[] #to get first columns Date value
rows_1Feb2007 <- which(d == "1/2/2007") 
data_1Feb2007 <-laf[rows_1Feb2007 [], ] # read all the data for 1/2/2007 

rows_2Feb2007 <- which(d == "2/2/2007")
data_2Feb2007 <-laf[rows_2Feb2007 [], ] # read all the data for 2/2/2007

data_1_2Feb2007 <- rbind(data_1Feb2007,data_2Feb2007) #combine 1/2/2007 and 2/2/2007 data

#remove ? value
data_1_2Feb2007[data_1_2Feb2007=="?"] <- NA
data_1_2Feb2007 <- na.omit(data_1_2Feb2007)

#plot diagram
library(datasets)
with(faithful, hist(data_1_2Feb2007$Global_active_power, xlab="Global Active Power (kilowatts)", col="red", main="Global Active Power" ))
dev.copy(png, file = "plot1.png",  width = 480, height = 480)
dev.off()  #must have,otherwise, the image file size will be 0