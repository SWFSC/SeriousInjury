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

#  extract unique numeric values from df; assign to slow or fast vessel speeds

    unique.values <- Extract_Numeric_From_String(df)

    slow <- unique.values[unique.values<=10]
    fast <- unique.values[unique.values>10 & unique.values<100]


  # convert instances of ʻknot|knots|kts to ʻKTʻ to reduce dimensionality of regex

  df$Narrative <- gsub("knots", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("kts ", "KT", df$Narrative, ignore.case=TRUE)
  df$Narrative <- gsub("kt", "KT", df$Narrative, ignore.case=TRUE)

   slow.1 <- paste(slow, "KT", sep="", collapse="|")
   slow.2 <- paste(slow, "KT", sep=" ", collapse="|")
   slow.3 <- "<10KT|< 10KT|kayak"

   if(length(slow)>0) { slow.str <- paste(c(slow.1, slow.2, slow.3), sep="", collapse="|") }
   if(length(slow)==0) { slow.str <- slow.3 }

   fast.1 <- paste(fast, "KT", sep="", collapse="|")
   fast.2 <- paste(fast, "KT", sep=" ", collapse="|")

   if(length(fast)>0) { fast.str <- paste(c(fast.1, fast.2, "broken","blunt force","carcass","dead","decomp","exceeded 10",
                                           "fast","fracture","hemor","high rate","large ship","larger and faster than whale",
                                           "necrop","stuck on bow","verteb","wrapped around bow",">10KT",">10 KT","> 10KT","> 10 KT"), sep=",", collapse="|")
   }

   if(length(fast)==0) { fast.str <- paste(c("broken","blunt force","carcass","dead","decomp","exceeded 10",
   "fast","fracture","hemor","high rate","large ship","larger and faster than whale",
   "necrop","stuck on bow","verteb","wrapped around bow",">10KT",">10 KT","> 10KT","> 10 KT"), sep=",", collapse="|") }


   slow.cases <- grep(slow.str, df$Narrative, ignore.case=T)
   fast.cases <- grep(fast.str, df$Narrative, ignore.case=T)

# default VessSpd assignment to account for entanglement cases or unknown speed

         df$VessSpd <- "VSpdUnk"

         df$VessSpd[slow.cases] <- "VSpdSlow"
         df$VessSpd[fast.cases] <- "VSpdFast"

         df$VessSpd
}
