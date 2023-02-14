## R-Package *SeriousInjury* v1.2.0: 
## Classify Whale Injuries as Serious or Non-Serious with Classification Trees.



*SeriousInjury* uses Random Forest classification trees to assess injury severity of large whale entanglements and vessel 
strikes. Models are built using the R-Package *rfPermute*, which employs the R-package *randomForest*. Installing 
*SeriousInjury* will also install the *rfPermute* and *randomForest* packages. Methods are based on the publication:

[Carretta, J.V. and A. Henry 2022. Risk Assessment of Whale Entanglement and Vessel Strike Injuries from Case Narratives and Classification Trees. Frontiers In Marine Science](https://www.frontiersin.org/articles/10.3389/fmars.2022.863070/abstract), although *SeriousInjury* includes data for several more species not included in the publication.

To install the latest *SeriousInjury* version from GitHub:
```
# make sure you have devtools installed
if (!require('devtools')) install.packages('devtools')

# install from GitHub
devtools::install_github('JimCarretta/SeriousInjury')

library(SeriousInjury)

# see SeriousInjuryTutorial() for a guide to the package

```
## Random Forest (RF) Models

Two models are used in the package *SeriousInjury*, an entanglement and a vessel strike model. Each is based on n = 1,000 RF classification trees. Model concepts are shown in Figures 1 and 2.

![Figure 1. Example tree used to classify whale injuries as serious (*Dead.Decline*) or non-serious (*Recovered*). Data are based on known-outcome entanglement and vessel strike cases, where a known-outcome is a documented death, health decline or recovery. Health declines are considered serious injuries and recoveries are considered non-serious.](Tree Examples (2).PNG)

![Figure 2. Models consist of multiple bootstrap trees (a random forest) used to classify ‘out-of-bag’ (OOB) or novel cases. Samples not used in individual tree construction are considered OOB and are used to assess model accuracy through cross-validation. Novel cases represent new data or cases not included in models, for which health status is unknown.  The fraction of trees ‘voting’ for a particular class represents the probability of that case belonging to the class Dead.Decline or Recovered.](Tree Examples (1).PNG)
