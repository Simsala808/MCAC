library(shiny)
library(MCAC)

options(shiny.maxRequestSize = 20*1024^2)

shinyServer(function(input, output){
  
  
  #Reading the Raw data upload and reacting to user parameters
  
  data <- reactive({
    file1 <- input$file
    if(is.null(file1)){return()}
    read.table(file = file1$datapath, sep = ",", header = input$header)
  })
  
  
  
  #reactive output that contains dataset and displays it in table format
  output$table <- renderTable({
    if(is.null(data())){return()}
    head(data())
  })
  
  
  
  # rv <- reactiveValues()
  # 
  # rv$initialPlot <- prepareData(data)
  
  
  initialPlot <- reactive({
    #if(is.null(file1)){return()}
     prepareData(data())
  })
  
   
  stateVector <- reactive ({ 
    initialPlot()[3] })
  

  # output$initialQQ <- renderTable({
    # if(is.null(data())){return()}
  # })
  

  
  output$stateVector <- renderTable({
    if(is.null(data())){return()}
    stateVector()
  })

  
  output$tb <- renderUI({
    if(is.null(data()))
      h5("Awaiting Data Input")
    else
      tabsetPanel(tabPanel("Data Overview", tableOutput("table")))
  })
  
  
  
  output$initial <- renderUI({
    if(is.null(data()))
      h5("Awaiting Data Input")
    else
      tabsetPanel(tabPanel("Initial State Vector", tableOutput("stateVector")))
  })
  

  
}
)
