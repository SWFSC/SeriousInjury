#' @title VessSpd
#'
#' @description
#' Assess whether narratives include reference to vessel speed.
#' Classify vessel speeds as unknown, slow, or fast, based on a threshold of <=10 KTs being ʻslowʻ
#'
#' @usage VessSpd(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # append covariate VessSpd to WhaleData
#'
#' VessSpd <- VessSpd(WhaleData)
#'
#'
#' @export


VessSpd <- function(df) {

  # convert instances of ʻknot|knots|kts to ʻKTʻ to reduce dimensionality of regex

  df$Narrative <- gsub("knot", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" knot", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("knots", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" knots", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("kts", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub(" kts", "KT", df$Narrative, ignore.case=TRUE)

       slow <- c(paste(seq(0,10,0.1), "KT"),
                  paste(seq(0,10,0.1), "KT", sep=""),
                  paste(seq(0,10,0.1), "KT"),
                  paste(seq(0,10,0.1), " KT", sep=""),
                 "<10KT", "< 10KT", "<10 KT", "<10KT")

       fast <- c(paste(seq(10.1,50,0.1), "KT"),
                 paste(seq(10.1,50,0.1), "KT", sep=""),
                 paste(seq(10.1,50,0.1), "KT"),
                 paste(seq(10.1,50,0.1), " KT", sep=""),
                 "fast moving", "fast-moving", "high rate", "wrapped around bow",
                 "stuck on bow", "larger and faster than whale", "bow of a large ship",
                 ">10KT", ">10 KT", ">10 KT", ">10KT", "exceeded 10 KT", "exceeded 10KT")

          slow.ind <- paste(slow, collapse="|")
          fast.ind <- paste(fast, collapse="|")

          slow.cases <- grep(slow.ind, df$Narrative, ignore.case=T)
             fast.cases <- grep(fast.ind, df$Narrative, ignore.case=T)

         df$VessSpd <- "VSpdUnk"    # baseline uniform assignment
         df$VessSpd[slow.cases] <- "VSpdSlow"
         df$VessSpd[fast.cases] <- "VSpdFast"

# if vessel strike outcome was mortality (MT), assume vessel speed was fast

         VS.mortality <- which(df$CAUSE=="VS" & df$DETERMINED.FATE=="MT")
         df$VessSpd[VS.mortality] <- "VSpdFast"

         not.VS <- which(df$CAUSE!="VS")
         df$VessSpd[not.VS] <- "VSpdUnk"

         df$VessSpd
}
