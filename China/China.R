# File:    China.R
# Author:  Sean Carmody
# Created: 25 August 2009
#
# Plots Australian exports to China for Stubborn Mule blog post
# http://www.stubbornmule.net/2009/08/china/ 
#
# All data sourced from the Australian Bureau of Statistics
# http://www.abs.gov.au

library(zoo)

# Read exports data an convert to zpo time series
exports <- read.csv("exports.csv", as.is=1)
exports <- zoo(exports[,-1], order.by=as.Date(exports[,1]))

# Read gdp data an convert to zpo time series
gdp <- read.csv("GDP.csv")
gdp <- zoo(gdp[,2], order.by=as.Date(gdp[,1]))

# Rolling sum to aggregate monthly data to quarterly
exports.q <- rollapply(exports, 3, sum, align="right")
exports.q <- merge(exports.q, gdp, all=FALSE)

# Read states final demand data an convert to zpo time series
states <- read.csv("states.csv")
states <- zoo(states[,-1], order.by=as.Date(states[,1]))
exports.q <- merge(exports.q, states$ACT, all=FALSE)

# Relabel some colums
names(exports.q)[3:4] <- c("GDP", "ACT")

# Rolling sum to aggregate quarterly data to yearly
exports.a <- rollapply(exports.q, 4, sum, align="right")

# Calculate some ratios
exports.q$China.pc <- exports.q$China / exports.q$GDP
exports.q$ACT.pc <- exports.q$ACT / exports.q$GDP
exports.q$China.share <- exports.q$China / exports.q$World

exports.a$China.pc <- exports.a$China / exports.a$GDP
exports.a$ACT.pc <- exports.a$ACT / exports.a$GDP
exports.a$China.share <- exports.a$China / exports.a$World

# Produce charts as png files
png("china-gdp.png", width=400, height=300)
par(bty="n", mar=c(3.5, 5, 1, 1))
plot(exports.a$China.pc * 100, xlab="", ylab="% GDP", bty="n")
mtext("stubbornmule.net", side=1, cex=0.8, line=2, adj=1)
dev.off()

png("china-gdp-chg.png", width=400, height=300)
par(bty="n", mar=c(3.5, 5, 1, 1))
plot(diff(exports.a$China.pc, 4) * 100, xlab="", ylab="% GDP", bty="n")
mtext("stubbornmule.net", side=1, cex=0.8, line=2, adj=1)
dev.off()

png("act-gdp.png", width=400, height=300)
par(bty="n", mar=c(3.5, 5, 1, 1))
plot(exports.a$ACT.pc * 100, xlab="", ylab="% GDP", bty="n", ylim=c(0,4.5))
lines(time(exports.a), exports.a$China.pc * 100, xlab="", col="red")
text(11700, 4.0, "ACT")
text(8800, 0.8, "China", col="red")
mtext("stubbornmule.net", side=1, cex=0.8, line=2, adj=1)
dev.off()

png("china-share.png", width=400, height=300)
par(bty="n", mar=c(3.5, 5, 1, 1))
plot(exports.a$China.share * 100, xlab="", ylab="% Total Exports", bty="n")
mtext("stubbornmule.net", side=1, cex=0.8, line=2, adj=1)
dev.off()
