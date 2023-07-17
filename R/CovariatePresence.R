#' @title CovariatePresence
#'
#' @description
#'
#' Use existing randomForest entanglement and vessel strike models to output data frame
#' that includes health status assignment probabilities ('DEAD.DECLINE' vs 'RECOVERED'),
#' and covariate states / presence from the 'Narrative' field.
#'
#' @usage CovariatePresence(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # Show model predictions alongside covariate states
#'
#' CovList <- CovariatePresence(data.test.entangle)
#' ENprobs <- predict(ModelEntangle, data.test.entangle, type="prob")
#' EN.df.probs <- cbind.data.frame(CovList, ENprobs)
#' head(EN.df.probs)
#'
#' @export
#'


CovariatePresence <- function(df) {

    empty_list <- vector(mode ="list", length = nrow(df))
    empty_list

    cov.names <- c("mobility.limited", "calf.juv", "constricting", "decline", "extensive.severe", "fluke.peduncle",
                   "gear.free", "head", "healing", "laceration.deep", "laceration.shallow", "pectoral",
                   "swim.dive", "trailing", "VessSpd", "VessSz", "wraps.multi", "wraps.no")

    cov.cols <- which(names(df) %in% cov.names)

    df <- df[,cov.cols]

    for (i in 1:nrow(df)) {

       pos.values <- which(df[i,]==1)

       CovNames1 <- names(df)[pos.values]
       CovNames1 <- paste(CovNames1, collapse=" ")
       CovNames2 <- as.character(df$VessSpd[i])
       CovNames3 <- as.character(df$VessSz[i])

       CovNamesAll <- paste(CovNames1, CovNames2, CovNames3, collapse=" + ")

       empty_list[i] <- CovNamesAll

    }

   empty_list <- gsub(" ", " + ", empty_list)
   empty_list

}





