library(shiny)
library(MCAC)
library(dplyr)
library(readr)

options(shiny.maxRequestSize = 100*1024^2)

shinyServer(function(input, output){
  
  
  #Reading the Raw data upload and reacting to user parameters
  
  rawData <- reactive({
    check <- input$file
    if(is.null(check)){return()}
    read_csv(input$file$datapath)
             
             # , col_names = input$header)  
  })
  
  
  initialStateVector <- reactive({
    check2 <- input$file
    if(is.null(check2)){return()}
    read_csv(input$file$datapath)
             
             
             # , col_names = input$header) 
    
  })
  
    
  
  SV <- reactive({
    pd <- prepareData(initialStateVector()) 
    pd[['stateVector']]
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
    
  
  
  
  #output$stateVectorTable <- renderTable({
   # if(is.null(initialStateVector())){return()}
    #head(initialStateVector())
  #})
    
  SV <- reactive({
    pd <- prepareData(initialStateVector()) 
    pd[['stateVector']]
  })
  
  output$stateVectorTable <- renderTable({
    if(is.null(SV())){return()}
    head(SV())
  })
  
############################  
# Classify Outliers Button #
############################ 
  
  Threshold <- reactive({
    as.integer(nrow(SV()) * input$threshold)
  })
  
  output$maxiter <- renderText({
    paste("Current threshold is", as.character(Threshold()))
  })
  
  # QQ2 <- eventReactive(input$iterate, {
  #   maxiter <- as.integer(nrow(SV()) * input$threshold)
  #   
  # })
  
  
###############
#  UI OUTPUTS #
###############
  
  output$rawData <- renderUI({
    if(is.null(rawData()))
      h5("Awaiting Data Input")
    else
      tabsetPanel(tabPanel("Data Overview", tableOutput("table")))
  })
  
  
  
  output$stateVector <- renderUI({
    if(is.null(initialStateVector()))
      h5("Awaiting Data Input")
   else
      tabsetPanel(tabPanel("Initial Chi-Sqrare QQ Plot", plotOutput("initialQQPlot")), tabPanel("Initial State Vector", tableOutput("stateVectorTable")))
  })
  
  output$outlierInfo <- renderUI({
    if(is.null(initialStateVector()))
      h5("Awaiting Classification Command")
    else
      tabsetPanel(tabPanel("Threshold", verbatimTextOutput("maxiter")))
  })
  
  

  
}
)



# rv <- reactiveValues()
# 
# rv$initialPlot <- prepareData(data)


#InitialData <- read.csv(input$file$datapath, 
#header = input$header,
#sep = ",")

#initialPlot <- reactive({
#if(is.null(file1)){return()}
#prepareData(data())
#})

# stateVector <- reactive ({ 
# initialPlot()[3] })

#output$stateVector <- renderTable({

#req(input$file)

#SV <- read.csv(input$file$datapath, 
#                        header = input$header,
#                       sep = ",")

#SV <- prepareData(SV)

#SV <- sv$stateVector

#return(SV)


#})

