## R-Package *SeriousInjury*: Classify Whale Injuries as Serious or Non-Serious with Classification Trees.

*SeriousInjury* uses Random Forest classification trees to assess injury severity of large whale entanglements and vessel 
strikes. Models are built using the R-Package *rfPermute*, which employs the R-package *randomForest*. Installing 
*SeriousInjury* will also install the *rfPermute* and *randomForest* packages. Methods are based on the publication:

[Carretta, J.V. and A. Henry 2022. Risk Assessment of Whale Entanglement and Vessel Strike Injuries from Case Narratives and Classification Trees. Frontiers In Marine Science](https://www.frontiersin.org/articles/10.3389/fmars.2022.863070/abstract), although *SeriousInjury* includes data for several more species not included in the publication.

Version 1.5 includes a Shiny app to allow assessment of single injury narratives. ʻMonofilament_Hook_Lineʻ, ʻVessSpdʻ, ʻVessSzʻ functions are updated as separate functions nested within the larger function ʻInjuryCovariatesʻ

To install the latest *SeriousInjury* version from GitHub:
```
# make sure you have devtools installed
if (!require('devtools')) install.packages('devtools')

# install from GitHub
devtools::install_github('JimCarretta/SeriousInjury')

library(SeriousInjury)

# see SeriousInjuryTutorial() for a guide to the package

```
### "This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project
code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub
project will be governed by all applicable Federal law. Any reference to specific commercial products,
processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or
imply their endorsement, recommendation or favoring by the Department of Commerce. The Department
of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to
imply endorsement of any commercial product or activity by DOC or the United States Government.”

