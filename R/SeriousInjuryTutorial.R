#' @title SeriousInjuryTutorial
#'
#' @usage SeriousInjuryTutorial()
#'
#' @export
<<<<<<< HEAD
SeriousInjuryTutorial <- function() {
#  utils::browseURL(system.file("index.html", package = "SeriousInjury"))
  utils::browseURL("index.html")
}
=======
#'
#'

 SIguide = "https://JimCarretta.github.io/index.html"


 SeriousInjuryTutorial <- function() {
  browseURL(SIguide)
   }

>>>>>>> 9055db3228a0704e9d2a6cc339e71ac5285e3158

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
<<<<<<< HEAD
    "Welcome to SeriousInjury v", utils::packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}
=======
    "Welcome to Serious Injury v", packageVersion("SeriousInjury"), "\n",
    "See SeriousInjuryTutorial() for a guide to the package."
  )
}

>>>>>>> 9055db3228a0704e9d2a6cc339e71ac5285e3158
