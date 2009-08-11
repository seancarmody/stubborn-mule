# Chart of FAO Fish import/export data
#
# Data source: ftp://ftp.fao.org/fi/stat/summary/summ_99/Yb89tabA3.pdf
#
# Licenced: creative commons Attribution-Share Alike 2.5 Australia
# http://creativecommons.org/licenses/by-sa/2.5/au/

# Read data (which has been converted to csv format)
data <- read.csv("fish.csv", as.is = c(1,4))

# Split into two tables for imports and exports
imports <- data[2:4]
rownames(imports) <- data[,1]
exports <- data[6:8]
rownames(exports) <- data[,5]

# Add 2006 exports to imports table
imports$E2006 <- exports[data[,1],3]

# 2006 imports and exports in a single table
trade <- imports[,3:4]/1000000

# Drop 2006 exports from imports table
imports <- imports[,-4]

# Produce chart in png format
png("fish.png", width=360, height=500)
par(bty="n", mar=c(1, 7, 1, 7))

# Set colors: upward sloping blue, downward sloping red
cols <- rep("blue", dim(trade)[1])
cols[trade[,2] < trade[,1]] <- "red"

# Plot lines
plot(c(0,1), trade[1,], ylab="", xlab="", type="l", ylim=c(0.6,14), yaxt="n", xaxt="n", col=cols[1])
for (i in 2:10) {
	lines(c(0,1), trade[i,], col=cols[i])
}

# Select countries for LHS labels
lab.nos <- c(1,2,3,4,5,6,8,10) 
labs <- paste(rownames(trade), format(trade[,1], digits=1))[lab.nos]

# Fudge to get Germany in
labs[7] <- "3.7 UK / 3.7 Germany"
axis(side=2, at=trade[lab.nos,1], labels=labs, las=1, lwd=0, line=-1.2, cex.axis=.8)

# Select countries for RHS labels
lab.nos <- c(1,3,4,5,6,8,9,10) 
labs <- paste(format(trade[,2], digits=1), rownames(trade))[lab.nos]

# Fudge to get Germany in
labs[6] <- "1.9 UK / 1.8 Germany"
axis(side=4, at=trade[lab.nos,2], labels=labs, las=1, lwd=0, line=-1.2, cex.axis=.8)

mtext("Imports (US$bn)", side=2, line=5)	
mtext("Exports (US$bn)", side=4, line=5)	

# Add Stubborn Mule label
mtext("stubbornmule.net ", side=1, cex=.8,  adj=1, line=-1.5, outer=TRUE) 

dev.off()
