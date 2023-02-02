## R-Package *SeriousInjury* v1.2.0 Classify Whale Injuries as Serious or Non-Serious with Classification Trees.

The R-Package *SeriousInjury* uses Random Forest (RF) classification trees to assess injury severity of large whale entanglements and vessel strikes. Models are built using the R-Package *rfPermute*, which employs the R-package *randomForest*. Installing the package *SeriousInjury* will also install the *rfPermute* and *randomForest* packages. The method is based on the publication:

[Carretta, J.V. and A. Henry 2022. Risk Assessment of Whale Entanglement and Vessel Strike Injuries from Case Narratives and Classification Trees. Frontiers In Marine Science](https://www.frontiersin.org/articles/10.3389/fmars.2022.863070/abstract), although *SeriousInjury* includes data for several more large whale species not included in the publication.

To install the latest *SeriousInjury* version from GitHub:
```
# make sure you have devtools installed
if (!require('devtools')) install.packages('devtools')

# install from GitHub
devtools::install_github('JimCarretta/SeriousInjury')

library(SeriousInjury)

# see SeriousInjuryTutorial() for a guide to the package

```
