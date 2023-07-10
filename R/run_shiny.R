#' Run Shiny interface with SeriousInjury
# Adapted from code by Dean Attali at
# https://deanattali.com/2015/04/21/r-package-shiny-app/#include-the-app-in-the-package-and-add-a-function-to-launch-it
#'
#' \code{run_shiny} runs a shiny application for the main functions in SeriousInjury.
#'
#' @details
#' Note:
#'
#' @return None
#'
#' @export
run_shiny <- function() {

    if (!requireNamespace("shiny", quietly = TRUE)) {
        stop("Package \"shiny\" needed for this function to work. Please install it.",
             call. = FALSE)
    }

    appDir <- system.file("shinyapp", "SeriousInjury", package = "SeriousInjury")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing `SeriousInjury`.", call. = FALSE)
    }

    shiny::runApp(appDir, display.mode = "normal")

}
