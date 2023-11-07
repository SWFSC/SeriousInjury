#' @title BarplotCovariates
#'
#' @description
#' Create barplot of injury covariates, stratified by health status ("DEAD.DECLINE" vs "RECOVERED").
#' Covariates must be appended to data frame using function InjuryCovariates()
#'
#' @usage barplotCovariates(df)
#'
#' @param df an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples
#' # Generate barplot of covariates by health status
#'
#' WhaleDataCovs <- InjuryCovariates(WhaleData)
#'
#' barplotCovariates(WhaleDataCovs)
#'
#' @export
#'

# function barplotCovariates

 barplotCovariates <- function(df) {

 first.covariate.col = which(names(df) %in% "mobility.limited")
 last.covariate.col = which(names(df) %in% "VessSpd")
 covariate.names = names(df[first.covariate.col:last.covariate.col])

 # index dead.decline and recovered health indices

 df.dead.decline = df[grep("dead|decline", df$Health.status, ignore.case=T),]
 df.recovered = df[grep("recovered", df$Health.status, ignore.case=T),]
 df.unknown = df[grep("unk", df$Health.status, ignore.case=T),]

 # sum presence / absence of covariates by df type (using numeric covariates)
 # identify numeric covariates

 numeric.covars <- c("mobility.limited", "calf.juv", "constricting", "decline", "extensive.severe", "fluke.peduncle",
                     "gear.free", "head", "healing", "laceration.deep", "laceration.shallow", "pectoral",
                     "swim.dive", "trailing", "wraps.present", "wraps.absent")

 numeric.covars.cols <- which(names(df) %in% numeric.covars)

# sum of positive variable occurrences for numeric variables over three health status responses
 s1 <- colSums(df.dead.decline[,numeric.covars.cols])
 s2 <- colSums(df.recovered[,numeric.covars.cols])
 s3 <- colSums(df.unknown[,numeric.covars.cols])

 s4 <- rbind.data.frame(s1, s2, s3)
 names(s4) <- numeric.covars

 t1 <- table(df$Health.status, df$VessSpd)
 t2 <- table(df$Health.status, df$VessSz)

 s4 <- cbind.data.frame(s4, t1[,1], t1[,2], t2[,1], t2[,2])

 names(s4) <- c(numeric.covars, colnames(t1)[1:2], colnames(t2)[1:2])

 df.final <- s4[,order(names(s4))]

 injury.matrix <- as.matrix(df.final)

# keep only "DEAD.DECLINE" and "RECOVERED" response classes for plotting (omit "UNKNOWN")
 injury.matrix <- injury.matrix[1:2,]

# jpeg("Covariate_Barplot.jpg", width=2000, height=1200, units="px", res=300)

 use.colors <- c("black", "gray75")

 VPlot = barplot(injury.matrix, width=0.5, ylab="Number Cases",
                 xaxt="n", xlab="", horiz=F, col=use.colors, main="")
 # rotate and place x axis text
 text(cex=1, x=VPlot + 0.25, y=-5, names(df.final), xpd=TRUE, srt=45, pos=2)

 legend.type=c("Dead.Decline", "Recovered")
 legend("topright", legend.type, title="Health Status", bty="n", col=use.colors, cex=0.75, fill=c(col=c(use.colors)))

 VPlot

 }
