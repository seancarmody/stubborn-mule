# charts.R
#
# Author: Sean Carmody
#
# Produce charts using from the Guardian's list of
# "1000 songs to hear before you die" 
#
# Licenced: creative commons Attribution-Share Alike 2.5 Australia
# http://creativecommons.org/licenses/by-sa/2.5/au/

mule <- function(side=1, cex=0.8, line=2, adj=1,...) {
	# Add "stubbornmule.net" label to the bottom of charts
	mtext("stubbornmule.net", side=side, cex=cex,  adj=adj, line=line, ...)
}

# Read in the song list
data <- read.csv("1000.csv",as.is=c(FALSE, TRUE, FALSE, TRUE, TRUE))

# Box and whisker plot

png("box.png", width=400, height=250)

box.wex <- 0.7
par(mar=c(3.5,9,0.5,1), bty="n")
box.res <- plot(data$THEME, data$YEAR, horizontal=TRUE, las=1, boxwex=box.wex, bty="n")
means <- tapply(data$YEAR, data$THEME, mean)

# Add light lines to indicate means
for (i in 1:7){
	lines(rep(means[i],2), c(i-box.wex/2+0.05, i+box.wex/2-0.05), lty=1, col="grey")
}

mule()
dev.off()

# Histograms 
png("histograms.png", width=300, height=1400)
par(bty="n", mfcol=c(7,1), mar=c(4,5,3,1), cex.main=1.5, cex.axis=1.5, cex.lab=1.5)
for (i in 1:7){
	theme <- levels(data$THEME)[i]
	hist(data$YEAR[data$THEME==theme], main=theme, xlab="")
}
mule(line=2.5)
dev.off()

# Mosaic plot

data$DECADE <- floor(data$YEAR/10) * 10
data$BAND <- paste(data$DECADE, "s", sep="")
data$BAND[data$DECADE < 1960] <- "1910s-50s"

png("mosaic.png", width=400, heigh=300)
par(mar=c(1.5,0.5,0.5,0.5), cex=1.2)
plot(table(data$BAND, data$THEME), col=rainbow(7), las=1, main="")

mule(line=0)
dev.off()
