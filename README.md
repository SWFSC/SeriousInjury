## R-Package *SeriousInjury*: Classify Whale Injuries as Serious or Non-Serious with Classification Trees.


*SeriousInjury* uses Random Forest classification trees to assess injury severity of large whale entanglements and vessel 
strikes. Models are built using the R-Package *rfPermute*, which employs the R-package *randomForest*. Installing 
*SeriousInjury* will also install the *rfPermute* and *randomForest* packages. Methods are based on the publication:

[Carretta, J.V. and A. Henry 2022. Risk Assessment of Whale Entanglement and Vessel Strike Injuries from Case Narratives and Classification Trees. Frontiers In Marine Science](https://www.frontiersin.org/articles/10.3389/fmars.2022.863070/abstract), although *SeriousInjury* includes data for several more species not included in the publication.

Version 1.3 includes a Shiny app to allow assessment of single injury narratives. Vessel speed and vessel size functions are updated as separate functions nested within the larger function ʻInjuryCovariatesʻ

To install the latest *SeriousInjury* version from GitHub:
```
# make sure you have devtools installed
if (!require('devtools')) install.packages('devtools')

# install from GitHub
devtools::install_github('JimCarretta/SeriousInjury')

library(SeriousInjury)

# see SeriousInjuryTutorial() for a guide to the package

```

