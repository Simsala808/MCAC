library(shiny)

shinyUI(fluidPage(
  
  titlePanel(title = "Multivariate Chi-Square Anomaly Classification (MCAC)"),
  sidebarLayout(position = "right",
    sidebarPanel(h3("Sidebar Panel: We will want to include user input here."),
                 h4("widget4"),
                 h5("widget5")),
    mainPanel(h4("Main Panel: Chi-Square plots should be displayed here."), 
              h5("this is the output 5")
              
    )
    
  )
))