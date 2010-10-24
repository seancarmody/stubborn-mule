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

[1]: http://theillusionofcertainty.com/index.html "The Illustion of Certainty"
[2]: http://www.stubbornmule.net/2010/10/visualizing-smoking-risk/ "Visualizing Smoking Risk"
[3]: http://www.stubbornmule.net/2010/10/shades-of-grey/ "Shades of grey"