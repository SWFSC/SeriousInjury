#' @title WhaleData
#'
#' @docType data
#'
#' @description
#' Whale injury data for package *SeriousInjury*. Data frame of > 1000 whale injury cases.
#' 'WhaleData' includes field 'Narrative' (case-sensitive) used to generate injury covariates
#' for use with Random Forest models used to predict health status.
#'
#' data frame 'entangle.data' includes cases used in RF entanglement model
#' data frame 'vessel.data' includes cases used in RF vessel strike model
#'
#' @usage data(WhaleData)
#' data(data.entangle)
#' data(data.vessel)
#'
#' @format WhaleData an object of class 'data.frame'
#'
#' @examples WhaleData
#' data.entangle
#' data.vessel
#'
"WhaleData"
"data.entangle"
"data.vessel"
