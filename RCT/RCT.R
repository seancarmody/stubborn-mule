# RCT.R
#
# Version 0.5
#
# Draws Risk Characterization Theatres (RCTs)
#
# Requires the "plans.Rdata" file to load floor plans.
#
# Author:  Sean Carmody
# Created: 20 October 2010

if (!exists("rct.plans")) load("plans.Rdata")

rct <- function(cases, type="square", border="grey", xlim=c(0, 1), ylim=c(0, 1),
		fill=NULL, xlab=NULL, ylab="", lab.cex=1, seed=NULL, plot.new=TRUE,
		label=FALSE, lab.col="grey", draw.plot=TRUE) {
	
	# Check the specified "floor plan" exists, otherwise use default
	if (!(type %in% names(rct.plans))) type <- "square"
	rct <- rct.plans[[type]]
	
	# Get floor plan
	plan <- rct$plan
	n <- dim(plan)[1]
	
	# Recycle fill vector to have as many colours as cases
	if (length(fill) < length(cases)) fill <- rep(fill, length(cases))[1:length(cases)]

	# Assign seats
	plan$taken <- FALSE
	# Set random seed
	if (!is.null(seed)) set.seed(seed)
	seats <- sample(1:n, sum(cases))
	plan$taken[seats] <- TRUE

	# Default shading: shades of grey
	if (is.null(fill)) fill <- gray(0:(length(cases)-1)/length(cases))

	# Colour each case type differently
	plan$col <- NA
	plan$col[seats] <- unlist(sapply(seq(along=cases), function(i) rep(fill[i], cases[i])))
	
	# Get text labels (if they exist)
	l <- rct$labels	
	if (is.null(l)) label <- FALSE
	
	# Format label: "x cases in n"
	if (is.null(xlab)) xlab <- paste(prettyNum(sum(cases), big.mark=","),
		"cases in", prettyNum(n, big.mark=","))
	
	# Plot RCT
	if (draw.plot) {
		if ((dev.cur() == 1) | plot.new) plot(xlim, ylim, type="n", axes=FALSE, xlab=xlab, ylab=ylab)
		rect(plan$xleft, plan$ybottom, plan$xright, plan$ytop,
			border=border, col=plan$col)
		# Add text labels (if required)
		if (label) {
			if (is.na(l$pos[1])) l$pos <- NULL
			text(l$x, l$y, l$text, pos=l$pos, col=lab.col, xpd=NA, cex=lab.cex)
			}
		# Return the plan data (including taken seats and colours)
		# if the chart is not plotted
		} else return(plan)
	}	
	
