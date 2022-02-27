#' @title Barplot Covariates
#'
#' @description
#' Create barplot of injury covariates from data frame column 'Narrative',
#' stratified by known health status ("DEAD.DECLINE" vs "RECOVERED")
#'
#' @usage barplotCovariates(x)
#'
#' @param x an object of class 'data.frame'
#'
#' @author Jim Carretta <jim.carretta@noaa.gov>
#'
#' @examples barplotCovariates(WhaleDataCovs)
#'
#' @export
#'

# function barplotCovariates

 barplotCovariates <- function(df) {

 df <- WhaleData
 df.covars <- WhaleInjuryCovariates(df)

 df.covars$Health.status[grep("dead|decline", df.covars$Health.status, ignore.case=T)] <- "DEAD.DECLINE"
 df.covars$Health.status[grep("recovered", df.covars$Health.status, ignore.case=T)] <- "RECOVERED"
 df.covars$Health.status[grep("unknown", df.covars$Health.status, ignore.case=T)] <- "UNKNOWN"

# drop empty factors for Health.status

# levels(df.covars$Health.status) <- c("DEAD.DECLINE", "RECOVERED", "UNKNOWN")

 df.covars = droplevels(df.covars)

 first.covariate.col = which(names(df.covars) %in% "anchored")
 last.covariate.col = which(names(df.covars) %in% "VessSpd")
 covariate.names = names(df.covars[first.covariate.col:last.covariate.col])

 # index dead.decline and recovered health indices

 df.dead.decline = df.covars[grep("dead|decline", df.covars$Health.status, ignore.case=T),]
 df.recovered = df.covars[grep("recovered", df.covars$Health.status, ignore.case=T),]
 df.unknown = df.covars[grep("unk", df.covars$Health.status, ignore.case=T),]

 # sum presence / absence of covariates by df type (using numeric covariates)
 # identify numeric covariates

 numeric.covars <- c("anchored", "calf.juv", "constricting", "decline", "extensive.severe", "fluke.peduncle",
                     "gear.free", "head", "healing", "laceration.deep", "laceration.shallow", "pectoral",
                     "swim.dive", "trailing", "wraps.multi", "wraps.no")

 numeric.covars.cols <- which(names(df.covars) %in% numeric.covars)

# sum of positive variable occurrences for numeric variables over three health status responses
 s1 <- colSums(df.dead.decline[,numeric.covars.cols])
 s2 <- colSums(df.recovered[,numeric.covars.cols])
 s3 <- colSums(df.unknown[,numeric.covars.cols])

 s4 <- rbind.data.frame(s1, s2, s3)
 names(s4) <- numeric.covars

 t1 <- table(df.covars$Health.status, df.covars$VessSpd)
 t2 <- table(df.covars$Health.status, df.covars$VessSz)

 s4 <- cbind.data.frame(s4, t1[,1], t1[,2], t2[,1], t2[,2])

 names(s4) <- c(numeric.covars, colnames(t1)[1:2], colnames(t2)[1:2])

 df.final <- s4[,order(names(s4))]

 matrix <- as.matrix(df.final)
 ## keep only "DEAD.DECLINE" and "RECOVERED" response classes for plotting (omit "UNKNOWN")
 matrix <- matrix[1:2,]

# jpeg("Covariate_Barplot.jpg", width=2000, height=1200, units="px", res=300)

 use.colors <- c("black", "gray75")

 VPlot = barplot(matrix, width=0.5, ylab="Number Cases",
                 xaxt="n", xlab="", horiz=F, col=use.colors, main="")
 # rotate and place x axis text
 text(cex=1, x=VPlot + 0.25, y=-5, names(df.final), xpd=TRUE, srt=45, pos=2)

 legend.type=c("Dead.Decline", "Recovered")
 legend("topright", legend.type, title="Health Status", bty="n", col=use.colors, cex=0.75, fill=c(col=c(use.colors)))

 VPlot
# dev.off()

 }
