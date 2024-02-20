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

    string <- paste(df$Narrative, collapse="")
    string <- as.character(string)

    # Extract all numeric values from the string
    numbers <- str_extract_all(string, "[0-9]+(\\.[0-9]+)?")[[1]]

    # unique values only

    numbers <- as.numeric(numbers)

    numbers <- unique(numbers)

    # only values <1600 are required (largest vessel in world = 1500 ft)

    numbers <- numbers[which(numbers<1600)]

    # return the values
    numbers

}
