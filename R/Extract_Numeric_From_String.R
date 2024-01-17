#' @title ExtractNumbers
#'
#' @description
#' Extract numeric values appearing in data frame narratives to be used for VessSpd and VessSz covariate definitions
#'
#' @usage ExtractNumbers(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#'
#' # Return a vector of unique numeric values appearing in object ʻdfʻ
#'
#' Values <- ExtractNumbers(WhaleData)
#'
#'
#' @export
#' 


# Extract Numeric values from string to be used for vessel sizes and speeds.

Extract_Numeric_From_String <- function(df) {

# Function to find numeric values in a string
find_numeric <- function(input_string) {
  # Use regular expression to find whole numbers
  numbers <- str_extract_all(input_string, "\\b\\d+\\b")[[1]]
  return(as.numeric(numbers))
}


empty.vec <- vector()

for (i in 1:nrow(df)) {
  
  record.numbers <- find_numeric(df$Narrative[i])
  
  empty.vec <- c(record.numbers, empty.vec)
  
}

# remove all values that represent years or whale ID numbers (anything greater than largest known vessel around 1500 ft).
# reduce values to unique values

unique.numeric <- sort(unique(empty.vec))

unique.numeric }
