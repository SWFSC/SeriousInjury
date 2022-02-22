#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

<<<<<<< HEAD
 SeriousInjuryTutorial <- function() {
  SeriousInjuryTutorial <- browseURL("https://JimCarretta.github.io/index.html")
=======
 SIguide = "https://JimCarretta.github.io/index.html"

 SeriousInjuryTutorial <- function(x) {
  browseURL(SIguide)
>>>>>>> d45232fc6382574382e9d8b0565624d2a51ddfd3
 }

 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
 }
