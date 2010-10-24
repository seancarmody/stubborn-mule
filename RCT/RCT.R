# RCT.R
#
# Version 0.5
#
# Draws Risk Characterization Theatres (RCTs)
#
# Author: Sean Carmody

if (!exists("rct.plans")) load("plans.Rdata")

rct <- function(cases, type="square", border=par("fg"),
		fill=NULL, xlab=NULL, ylab="", lab.cex=1,
		label=FALSE, lab.col="grey", draw.plot=TRUE) {
	
	# Check the specified "floor plan" exists, otherwise use default
	if (!(type %in% names(rct.plans))) type <- "square"
	rct <- rct.plans[[type]]
	
	plan <- rct$plan
	n <- dim(plan)[1]
	if (length(fill) < length(cases)) fill <- rep(fill, length(cases))[1:length(cases)]

	plan$taken <- FALSE
	seats <- sample(1:n, sum(cases))
	plan$taken[seats] <- TRUE

	# Default shading: shades of grey
	if (is.null(fill)) fill <- gray(0:(length(cases)-1)/length(cases))

	col.hi <- cumsum(cases)
	col.lo <- c(1, col.hi[-length(col.hi)]+1)
	plan$col <- NA
	for (i in seq(along=cases)) {
		plan$col[seats[col.lo[i]:col.hi[i]]] <- fill[i]
	}
	
	l <- rct$labels	
	if (is.null(l)) label <- FALSE
	
	if (is.null(xlab)) xlab <- paste(prettyNum(sum(cases), big.mark=","),
		"cases in", prettyNum(n, big.mark=","))
	
	if (draw.plot) {
		plot(c(0, 1), c(0, 1), type="n", axes=FALSE, xlab=xlab, ylab=ylab)
		rect(plan$xleft, plan$ybottom, plan$xright, plan$ytop,
			border=border, col=plan$col)
		if (label) {
			if (is.na(l$pos[1])) l$pos <- NULL
			text(l$x, l$y, l$text, pos=l$pos, col=lab.col, xpd=NA, cex=lab.cex)
			}
		} else return(plan)
	}	
	
