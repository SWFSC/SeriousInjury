#' @title UpdateInjuryModels
#'
#' @description
#' Generate Random Forest (RF) entanglement and vessel strike injury models.
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples ModelEntangle
#' ModelVessel
#'
#' @export
#'

 Update_Injury_Models = function(df) {

# Random Forest classification tree models used to predict entanglement and vessel strike health status. 9/1/2022
# Simple data frame version for use with single-field data frames including only 'Narrative'
#
# Reference: 	Carretta, J.V. and A. Henry. 2022. Risk assessment of large whale entanglements and vessel strikes
# from case narratives and random forest classification trees. Frontiers in Marine Science. https://doi.org/10.3389/fmars.2022.863070

# make sure you have devtools installed
if (!require('devtools')) install.packages('devtools')

# latest update of R-package 'SeriousInjury'

devtools::install_github("JimCarretta/SeriousInjury")

library(rfPermute)
library(tidyverse)
library(ggplot2)
library(ggforce)
library(devtools)
library(gridExtra)
library(SeriousInjury)
library(grid)
library(rlang)
library(vctrs)

 rm(list=ls())

 size.RF = 1000       # how many RF trees to build

 setwd("c:/carretta/github/SeriousInjury/inst/extdata")

 file.list <- dir(pattern="Recalculation -")

 Narratives_Health <- data.frame()

 for (i in 1:length(file.list)) { df <- read.csv(file.list[i])

 species <- substr(file.list[i], 32, 35)

 df$Species <- species

 Narratives_Health <- rbind.data.frame(Narratives_Health, df) }

 Narratives_Health$Health.status[grep("dead|decline", Narratives_Health$Health.status, ignore.case=TRUE)] <- "DEAD.DECLINE"
 Narratives_Health$Health.status[grep("recovered", Narratives_Health$Health.status, ignore.case=TRUE)] <- "RECOVERED"
 Narratives_Health$Health.status[grep("unknown", Narratives_Health$Health.status, ignore.case=TRUE)] <- "UNKNOWN"

# if blank lines occur in Narratives_Health, omit them, else ignore
 if (length(which(Narratives_Health$Narrative==""))>0)
   Narratives_Health <- Narratives_Health[-which(Narratives_Health$Narrative==""),]

   WhaleData <- Narratives_Health
   WhaleDataCovs <- InjuryCovariates(WhaleData)

    include.fields <- which(names(Narratives_Health)%in%c("Narrative","Health.status", "CAUSE"))
     Narratives_Health <- Narratives_Health[,include.fields]
      Narratives_HealthCovs = InjuryCovariates(Narratives_Health)

       Narratives_HealthCovs$VessSz <- factor(Narratives_HealthCovs$VessSz)
         Narratives_HealthCovs$VessSpd <- factor(Narratives_HealthCovs$VessSpd)

# Disentanglement effort made? These cases are omitted from model-building as they are 'biased' due to intervention.
# Such cases are part of novel data for which predictions are made.

 disentangle = grepl("disentangle|rescue|removed.*gear|gear.*removed|shorten|partial.*disentangl|telemetry", Narratives_HealthCovs$Narrative, ignore.case=T)
 disentangle = as.numeric(lapply(disentangle, as.numeric))
 intervention.cases = Narratives_HealthCovs[which(disentangle==1),]

 data.new = Narratives_HealthCovs[which(disentangle==0),]
 data.new$Health.status[grep("dead|decline", data.new$Health.status, ignore.case=TRUE)] <- "DEAD.DECLINE"
 data.new$Health.status[grep("recovered", data.new$Health.status, ignore.case=TRUE)] <- "RECOVERED"
 data.new$Health.status[grep("unknown", data.new$Health.status, ignore.case=TRUE)] <- "UNKNOWN"

 known = grep("DEAD.DECLINE|RECOVERED", data.new$Health.status, ignore.case=T)
 unknown = grep("UNKNOWN", data.new$Health.status, ignore.case=T)
 DataKnown = data.new[known,]
 DataUnknown = data.new[unknown,]

 dead.decline.ind = grep("DEAD.DECLINE", DataKnown$Health.status, ignore.case=T)
 recovered.ind = grep("RECOVERED", DataKnown$Health.status, ignore.case=T)

 DataKnown$Health.status <- factor(DataKnown$Health.status)

 data.model = DataKnown
 data.test = DataUnknown

 data.test.entangle <- data.test[data.test$CAUSE%in%c("EN", "ET"),]
 data.test.vessel <- data.test[data.test$CAUSE=="VS",]

# parse data into entanglement and vessel models

 data.entangle = data.model[which(data.model$CAUSE%in%c("EN","ET")),]
 omit.field <- which(names(data.entangle)=="CAUSE")
 data.entangle = data.entangle[,-omit.field]

 data.vessel = data.model[which(data.model$CAUSE%in%c("VS")),]
 omit.field = which(names(data.vessel)=="CAUSE")
 data.vessel = data.vessel[,-omit.field]

 # Use different covariate suites for entanglement + vessel strike models

 entangle.covariates = which(names(data.entangle)%in%c("mobility.limited", "calf.juv", "constricting", "decline", "extensive.severe", "fluke.peduncle", "gear.free", "head", "healing", "laceration.deep",
                                                    "laceration.shallow", "pectoral", "swim.dive", "trailing", "wraps.present", "wraps.absent"))

 vessel.covariates = which(names(data.vessel)%in%c("calf.juv", "decline", "extensive.severe", "fluke.peduncle", "head", "healing", "laceration.deep",
                                                  "laceration.shallow", "pectoral", "VessSpd", "VessSz"))


 ################################## Create randomForest models ###############################################

 set.seed(1234)

 #### Entanglement Model

 sampsize = balancedSampsize(data.entangle$Health.status)

 ModelEntangle = rfPermute(data.entangle$Health.status ~ ., data.entangle[,c(entangle.covariates)], sampsize=sampsize, ntree=size.RF, replace=FALSE, importance=TRUE, proximity=TRUE)


 ###### Vessel Strike Model

 sampsize = balancedSampsize(data.vessel$Health.status)

 ModelVessel = rfPermute(data.vessel$Health.status ~ ., data.vessel[,c(vessel.covariates)], sampsize=sampsize, ntree=size.RF, replace=FALSE, importance=TRUE, proximity=TRUE)

 ModelEntangle
 ModelVessel

### Save multiple objects to 'WhaleData.RData'
    save(WhaleData, data.entangle, data.vessel, data.test.entangle, data.test.vessel, entangle.covariates, vessel.covariates, data.model, ModelEntangle, ModelVessel, file="c:/carretta/GitHub/SeriousInjury/data/WhaleData.RData")
    save(WhaleData, data.entangle, data.vessel, data.test.entangle, data.test.vessel, entangle.covariates, vessel.covariates, data.model, ModelEntangle, ModelVessel, file="c:/carretta/GitHub/SeriousInjury/inst/extdata/WhaleData.RData")


}
