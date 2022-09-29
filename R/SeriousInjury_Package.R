#' @title Tutorial
#'
#' @description Classify Whale Injuries as Serious or Non-Serious with Classification Trees
#'
#' @usage SeriousInjuryTutorial()
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples SeriousInjuryTutorial()
#'
#' @import ggplot2
#' @import graphics
#' @import grid
#' @import rfPermute
#' @import utils
#'
#' @export
#'
SeriousInjuryTutorial <- function() {
  browseURL(system.file("extdata", "SeriousInjuryTutorial.html", package="SeriousInjury", mustWork=TRUE))
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to SeriousInjury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )

}


