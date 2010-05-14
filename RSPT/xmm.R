# xmm.R
#
# Generate chart of mining sector performance relative to
# the broader market since the introduction of the RSPT

# Load the zoo module (used for managing time-series data)
library(zoo)

# Load index data
data <- read.csv("xmm.csv")

# Convert dates from strings to date format

data$date <- as.Date(data$date)

# Convert date into zoo format
data <- zoo(data[,-1], order.by=data[,1])

# Drop everything before 30 April 2010
x <- data[time(data) >= as.Date("2010-04-30"),]

# Rescale to 100 on 30 April
x$XMM <- x$XMM / as.numeric(x$XMM[1]) * 100
x$ASX300 <- x$ASX300 / as.numeric(x$ASX300[1]) * 100

# Calculate difference in cumulative returns
x$difference <- x$ASX300 - x$XMM

# Create chart
png("xmm.png", width=400, height=280, res=90)

# Set chart margins
par(mar=c(3, 4.5,1,2.5))
plot(x$XMM, xlab="", ylab="Price Index (30 Apr 2010 = 100)", col="red")
lines(x$ASX300, col="blue")

# Add gridlines
grid()

# Add another axis label
axis(4)

# Put in labels
text(14733.6, 98, "S&P/ASX 300", pos=4)
text(14736.5, 93, "Metals & Mining", pos=4)#dev.off()

# Close and save chart
dev.off()