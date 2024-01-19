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

  small.1 <- paste(small, "FT", sep="", collapse="|")
  small.2 <- paste(small, "FT", sep=" ", collapse="|")
  small.3 <- ("<65FT|< 65FT|<65 FT|<65FT|16-40FT|40-|40->65|-65FT|kayak")

  small <- sort(paste(small.1, small.2, small.3))

  large.1 <- paste(large, "FT", sep="", collapse="|")
  large.2 <- paste(large, "FT", sep=" ", collapse="|")
  large.3 <- paste(c("container ship", "size much greater than whale", "in excess of 65 FT",
                   "cruise ship", "navy", "naval", "transport", "ferry", "express", "vessel larger than whale",
                   "assumed to be larger", "much larger than the whale", "wrapped around bow", "bow of a large ship",
                   "larger and faster", "wrapped around bow", "brought into", "freight", "large ship", "carrier",
                   "carcass", "dead", "fracture", "verteb", "decomp", "hemorrhage", "blunt force trauma", "necrop", "broken"), collapse="|")

  large <- sort(paste(large.1, large.2, large.3))


  small.cases <- grep(small, df$Narrative, ignore.case=T)
  large.cases <- grep(large, df$Narrative, ignore.case=T)

  df$VessSz <- "VSzUnk"    # baseline uniform assignment
  df$VessSz[small.cases] <- "VSzSmall"
  df$VessSz[large.cases] <- "VSzLarge"

  df$VessSz        }
