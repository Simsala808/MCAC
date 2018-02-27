


Remove <- function(chiSqrPlot, blocks, stateVector, outliers, error) {
  
  RemoveBlock <- CurrentChiSqrPlot[nrow(CurrentChiSqrPlot), "block"]            # Block containing hisghest MD
  RemoveIndex <- which(CurrentBlocks$block == RemoveBlock)                      # Generate specific index
  Outliers <- rbind(Outliers, CurrentChiSqrPlot[nrow(CurrentChiSqrPlot), 2:3])  # Add to outlier vector
  CurrentBlocks <- data.frame(block = CurrentBlocks[-RemoveIndex, ])            # Update Current Block vector   
  CurrentVector <- CurrentVector[-RemoveIndex, ]                                # Remove outlier from vector 
  
  
  CurrentChiSqrData <- cbind(mahalanobis_distance(CurrentVector, output = "md", # Recalculate MD
                                                  normalize = TRUE)) %>%
    as.data.frame() %>% 
    mutate(block = CurrentBlocks[,1]) %>% 
    left_join(., Times, by = "block") %>% 
    arrange(.,V1)
  
  # ith ranked MD out of N is important
  N <- nrow(CurrentChiSqrData)
  df <- ncol(CurrentVector)
  
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
  
  CurrentChiSqrPlot <- data.frame(CurrentChiSqrData, ChiSqr, p) %>%
    rename(., MD = V1)
  
  New_Error <- sqrt((sum((CurrentChiSqrPlot$ChiSqrVal -
                            CurrentChiSqrPlot$MD)^2))/
                      nrow(CurrentChiSqrPlot))
  
  
  Error <- rbind(Error, New_Error)
  
  
  # Plot the MD distances against the Chi-Sqr values for reduced dataset
  # plot <- ggplot(CurrentChiSqrPlot, aes(x= ChiSqrVal, y= MD)) + geom_point()
  # print(plot)
  
  # Create A list of these objects 
  return(list(CurrentChiSqrPlot, CurrentBlocks, CurrentVector, Outliers, Error))
}
