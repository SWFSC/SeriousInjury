#' @title SeriousInjury()
#'
#' @description
#'
#' Random Forest (RF) Method For Assessment of Whale Injuries
#'
#' Package includes example data.frame 'whales'
#' (n=20 records) for use with WhaleInjuryCovariates()
#'
#' @usage
#' RFSeriousInjuryTutorial()
#'
#' @param x an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples WhaleInjuryCovariates(whales)
#'
#' @export
#'
#'

SeriousInjuryTutorial <- function() {
  utils::browseURL(system.file("index.html", package = "SeriousInjury"))
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to SeriousInjury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}
