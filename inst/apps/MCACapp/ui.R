library(shiny)
library(MCAC)

# define ui for app
ui <- fluidPage(
  
  # app title
  titlePanel("Multivariate Chi-Square Anomaly Classification (MCAC)"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout( #position = "left",
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Input: upload a csv
      fileInput("file", "Upload your raw .csv data file"),
      
      # clarifying text
      helpText("Default max. file size is 20 MB"),
      
      
      h5(helpText("Select Parameters")),
      checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
      br(),
      
      # Clarifying text for purpose of the prepare data button
      h5(helpText("1. After raw data file is selected, click 'Update Data' to generate the following: Tabulated statev ector, initial chi-Square Q-Q plot, initial error.")),
      actionButton("prepare", "Prepare Data")
    
    ),
    mainPanel(
      uiOutput("tb"),
      
      # Output: Header + State vector Tabset ----
      h4("Initial Chi-Sqr Q-Q Plot"),
      uiOutput("prepare")
              
    )
    
  )
)
