#' @title Monofilament_Hook_Line
#'
#' @description
#' Create a covariate to identify monofilament line, but exclude monofilament gillnets.
#' Targeted toward hook and line entanglements involving monofilament line.
#'
#' @usage Monofilament(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#' # Identify which cases include non-gillnet monofilament
#'
#' Monofilament <- Monofilament(WhaleData)
#'
#' @export
#'

# Monofilament hook and line covariate generation.

 Monofilament_Hook_Line <- function(df) {

     net <- grepl("gill|netting|web|mesh", df$Narrative, ignore.case=TRUE)

     hook.mono <- grepl("mono|hook|lure", df$Narrative, ignore.case=TRUE)

     mono.only <-which(net==FALSE & hook.mono==TRUE)

     df$monofilament.line <- 0
     df$monofilament.line[mono.only] <- 1

     return(df)

 }


