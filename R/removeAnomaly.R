
#' @title Remove Anomalous Observation
#'
#' @description
#' Removes the most anomalous observation associated with a data frame.  Uses the objects generated in the
#' global environment from the  prepareData function as arguments and overwrites them with reduced data.  This
#' allows for iteration.  The chiSqrPlot dataframe is used as the argument for the chiSqrQQ fucntion to genrate
#' a Chi-Square QQ plot.
#' 
#'
#' 
#' @import anomalyDetection
#' @import tidyverse
#' @import dplyr
#' 
#' 
#'
#' @param chiSqrPlot Contains observational Chi-square value, MD, time range, and associated block.
#' @param blocks Stores a current index vector of all non-classified blocks.
#' @param stateVector The current state vector.
#' @param outliers A current index vector of all observations classified as outliers.
#' @param error A current index vector of all errors assoiated with outlier removal.
#' @param timeData An index of all the time ranges associated with blocks. 
#' 
#'  
#'
#' @return Returns an updated iteration of all input parameters.   
#'
#' @export

removeAnomaly <- function(chiSqrPlot, blocks, stateVector, outliers, error, timeData) {
  
  
  # The block containing the current highest MD.  Rank sorting implies final row
  removeBlock <- chiSqrPlot[nrow(chiSqrPlot), "block"]
  
  # Generate specific index for that block
  removeIndex <- which(blocks$block == removeBlock) 
  
  # Update outlier dataframe with current outlier information
  outliers <- rbind(outliers, chiSqrPlot[nrow(chiSqrPlot), c("block", "mahalanobisDistance", "timeRange")])
  
  # Update blocks vector to exclude the block associated with the anomaly
  blocks <- data.frame(block = blocks[-removeIndex, ])           
  
  # Remove the anomalous observation from state vector data frame 
  stateVector <- stateVector[-removeIndex, ]                                
  
  
  
  # the chiSqrPlot dataframe must be recreated fro initial MD calculations
  
  
  
  chiSqrData <- cbind(anomalyDetection::mahalanobis_distance(stateVector, output = "md", normalize = TRUE)) %>%
    as.data.frame() %>%
    mutate(block = blocks[,1]) %>% 
    left_join(., timeData, by = "block") %>% 
    arrange(.,V1)
  

  
  # ith ranked MD out of n needed to calculate 
  n <- nrow(chiSqrData)
  df <- ncol(stateVector)
  
  #Cumulative Probability based on p = (i - .5)/n  
  p <- data.frame(cumProb = 1:n)
  
  for (i in 1:n) {
    p[i, 1] = (i-.5)/n
  }
  
  # MD to be plotted against chi-sq values X^2 (p,r), where p is the cum prob and 
  # r is the number of variables (degrees of freedom)
  
  chiSqr <- data.frame(chiSqrVal = 1:n)
  
  for (i in 1:n) {
    chiSqr[i, 1] = qchisq(p[i,1], df )
  }
  
 chiSqrPlot <- data.frame(chiSqr, chiSqrData) %>%
    rename(., mahalanobisDistance = V1)
 
  
  newError <- sqrt((sum((chiSqrPlot$chiSqrVal -
                            chiSqrPlot$mahalanobisDistance)^2))/
                      nrow(chiSqrPlot))
  
  error <- rbind(error, newError)
  
  chiSqrPlot <<- chiSqrPlot
  blocks <<- blocks
  stateVector <<- stateVector
  outliers <<- outliers
  error <<- error
  timeData <<- timeData
  
}
