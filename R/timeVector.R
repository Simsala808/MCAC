

timeVector <- function(TimeData, BlockSize) {
  
  NB <- ceiling(nrow(TimeData)/BlockSize) 
  TimeData %>% 
    mutate(Block = rep(1:NB, each = BlockSize, length.out = nrow(TimeData))) %>%
    group_by(Block) %>% 
    summarise(Min = min(`ReducedData[, "TIME_START"]`),
              Max = max(`ReducedData[, "TIME_START"]`)) %>% 
    mutate(TimeRange = paste(Min, Max, sep = 'to')) %>% 
    dplyr::select(TimeRange) %>%
    as.vector() 
}
