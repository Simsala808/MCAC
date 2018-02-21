#' @title Runs a shiny app in my package
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

run_myfirstApp <- function(dir, ...){
  
  #app_dir <- dirname('C:/Users/amtri/Desktop/AFIT/Final Class/MCAC/inst/apps/myfirstApp/ui.R/')
  app_dir <-system.file('apps', 'myfirstApp', package = 'MCAC')
  
  shiny::shinyAppDir(app_dir, options = list(...))
  
}

