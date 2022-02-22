#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

 SeriousInjuryTutorial <- function() {

   SIguide = "https://JimCarretta.github.io/index.html"
    SeriousInjuryTutorial <- browseURL(SIguide)
     SeriousInjuryTutorial
  }

 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
 }
