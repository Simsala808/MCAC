#' @title Runs a shiny app in my package
#'
#' @description
#' Takes raw data frame as an input and generates tabulated state vector and initial
#' data structures necessary for chi-square plot generation
#' 
#' @import anomalyDetection
#' @import tidyverse
#' @import dplyr
#' 
#' 
#'
#' @param RawData Raw data observations as depicted in the SampleData data structure
#' @param Blocksize This input determines number of raw data observations per tabulated block 
#'
#' @return This transforms raw data input into the tabulated state vector and returns input arguments needed for remove function 
#'
#' @export


prepareData <- function(RawData, Blocksize = 100) {

  
 
# variables and times are currently hard coded into the function,
# ideally a user could select which variables to use from the rawdataset
  
variables <- c('sourceAddress', 'destinationAddress', 'transportProtocol',
               'bytesIn', 'bytesOut', 'categoryOutcome', 'ad.SCN', 
               'IP_Pair', 'Device_Name')

times <- 'TIME_START'


# sort the data based on the column of start times
ReducedData <- RawData[, c(variables, times)] %>% 
  as.data.frame() %>%
  .[order(.[, length(variables) +1 ]),]

# generate state vector using anomalyDetection package
stateVector <<- anomalyDetection::tabulate_state_vector(ReducedData, Blocksize, level_limit = 50, level_keep = 10) %>% 
  mc_adjust(., min_var = 0.1, max_cor = 0.9, action = "exclude") 

# Here we are creating time ranges corresponding to block sizes on the raw data time variable 

NB <- ceiling(nrow(RawData)/Blocksize) 

TimeData <- as.data.frame(ReducedData[, times])

TimeData <- TimeData %>%
  mutate(Block = rep(1:NB, each = Blocksize, length.out = nrow(TimeData))) %>%
  group_by(Block) %>% 
  summarise(Min = min(`ReducedData[, times]`),
            Max = max(`ReducedData[, times]`)) %>% 
  mutate(TimeRange = paste(Min, Max, sep = 'to')) %>% 
  dplyr::select(TimeRange) %>%
  as.vector() %>%
  data.frame(., block = 1:nrow(.))


# Construction of a matrix of data for use in the Chi-Square plot generation
chiSqrData <- cbind(anomalyDetection::mahalanobis_distance(stateVector, output = "md", normalize = TRUE)) %>%
  as.data.frame() %>%
  mutate(block = 1:nrow(.)) %>% 
  left_join(., TimeData, by = "block") %>% 
  arrange(.,V1)

# ith ranked MD out of N is important
N <- nrow(chiSqrData)
df <- ncol(stateVector)

#Cumulative Probability based on p = (i - .5)/N  
p <- data.frame(CumProb= 1:N)

for (i in 1:N) {
  p[i, 1] = (i-.5)/N
}

# MD to be plotted against chi-sq values X^2 (p,r), where p is the cum prob and 
# r is the number of variables (degrees of freedom)

chiSqr <- data.frame(chiSqrVal = 1:N)

for (i in 1:N) {
  chiSqr[i, 1] = qchisq(p[i,1], df )
}

chiSqrPlot <<- data.frame(chiSqr, chiSqrData) %>%
  rename(., MD = V1)

blocks <<- data.frame("block" = 1:nrow(stateVector))

outliers <<- data.frame()

error <<- data.frame(Error = sqrt((sum((chiSqrPlot$chiSqrVal -
                                         chiSqrPlot$MD)^2))/nrow(chiSqrPlot)))


}


