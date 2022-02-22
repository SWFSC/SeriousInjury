#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

 SeriousInjuryTutorial <- function() {

<<<<<<< HEAD
 SeriousInjuryTutorial <- function() {
  browseURL(SIguide)
   SeriousInjuryTutorial()
 }
=======
   SIguide = "https://JimCarretta.github.io/index.html"
    SeriousInjuryTutorial <- browseURL(SIguide)
     SeriousInjuryTutorial
  }
>>>>>>> d923c0f9afe854505c793f77b5bd4d47ce3a4108

# onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
# }

