#plot4.R, draw multiple graph in one screen, by zbc
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

par(mfrow = c(2, 2)) # 4 graphs in 2 rows and 2 columns
x<-data_1_2Feb2007$Date
y1<-data_1_2Feb2007$Global_active_power
y2<-data_1_2Feb2007$Voltage

y31<-data_1_2Feb2007$Sub_metering_1
y32<-data_1_2Feb2007$Sub_metering_2
y33<-data_1_2Feb2007$Sub_metering_3

y4<-data_1_2Feb2007$Global_reactive_power

with(faithful, {
plot(x, y1, type="l" ,ylab="Global Active Power (kilowatts)", xlab="", width = 480, height = 480)
plot(x, y2, type="l" ,ylab="Voltage", xlab="datetime")

plot(x, y31, ylim=range(c(y31,y32,y33)), col="black", type="l" ,ylab="Energy sub metering", xlab="" )
lines(x, y32,col="red")
lines(x, y33, col="blue")
legend("topright", pch = '-', pt.cex=0.5, cex=0.5, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#cex is related to the legend text size
plot(x, y4, type="l", ylab="Global_reactive_power (kilowatts)", xlab="datetime" )

})


dev.copy(png, file = "plot4.png",  width = 480, height = 480,  units = 'px')
dev.off()