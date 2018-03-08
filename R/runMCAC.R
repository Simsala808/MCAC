#' @title Run MCAC Shiny App
#'
#' @description
#' Running this function with default values will initiate the MCAC shiny application.
#' 
#' @importFrom shiny shinyAppDir
#' 
#'
#'
#' @param dir Character string for directory in this package
#' @param ... Additional options passed to shinyappDir
#'
#' @return A printed shiny app
#' @export

runMCAC <- function(dir, ...){
  
  list.of.packages <- c("shiny", "dplyr", "readr")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)

  
  #app_dir <- dirname('C:/Users/amtri/Desktop/AFIT/Final Class/MCAC/inst/apps/myfirstApp/ui.R/')
  app_dir <-system.file('apps', 'MCACapp', package = 'MCAC')
  
  shiny::shinyAppDir(app_dir, options = list(...))
  
}

