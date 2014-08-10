#plot3.R, by zbc
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

#combined Data and Time column into column Date using format %d/%m/%Y %H:%M:%S
data_1_2Feb2007$Date<- strptime(paste(data_1_2Feb2007$Date,data_1_2Feb2007$Time), "%d/%m/%Y %H:%M:%S")
#data_1_2Feb2007$day <- weekdays(data_1_2Feb2007$Date) #create one more colomun day. no need

#remove ? value
data_1_2Feb2007[data_1_2Feb2007=="?"] <- NA
data_1_2Feb2007 <- na.omit(data_1_2Feb2007)

#plot diagram
library(datasets)

#draw in line

y1<-data_1_2Feb2007$Sub_metering_1
y2<-data_1_2Feb2007$Sub_metering_2
y3<-data_1_2Feb2007$Sub_metering_3

#with(faithful, 
plot(data_1_2Feb2007$Date, y1, ylim=range(c(y1,y2,y3)), col="black", type="l" ,ylab="Energy sub metering", xlab="" )
#with(faithful, 
lines(data_1_2Feb2007$Date, y2,col="red")
#with(faithful, 
lines(data_1_2Feb2007$Date, y3, col="blue")
legend("topright", pch = '-', col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file = "plot3.png",  width = 480, height = 480)
dev.off()
