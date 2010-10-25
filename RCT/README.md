Risk Characteriztion Theatres (RCT)
===================================

In their book [The Illustion of Certainty][1], Eric Rifkin and Edward Bouwer
describe a graphical technique for communicating health benefit and risk information.
As they explain it:

> Most of us are familiar with the crowd in a typical theater as a
> graphic illustration of a population grouping.  It occurred to us
> that a theater seating chart would be useful for illustrating health
> benefit and risk information.  With a seating capacity of 1,000,
> our Risk Characterization Theater (RCT) makes it easy to illustrate
> a number of important values:  the number of individuals who would
> benefit from screening tests, the number of individuals contracting
> a disease due to a specific cause (e.g., HIV and AIDS), and the merits
> of published risk factors (e.g., elevated cholesterol, exposure to
> low levels of environmental contaminants).

I wrote about the use of RCTs in the blog post [Visualizing Smoking Risk][2],
which draws on one of Rifkin and Bouwer's case studies. For this post I wrote
some R code to facilitate drawing the theatres. As well as reproducing the standard
Rifkin and Bouwer theatre floor plan, I added a few more including a "stadium"
to illustrate more remote risks: a few in 10,000 rather than a few in 1,000.

In the post [Shades of grey][3] I experimented further with the RCTs, introducing
variable shading. Although the resulting charts are more efficient (i.e. they
communicate the same information with less "ink"), they are harder to interpret.

The files
---------

* plans.Rdata
  contains a data frame with details of all of the floor plans
* RCT.R
  defines the `rct` function to plot the RCTs
  
Usage
-----

	rct(cases, type="square", border="grey", xlim=c(0, 1), ylim=c(0, 1),
		fill=NULL, xlab=NULL, ylab="", lab.cex=1, seed=NULL, plot.new=TRUE,
		label=FALSE, lab.col="grey", draw.plot=TRUE, ...)
	
* `cases`: single number or vector giving the number of seats to shade. If a vector is
  supplied, the values indicate how many seats of each colour to shade. The sum of this
  vector gives the total number of seats shaded
* `type`: the floor plan to be used. Current options are "square", "theatre" (the original
  Rifkin and Bouwer floor plan), "stadium" and "bigsquare"
* `border`: the color for the outlines of the floor plan
* `xlim`, `ylim`: specify the range of the x and y axes. Note that the theate sits in the
  unit square with bottom corner (0, 0) and top corner (1, 1).
* `fill`: vector of colours for shading seats. If no value is supplied, the default is
  a sequence of shades of grey
* `xlab`: text label to appear below floor plan. Default is "x cases in n"
* `lab.cex`: character expansion factor (see 'par') to specify size of text labels (if any)
  on the floor plan
* `seed`: specify the starting seed value for the random number generator. Setting this
  makes it possible to reproduce exactly the same shaded seats on successive calls of rct
* `plot.new`: if FALSE, the theatre is drawn over the top of an existing plot
* `label`: if TRUE, any text labels for the specified floor plan will be displayed
* `lab.col`: colour used for any text labels
* `draw.plot`: if this is FALSE, the RCT is not drawn and instead a data frame is returned
  showing the seats that would have been shaded and the colours that would have been used
* `...`: any additional parameters are passed through to the plot call that sets up the chart
  
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">
<img alt="Creative Commons License" style="border-width:0"
src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />
<span xmlns:dct="http://purl.org/dc/terms/"
href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">RCT</span> by 
<a xmlns:cc="http://creativecommons.org/ns#" href="http://www.stubbornmule.net"
property="cc:attributionName" rel="cc:attributionURL">http://www.stubbornmule.net</a>
is licensed under a  
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">Creative Commons
Attribution-ShareAlike 3.0 Unported License</a>.
<br />
Based on a work at <a xmlns:dct="http://purl.org/dc/terms/"
href="http://github.com/seancarmody/stubborn-mule/tree/master/RCT/" rel="dct:source">github.com</a>

[1]: http://theillusionofcertainty.com/index.html "The Illustion of Certainty"
[2]: http://www.stubbornmule.net/2010/10/visualizing-smoking-risk/ "Visualizing Smoking Risk"
[3]: http://www.stubbornmule.net/2010/10/shades-of-grey/ "Shades of grey"