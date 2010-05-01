# plan.R
#
# ISP Broadband plan chart
# Original idea: @zebra (http://mulestable.net/zebra)
# See notice here: http://mulestable.net/notice/8521
# Source article here: http://bit.ly/dq29ux
# Note: chart only appeared in the print edition
#
# Author:  Sean Carmody
# Created: 1 May 2010

# Data was extracted with the help of Enguage Digitizer
# http://digitizer.sourceforge.net/
#
# For further discussion, read the Stubborn Mule blogpost:
# http://www.stubbornmule.net/2010/05/gigabang-for-your-buck/

data <- read.csv("all.csv")

# Strip out individual ISPs
telstra <- na.omit(data[,c(2,1)])
optus <- na.omit(data[,c(3,1)])
iinet <- na.omit(data[,c(4,1)])
tpg <- na.omit(data[,c(5,1)])

# Reorder
telstra <- telstra[order(telstra[,1]),]
optus <- optus[order(optus[,1]),]
iinet <- iinet[order(iinet[,1]),]
tpg <- tpg[order(tpg[,1]),]

# Produce png file
png("plan.png", width=350, heigh=375)

# Adjust margins of plot
par(mar=c(5,5,1,1))

# Plot and label each series
plot(telstra, ylim=c(40,200), xlim=c(0,225), ylab="Plan Cost ($ per month)",
  xlab="Download limit (GB per month)", type="b", pch=21)
text(110, 170, "Telstra", col="black")

points(optus, type="b", col="blue", pch=22)
text(190, 170, "Optus", col="blue")

points(iinet, type="b", col="darkgreen", pch=23)
text(140, 135, "iiNet", col="darkgreen")

points(tpg, type="b", col="red", pch=24)
text(130, 60, "TPG", col="red")

# Add gridlines
grid(col="lightgrey")

# Close and save plot device
dev.off()