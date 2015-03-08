## Coursera Exploratory Data Analysis
## Programming Project 1: Individual household electric power consumption
## Data from the UC Irvine Machine Learning Repository http://archive.ics.uci.edu/ml/
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## Examine how household energy usage varies over a 2-day period in February, 2007.
## Plot Global_active_power: household global minute-averaged active power (in kilowatt)
## Eric W. Johnson, 3/8/2015
## File plot4.R -- combines four plots into one layout
##   Plot of Global Active Power in kilowatts by Date & Time (same as plot2)
##   Plot of Energy Sub Metering in Watt Hours by Date & Time (same as plot3)
##   Plot of Voltage by Date & Time
##   Plot of Global Reactive Power in kilowatts by Date & Time

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
png("plot4.png", width=480, height=480)

# Layout plots in 2x2 grid
par(mfcol = c(2,2))

# From plot2
plot(HEPC$DateTime, HEPC$Global_active_power, type="l", xlab="",
     ylab="Global Active Power (kilowatts)")

# From plot3
plot(HEPC$DateTime, HEPC$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering")
lines(HEPC$DateTime, HEPC$Sub_metering_2, col="red")
lines(HEPC$DateTime, HEPC$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1, bty="n")

# New plots
with (HEPC, {
  plot(DateTime, Voltage, type="l", xlab="datetime")
  plot(DateTime, Global_reactive_power, type="l", xlab="datetime")
})


# Close the device to save the file
dev.off()
