library(shiny)
library(MCAC)
library(dplyr)
library(readr)

options(shiny.maxRequestSize = 100*1024^2)

shinyServer(function(input, output){
  

  
# Reading the Raw data upload and reacting to user parameters
  
  rawData <- reactive({
    check <- input$file
    if(is.null(check)){return()}
    read_csv(input$file$datapath)
  })
  
  
  initialStateVector <- reactive({
    check2 <- input$file
    if(is.null(check2)){return()}
    read_csv(input$file$datapath)
  })
  
    
  
  SV <- reactive({
    pd <- prepareData(initialStateVector()) 
    pd$stateVector
  })
  
  
  #reactive output that contains dataset and displays it in table format
  output$table <- renderTable({
    if(is.null(rawData())){return()}
    head(rawData())
  })
  
  
  # Preparation of initial chi-Square QQ Plot
  QQ1 <- reactive({
    plot1 <- prepareData(initialStateVector()) 
    plot1$chiSqrPlot
  })
  
  output$initialQQPlot <- renderPlot({
    if(is.null(QQ1())){return()}
    plotQQ(QQ1())
  })
    
  
  output$stateVectorTable <- renderTable({
    if(is.null(SV())){return()}
    head(SV())
  })
  
#############
# Threshold #
#############   

  maxIter <- reactive({
    as.integer(nrow(SV()) * input$threshold)
  })
  
############################  
# Classify Outliers Button #
############################ 
  

  
  # QQ2 <- eventReactive(input$iterate, {
  #   maxiter <- as.integer(nrow(SV()) * input$threshold)
  #   
  # })
  
  
###############
#  UI OUTPUTS #
###############
  
  output$rawData <- renderUI({
    if(is.null(rawData()))
      paste("Awaiting Data Input")
    else
      tabsetPanel(tabPanel("RawData File", tableOutput("table")), tabPanel("Initial Chi-Sqrare QQ Plot", plotOutput("initialQQPlot")), tabPanel("Initial State Vector", tableOutput("stateVectorTable")))
  })
  
  

  output$thresholdUI <- renderText({
    if(is.null(rawData()))
         paste("Awaiting Data Input")
         else
         paste("Current threshold is", as.character(maxIter()))

  })

  
  

  
}
)



