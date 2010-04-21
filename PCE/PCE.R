# PCE.R
#
# Code to produce charts of US Personal Consumption Expenditure (PCE)
#
# Source data: BEA http://www.bea.gov/newsreleases/national/pi/pinewsrelease.htm
# obtained via St Louis Fed "FRED" database using the quantmod package
# http://research.stlouisfed.org/fred2/series/PCE
#
# The PCECTPI is a chain-type price index for personal consumption, with
# index base 2005 = 100. This can be used as a deflator to calculate PCE in
# real terms.

# The quantmod package will have to be installed if it is not already in place
# on your system.
library(quantmod)

# Read in PCE data from FRED
getSymbols("PCE", src="FRED")
getSymbols("PCECTPI", src="FRED")
PCE.t <- time(PCE)
PCE <- merge(PCE, PCECTPI)
# Linearly interpolate PCECTPI and extend final value
PCE$DEFLATOR <- na.approx(PCE$PCECTPI, rule=2)
PCE$REAL <- PCE$PCE / PCE$DEFLATOR * as.numeric(tail(PCE$DEFLATOR, 1))
PCE <- PCE[PCE.t,]

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
PCE.rate <- na.omit(diff(log(PCE), 12) * 100)
plot(time(PCE.rate), PCE.rate$PCE, type="l", ylab="Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$PCE, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(-850, 2.4, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()

# Plot Quarterly expenditure growth
png("PCE-growth-q.png", height=350, width=400)
par(mar=c(3.5,4,3,2.5))
PCE.rate <- na.omit(diff(log(PCE), 3) * 400)
plot(time(PCE.rate), PCE.rate$PCE, type="l", ylab="Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$PCE, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(-850, 2.4, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()

# Plot REAL expenditure growth
png("PCE-real-growth.png", height=350, width=400)
par(mar=c(3.5,4,3,2.5))
PCE.rate <- na.omit(diff(log(PCE$REAL), 12) * 100)
plot(time(PCE.rate), PCE.rate$REAL, type="l", ylab="Real Expenditure Growth (% per annum)")
lines(lowess(time(PCE.rate), PCE.rate$REAL, f=0.5), col="blue")

Axis(side=4)
grid(nx=NA, ny=NULL)
labels <- axis.Date(side=3, x=time(PCE.rate))
abline(v=labels, lty="dotted", col="lightgrey")
legend(4500, 8, lty=1, col="blue", legend="smoothed growth rate", bty="n")
dev.off()

