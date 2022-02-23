#' @title SeriousInjuryTutorial
#'
#' @description View Package *Serious Injury* guide.
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export

 SeriousInjuryTutorial <- function() {
  browseURL("https://JimCarretta.github.io/index.html")
}

 #libname <- find.package("SeriousInjury")
 pkgname <- "SeriousInjury"

 onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}

