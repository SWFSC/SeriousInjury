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

  # extract unique numeric values from df; assign to small or large vessel sizes

    unique.values <- Extract_Numeric_From_String(df)

    small <- unique.values[unique.values<65]
    large <- unique.values[unique.values>=65]

  # replace apostrophe-abbreviated lengths with "FT" (i.e. 90' <- 90FT)

    df$Narrative <- gsub("0'", "0FT", df$Narrative)
    df$Narrative <- gsub("1'", "1FT", df$Narrative)
    df$Narrative <- gsub("2'", "2FT", df$Narrative)
    df$Narrative <- gsub("3'", "3FT", df$Narrative)
    df$Narrative <- gsub("4'", "4FT", df$Narrative)
    df$Narrative <- gsub("5'", "5FT", df$Narrative)
    df$Narrative <- gsub("6'", "6FT", df$Narrative)
    df$Narrative <- gsub("7'", "7FT", df$Narrative)
    df$Narrative <- gsub("8'", "8FT", df$Narrative)
    df$Narrative <- gsub("9'", "9FT", df$Narrative)

  # convert instances of ʻfeetʻ to ʻFTʻ to reduce dimensionality of regex

  df$Narrative <- gsub("feet", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" feet", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("foot", "FT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" foot", "FT", df$Narrative, ignore.case=TRUE)

  small <- c(paste(small, "FT", sep=""), paste(small, "FT", sep=" "),
             "<65FT", "< 65FT", "<65 FT", "<65FT",
             "16-40FT", "40-", "40->65", "-65FT")

  large <- c(paste(large, "FT", sep=""), paste(large, "FT", sep=" "),
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
