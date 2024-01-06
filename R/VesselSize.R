#' @title VessSz
#'
#' @description
#' Assess whether narratives include reference to vessel size.
#' Classify vessel sizes as small, large or unknown, using >=65 FT as threshold for large vessels
#'
#' @usage VessSz(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # append covariate VessSz to WhaleData
#'
#' VessSz <- VessSz(WhaleData)
#'
#'
#' @export

VessSz <- function(df) {

  # convert instances of ʻfeetʻ to ʻFTʻ to reduce dimensionality of regex

  df$Narrative <- gsub("feet", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" feet", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("foot", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" foot", "FT", df$Narrative, ignore.case=TRUE)

  small <- c(paste(seq(6,64.9,0.1), "FT", sep=""),
             "<65FT", "< 65FT", "<65 FT", "<65FT",
             "16-40FT", "40-", "40->65", "-65FT")

  large <- c(paste(seq(65,1500,1), "FT", sep=""),
             "container ship", "size much greater than whale",
             "in excess of 65 FT", "cruise ship", "navy", "naval", "transport",
             "ferry", "express", "vessel larger than whale", "assumed to be larger",
             "much larger than the whale", "wrapped around bow", "bow of a large ship",
             "larger and faster", "wrapped around bow", "brought into",
             "freight", "large ship", "carrier")

  small.ind <- paste(small, collapse="|")
  large.ind <- paste(large, collapse="|")

  small.cases <- grep(small.ind, df$Narrative, ignore.case=T)
  large.cases <- grep(large.ind, df$Narrative, ignore.case=T)

  df$VessSz <- "VSzUnk"    # baseline uniform assignment
  df$VessSz[small.cases] <- "VSzSmall"
  df$VessSz[large.cases] <- "VSzLarge"

  # if vessel strike outcome was mortality (MT), assume vessel speed was fast

  VS.mortality <- which(df$CAUSE=="VS" & df$DETERMINED.FATE=="MT")
  df$VessSz[VS.mortality] <- "VSzLarge"

  not.VS <- which(df$CAUSE!="VS")
  df$VessSz[not.VS] <- "VSzUnk"

  df$VessSz        }
