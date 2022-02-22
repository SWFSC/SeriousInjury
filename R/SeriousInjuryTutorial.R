#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

 url = "https://JimCarretta.github.io/index.html"

 SeriousInjuryTutorial <- function(x) {
  browseURL(url)
 }

 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
 }
