library(shiny)
shinyUI(fluidPage(
  titlePanel(title = "Multivariate Chi-Square Anomaly Classification (MCAC)"),
  sidebarLayout( #position = "left",
    sidebarPanel(
      fileInput("file", "Upload Your File Here"),
      helpText("Default max. file size is 20 MB"),
      tags$hr(),
      h5(helpText("Select Parameters")),
      checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
      br()
    
    ),
    mainPanel(
      uiOutput("tb")
              
    )
    
  )
))
