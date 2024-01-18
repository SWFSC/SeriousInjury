#' @title Extract_Numeric_From_String
#'
#' @description
#' Extract numeric values appearing in data frame narratives to be used for VessSpd and VessSz covariate definitions
#'
#' @usage Extract_Numeric_From_String(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # Return a vector of unique numeric values appearing in object ʻdfʻ
#'
#' Values <- Extract_Numeric_From_String(WhaleData)
#'
#'
#' @export
#'


# Extract Numeric values from string to be used for vessel sizes and speeds.

Extract_Numeric_From_String <- function(df) {

  x <- unlist(regmatches(df$Narrative, gregexpr('\\(?[0-9,.]+', df$Narrative)))
  x <- as.numeric(gsub('\\(', '-', gsub(',', '', x)))
  x <- na.omit(x)

  unique.x <- unique(x)
  unique.x <- abs(unique.x)
  unique.x <- unique.x[unique.x<1600]
  unique.x

}
