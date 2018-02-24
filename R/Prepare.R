#' @title Runs a shiny app in my package
#'
#' @description
#' Takes raw data frame as an input and generates tabulated state vector and initial
#' data structures necessary for chi-square plot generation
#' 
#' @importFrom anomalyDetection tabulate_state_vector
#' @importFrom tidyverse
#'
#' @param RawData Raw data observations as depicted in the SampleData data structure
#'
#' @return Tabulated state vector and input parameters for Remove function
#' @export


prepareData <- function(RawData) {
  
library(anomalyDetection)
library(tidyverse)
 
# variables and times are currently hard coded into the function, however, 
# these values can be reactively coded via R shiney
  
variables <- c('sourceAddress', 'destinationAddress', 'transportProtocol',
               'bytesIn', 'bytesOut', 'categoryOutcome', 'ad.SCN', 
               'IP_Pair', 'Device_Name')

times <- 'TIME_START'


# sort the data based on the column of start times
ReducedData <- RawData[, c(variables, times)] %>% 
  as.data.frame() %>%
  .[order(.[, length(variables) +1 ]),]

# generate state vector using anomalyDetection package
stateVector <<- anomalyDetection::tabulate_state_vector(ReducedData, 100, level_limit = 50, level_keep = 10) %>% 
  mc_adjust(., min_var = 0.1, max_cor = 0.9, action = "exclude") 


# Construction of a matrix of data for use in the Chi-Square plot generation
chiSqrData <<- cbind(anomalyDetection::mahalanobis_distance(stateVector, output = "md", normalize = TRUE)) %>%
  as.data.frame() %>% mutate(block = 1:nrow(.))

# ith ranked MD out of N is important
N <- nrow(ChiSqrData)
df <- ncol(AdjustedStateVector)

#Cumulative Probability based on p = (i - .5)/N  
p <- data.frame(CumProb= 1:N)

for (i in 1:N) {
  p[i, 1] = (i-.5)/N
}

# MD to be plotted against chi-sq values X^2 (p,r), where p is the cum prob and 
# r is the number of variables (degrees of freedom)

ChiSqr <- data.frame(ChiSqrVal = 1:N)

for (i in 1:N) {
  ChiSqr[i, 1] = qchisq(p[i,1], df )
}

ChiSqrPlot <- data.frame(ChiSqrData, ChiSqr, p) %>%
  rename(., MD = V1)


}



