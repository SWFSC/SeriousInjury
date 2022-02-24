#' @title SeriousInjuryTutorial
#'
#' @description Package to assess large whale injuries with Random Forests
#'
#' @usage SeriousInjuryTutorial()
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' @export SeriousInjuryTutorial
#'
SeriousInjuryTutorial <- function() {
  browseURL("https://JimCarretta.github.io")
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to SeriousInjury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}
