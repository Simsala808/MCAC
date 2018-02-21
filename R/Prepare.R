


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


}



