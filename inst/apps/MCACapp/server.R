library(shiny)

options(shiny.maxRequestSize = 20*1024^2)

shinyServer(function(input, output){

  
#Reading the Raw data upload  
  data <- reactive({
    file1 <- input$file
    if(is.null(file1)){return()}
    read.table(file = file1$datapath, sep = ",", header = input$header)
  })
  
  
  
  output$filedf <- renderTable({
    if(is.null(data())){return()}
    input$file
    
  })
  
  output$sum <- renderTable({
    if(is.null(data())){return()}
    summary(data())
    
  })
  
  #reactive output that contains dataset and displays it in table format

  output$table <- renderTable({
    if(is.null(data())){return()}
    head(data())
  })
  
 
  ################################
  # PREPARE DATA REACTIVE BUTTON #
  ################################
  
  prepareData <- eventReactive(input$prepare, {
    rawData <- input$file
    if(is.null(rawData)){return()}
    read.table(file = rawData$datapath, sep = ",", header = input$header)
  })
      
  output$stateVector <- renderTable({
    if(is.null(prepareData())){return()}
    head(prepareData())
  })
  

  
  output$tb <- renderUI({
    if(is.null(data()))
      h5("Awaiting Data Input")
    else
      tabsetPanel(tabPanel("About Data", tableOutput("filedf")), tabPanel("Data", tableOutput("table")))
  })
  
  
  output$prepareData <- renderUI({
    if(is.null(data()))
      h5("Awaiting Command")
    else
      tabsetPanel(tabPanel("State Vector", tableOutput("stateVector")))
  })
  
  
  }
)
