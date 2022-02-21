#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
#'
#'

 SeriousInjuryTutorial <- function() {
  browseURL("https://JimCarretta.github.io/index.html")
 }

 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a package description."
  )
 }
