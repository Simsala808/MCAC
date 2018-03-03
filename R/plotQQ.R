#' @title Generate Current Chi-Square Q-Q Plot
#'
#' @description This function uses the chiSqrPlot object as an argument and plots the MD vs the associated
#' Chi-Square distribution value.  The red line plotted is the model for perfect multivariate normality.  The chiSqrPlot
#' object can be generated via either the `prepareData` or `removeAnomaly` fucntion.
#' 
#' @import ggplot2
#'
#' @param chiSqrPlot Contains observational Chi-square value, MD, time range, and associated block.
#' 
#' @return Returns a Chi-Square Q-Q plot.   
#'
#' @export
#' 
#' 
#' 
plotQQ <- function(chiSqrPlot){
  
  ggplot(chiSqrPlot, aes(x = chiSqrVal, y = mahalanobisDistance)) + 
    geom_point() + 
    geom_abline(slope = 1, intercept = 0, color = "red") + 
    xlim(0, max(chiSqrPlot$chiSqrVal)) +
    ylim(0, max(chiSqrPlot$mahalanobisDistance)) +
    ggtitle("Chi-Square Q-Q Plot")
  
}