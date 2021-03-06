## Coursera Exploratory Data Analysis
## Programming Project 1: Individual household electric power consumption
## Data from the UC Irvine Machine Learning Repository http://archive.ics.uci.edu/ml/
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## Examine how household energy usage varies over a 2-day period in February, 2007.
## Plot Global_active_power: household global minute-averaged active power (in kilowatt)
## Eric W. Johnson, 3/8/2015
## File plot3.R -- Plot of Energy Sub Metering in Watt Hours by Date & Time

## Read Individual household electric power consumption into HEPC Data Frame
GetHEPCData = function() {
     # Read in data
     HEPC <<- read.table(
          "household_power_consumption.txt", header = T, sep = ";", na.strings = "?",
          colClasses = c("character", "character", "numeric", "numeric", "numeric",
                         "numeric", "numeric", "numeric", "numeric"))
     
     # Convert date
     HEPC$DateTime <<- as.Date(HEPC$Date, "%d/%m/%Y")
     
     # Subset data
     HEPC <<- subset(HEPC, DateTime >= as.Date("2007-02-01") &
                          DateTime <= as.Date("2007-02-02"))
     
     # Check if there are any NAs left
     if (sum(is.na(HEPC)) > 0) {
          stop("There are NAs in our subset")
     }
     
     # Convert date and time into one column
     HEPC$DateTime <<- strptime(paste(HEPC$Date, HEPC$Time), "%d/%m/%Y %H:%M:%S",
                                tz="GMT")
     HEPC$Date <<- NULL
     HEPC$Time <<- NULL
     
     # Verify structure
     str(HEPC)
}

if (!exists("HEPC")) {
     GetHEPCData()
}

# Open the device
png("plot3.png", width=480, height=480)

# Display the plot
plot(HEPC$DateTime, HEPC$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering")
lines(HEPC$DateTime, HEPC$Sub_metering_2, col="red")
lines(HEPC$DateTime, HEPC$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1)

# Close the device to save the file
dev.off()
