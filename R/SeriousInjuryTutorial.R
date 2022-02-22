#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

 SIguide = "https://JimCarretta.github.io/index.html"


 SeriousInjuryTutorial <- function() {
  browseURL(SIguide)
   }


 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}

