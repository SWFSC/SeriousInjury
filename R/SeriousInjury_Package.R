#' @title Tutorial
#'
#' @description Assign whale injuries as Serious vs Non-Serious with Random Forests
#'
#' @usage SeriousInjuryTutorial()
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
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
  browseURL(system.file("extdata", "index.html", package="SeriousInjury", mustWork=TRUE))
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to SeriousInjury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}
