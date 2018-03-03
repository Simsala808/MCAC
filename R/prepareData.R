#' @title Preparation of Raw Data
#'
#' @description Takes raw data frame as an input and generates tabulated state vector and initial
#' data structures necessary for chi-square plot generation.  Functionality testign can
#' be conducted with the 'sampleData' Rda file included with this package.
#' 
#' @importFrom stats qchisq
#' @import anomalyDetection
#' @import ggplot2
#' @import dplyr
#' 
#' 
#'
#' @param rawData Raw data observations as depicted in the sampleData data structure
#' @param blocksize This input determines number of raw data observations per tabulated block 
#' 
#'
#' @return From raw date, return objects to the global environment that can be used in
#' 'removeAnomaly' and 'plotQQ' fucntions.
#'  
#' 
#' @export


prepareData <- function(rawData, blocksize = 100) {

  
 
# variables and times are currently hard coded into the function,
# ideally a user could select which variables to use from the rawdataset
  
variables <- c('sourceAddress', 'destinationAddress', 'transportProtocol',
               'bytesIn', 'bytesOut', 'categoryOutcome', 'ad.SCN', 
               'IP_Pair', 'Device_Name')

times <- 'TIME_START'


# sort the data based on the column of start times
reducedData <- rawData[, c(variables, times)] %>% 
  as.data.frame() %>%
  .[order(.[, length(variables) +1 ]),]

# generate state vector using anomalyDetection package
stateVector <- tabulate_state_vector(reducedData, blocksize, level_limit = 50, level_keep = 10) %>% 
  mc_adjust(., min_var = 0.1, max_cor = 0.9, action = "exclude") 

# Here we are creating time ranges corresponding to block sizes on the raw data time variable 

nb <- ceiling(nrow(rawData)/blocksize) 

timeData <- as.data.frame(reducedData[, times])

timeData <- timeData %>%
  mutate(block = rep(1:nb, each = blocksize, length.out = nrow(timeData))) %>%
  group_by(block) %>% 
  summarise(Min = min(`reducedData[, times]`),
            Max = max(`reducedData[, times]`)) %>% 
  mutate(timeRange = paste(Min, Max, sep = ' to ')) %>% 
  select(timeRange) %>%
  as.vector() %>%
  data.frame(., block = 1:nrow(.))


# Construction of a matrix of data for use in the Chi-Square plot generation
chiSqrData <- cbind(mahalanobis_distance(stateVector, output = "md", normalize = TRUE)) %>%
  as.data.frame() %>%
  mutate(block = 1:nrow(.)) %>% 
  left_join(., timeData, by = "block") %>% 
  arrange(.,V1)

# ith ranked MD out of N is important
n <- nrow(chiSqrData)
df <- ncol(stateVector)

#Cumulative Probability based on p = (i - .5)/N  
p <- data.frame(cumProb= 1:n)

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

blocks <- data.frame("block" = 1:nrow(stateVector))

outliers <- data.frame()

error <- data.frame(Error = sqrt((sum((chiSqrPlot$chiSqrVal -
                                         chiSqrPlot$mahalanobisDistance)^2))/nrow(chiSqrPlot)))

chiSqrPlot <<- chiSqrPlot
blocks <<- blocks
stateVector <<- stateVector
outliers <<- outliers
error <<- error
timeData <<- timeData


}


