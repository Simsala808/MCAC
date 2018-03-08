\name{MCAC-package}
\alias{MCAC-package}
\alias{MCAC}
\docType{package}
\title{
  Multivariate Chi-Square Anomaly Classification
}
\description{
  This package allows for multivariate analysis of specific data sets generated from cyber intrusion detection and prevention system logs.  MCAC functionality transforms the raw data into a usable format and plots a Chi-Square QQ plot in which the mahalanobis distance squared is plotted against an associated Chi-Square value.  Package functionality allows for preparation of raw data, outlier classification, and plotting of the the Chi-Square QQ plot.
}
\details{
  This package can be used front he Studio console, or used to launch a Shiny app that combines package functionality into a user friendly shiny environment. Package functions are as follows:
  
- `prepareData()` : This function takes as an input a raw .csv log data file ad outputs prepares it for iterative anomaly removal.  This function outputs all arguments needed for the removeAnomaly function as well as the initial data frame needed for generating the first iteration of the Q-Q plot.
  
- `removeAnomaly()`: All arguments for this function are generated via the `prepareData()` function.  Running this function will remove the most anomalous observation, save that outlier and associated information in a data frame, and regenerate inputs for the next iteration of anomaly removal.
  
- `plotQQ()`: This function is used to generate the Chi-square Q-Q plot for the most current iteration.  This function takes as an argument either the chiSqrPlot or initialChiSqrPlot data frame.
  
- `runMCAC()`: This function initiates the MCAC shiny app.
  
}
\author{
Alexander Trigo, amtrigo891@gmail.com

Maintainer: Alexander Trigo <amtrigo891@gmail.com>
}
\references{
  This optional section can contain literature or other references for
  background information.
}
\keyword{ package }
\seealso{
  Optional links to other man pages
}
\examples{
  \dontrun{
     ## Optional simple examples of the most important functions
     ## These can be in \dontrun{} and \donttest{} blocks.   
  }
}
