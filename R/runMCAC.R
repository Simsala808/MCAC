#' @title Run MCAC Shiny App
#'
#' @description
#' Runs as shiny app
#' 
#' @importFrom shiny shinyAppDir
#'
#' @param dir Character string for directory in this package
#' @param ... Additional options passed to shinyappDir
#'
#' @return A printed shiny app
#' @export

runMCAC <- function(dir, ...){
  
  #app_dir <- dirname('C:/Users/amtri/Desktop/AFIT/Final Class/MCAC/inst/apps/myfirstApp/ui.R/')
  app_dir <-system.file('apps', 'MCACapp', package = 'MCAC')
  
  shiny::shinyAppDir(app_dir, options = list(...))
  
}

