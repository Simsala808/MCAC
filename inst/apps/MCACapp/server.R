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
# chiSqrPlot, blocks, stateVector, outliers, error, timeData
  Iter <- eventReactive(input$iterate, {
    
    if(is.null(maxIter())){return()}
    
    N <- maxIter()
    
    initialInfo <- prepareData(initialStateVector())
    chiSqrPlot <- initialInfo$chiSqrPlot
    blocks <- initialInfo$blocks
    stateVector <- initialInfo$stateVector
    outliers <- initialInfo$outliers
    error <- initialInfo$error
    timeData <- initialInfo$timeData

    for (i in 1 :N) {
    Obj <- removeAnomaly(chiSqrPlot, blocks, stateVector, outliers, error, timeData) 
    chiSqrPlot <- Obj$chiSqrPlot
    blocks <- Obj$blocks
    stateVector <- Obj$stateVector
    outliers <- Obj$outliers
    error <- Obj$error
    timeData <- Obj$timeData
    i = i + 1
   
    }
    
   (which.min(error$Error) - 1)
   
   })
  
  
  output$reducedQQPlot <- renderPlot({
    if(is.null(Iter())){return()}
    
    N <- Iter()
    
    initialInfo <- prepareData(initialStateVector())
    chiSqrPlot <- initialInfo$chiSqrPlot
    blocks <- initialInfo$blocks
    stateVector <- initialInfo$stateVector
    outliers <- initialInfo$outliers
    error <- initialInfo$error
    timeData <- initialInfo$timeData
    
    for (i in 1 : N) {
      Obj <- removeAnomaly(chiSqrPlot, blocks, stateVector, outliers, error, timeData) 
      chiSqrPlot <- Obj$chiSqrPlot
      blocks <- Obj$blocks
      stateVector <- Obj$stateVector
      outliers <- Obj$outliers
      error <- Obj$error
      timeData <- Obj$timeData
      i = i + 1
      
    }
    
    reducedPlot <- chiSqrPlot
    
    plotQQ(chiSqrPlot)
    
  })
  
  
  output$classifiedOutliers <- renderTable({
    if(is.null(Iter())){return()}
    
    N <- Iter()
    
    initialInfo <- prepareData(initialStateVector())
    chiSqrPlot <- initialInfo$chiSqrPlot
    blocks <- initialInfo$blocks
    stateVector <- initialInfo$stateVector
    outliers <- initialInfo$outliers
    error <- initialInfo$error
    timeData <- initialInfo$timeData
    
    for (i in 1 : N) {
      Obj <- removeAnomaly(chiSqrPlot, blocks, stateVector, outliers, error, timeData) 
      chiSqrPlot <- Obj$chiSqrPlot
      blocks <- Obj$blocks
      stateVector <- Obj$stateVector
      outliers <- Obj$outliers
      error <- Obj$error
      timeData <- Obj$timeData
      i = i + 1
      
    }
    
    outliers <<- outliers
    
    outliers
    
  })
  
  
  
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
         paste(as.character(maxIter()))

  })
  
  output$testUI <- renderText({
    if(is.null(rawData()))
      paste("Awaiting Data Input")
    else
      paste(as.character(Iter()))
    
  })

  output$outlierInfo <- renderUI({
    if(is.null(Iter()))
      paste("Awaiting Classification Command")
    else
      tabsetPanel(tabPanel("Reduced Chi-Sqrare QQ Plot", plotOutput("reducedQQPlot")), tabPanel("Outliers", tableOutput("classifiedOutliers")) )
  })
  
  output$outliers.csv <- downloadHandler(
    filename = function() {
      paste(outliers, ".csv")
    },
    content = function(file) {
      write.csv(outliers, file, row.names = FALSE)
    }
  )

  
}
)



