# PCE.R
#
# Code to produce charts of US Personal Consumption Expenditure (PCE)
#
# Source data: BEA http://www.bea.gov/newsreleases/national/pi/pinewsrelease.htm
# obtained via St Louis Fed "FRED" database using the quantmod package
# http://research.stlouisfed.org/fred2/series/PCE
#
# The PCEPI is a chain-type price index for personal consumption, with
# index base 2005 = 100. This can be used as a deflator to calculate PCE in
# real terms.

# The quantmod package will have to be installed if it is not already in place
# on your system.
library(quantmod)

# Read in PCE data from FRED
getSymbols("PCE", src="FRED")
getSymbols("PCEPI", src="FRED")
PCE <- merge(PCE, PCEPI)
PCE$REAL <- PCE$PCE / PCE$PCEPI * as.numeric(tail(PCE$PCEPI, 1))

# Draw full time-series chart
png("PCE.png", height=350, width=400)

# Set up margins
par(mar=c(3.5,4,3,4))

# Plot data 
plot(time(PCE), PCE$PCE, main="", log="y", type="l",
	ylab="Expenditure (US$ billion)")

# Plot secondary axis (log)
labels <- axTicks(2)
Axis(side=4, at=labels, labels=format(log(labels),digits=2))
mtext(side=4, line=2.5, "log Expenditure")

# Plot grid-lines
abline(h=labels, lty="dotted", col="lightgrey")
labels <- axis.Date(side=3, x=time(PCE))
abline(v=labels, lty="dotted", col="lightgrey")
dev.off()

# Dates from January 2005 (data for the last five years)
recent <- time(PCE) >= as.Date("2005-01-01")
png("PCE-5y.png", height=350, width=400)

# Set up margins
par(mar=c(3.5,4,3,4))

# Plot data 
plot(time(PCE)[recent], PCE$PCE[recent], main="", log="y", type="l",
	ylab="Expenditure (US$ billion)")

# Plot secondary axis (log)
labels <- axTicks(2)
Axis(side=4, at=labels, labels=format(log(labels),digits=2))
mtext(side=4, line=2.5, "log Expenditure")

# Plot grid-lines
abline(h=labels, lty="dotted", col="lightgrey")
labels <- axis.Date(side=3, x=time(PCE[recent]))
abline(v=labels, lty="dotted", col="lightgrey")
dev.off()

# Plot year-on-year expenditure growth
png("PCE-growth.png", height=350, width=400)
par(mar=c(3.5,4,3,2.5))
PCE.rate <- na.omit(diff(log(PCE$PCE), 12) * 100)
names(PCE.rate)[1] <- "PCE.ann"
plot(time(PCE.rate), PCE.rate$PCE.ann, type="l", ylab="Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$PCE.ann, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(-850, 2.4, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()

# Plot Quarterly expenditure growth
png("PCE-growth-q.png", height=350, width=400)
par(mar=c(3.5,4,3,2.5))
PCE.rate <- merge(PCE.rate, na.omit(diff(log(PCE$PCE), 3) * 400))
names(PCE.rate)[2] <- "PCE.qtr"
plot(time(PCE.rate), PCE.rate$PCE.qrt, type="l", ylab="Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$PCE.qrt, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(-850, 2.4, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()

# Plot REAL expenditure growth
png("PCE-real-growth.png", height=350, width=400)
par(mar=c(3.5,4,3,2.5))
PCE.rate <- merge(PCE.rate, na.omit(diff(log(PCE$REAL), 12) * 100))
names(PCE.rate)[3] <- "REAL.ann"
PCE.rate <- na.omit(PCE.rate)
plot(time(PCE.rate), PCE.rate$REAL.ann, type="l", ylab="Real Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$REAL.ann, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(4500, 8, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()
