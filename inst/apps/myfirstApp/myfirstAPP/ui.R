#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

                
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
       sliderInput("num_colors",
                   label = 'Number of Colors'
                   min = 1,
                   max = 9,
                   value = 7),
       selectInput("select",
                   label = "Select Demographic:",
                   choices = colnames(map_data)[2:9],
                   selected = 1)),
    
    # Show a plot of the generated distribution
    mainPanel(width = 9,
              tabsetPanel(
                tabPanel(title = 'Output Map',
                         plotOutput(outputId = "map")),
                tabPanel(title = 'Data Table',
                         dataTableOutput(outputId = 'table'))))))
              
     
  
