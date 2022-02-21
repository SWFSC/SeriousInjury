#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export

SeriousInjuryTutorial <- function() {

  utils::browseURL("https://jimcarretta.github.io/index.html")
}

onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to Serious Injury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a package description."
  )
}
