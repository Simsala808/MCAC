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
      helpText("Default max. file size is 100 MB"),
      
       # h5(helpText("Select Parameters")),
       # checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
       # br(),
      
      tags$hr(),
      
      # Clarifying text for purpose of the prepare data button
      h5(helpText("1: Upload raw data file in CSV format.  (use sampleData.csv for functionality testing)")),
      
      tags$hr(),
      
      h5(helpText("2: Select a threshold for the percentage of data allowed to be classified as outliers at a maximum (default is 6%)")),
      # horizontal line
      tags$hr(),
      
      sliderInput("threshold", "Threshold:",
                  min = 0, max = 1, value = 0.06, step = 0.005),
      
      tags$hr(),
      
      h5(helpText("3: After raw data file is selected and threshold set, click 'Classify Outliers' to generate a reduced Q-Q plot.")),
      
      actionButton("iterate", "Classify Outliers"),
      
      tags$hr(),
       
      h5(helpText("4: After completion of analysis, click 'Export Outliers' to export the classified outliers into a .csv file")),
       
      downloadButton("outliers.csv", "Export Outliers")
      
    
    ),
    
    mainPanel(
      h4("Initial Data Overview"),
      uiOutput("rawData"),
    
      
      h4("Maximum Number of Iterations Allowed:"),
      verbatimTextOutput("thresholdUI"),
      
      h4("Number of Iterations to Achieve Min Error:"),
      verbatimTextOutput("testUI"),
      
      h4("Outlier Clasification"),
      uiOutput("outlierInfo")
      
      
      
    )
    
  )
)
