## ---------------------------
##
## Script name: app.R
##
## Purpose of script: Visualize trading activity for the Quant group
##
## Author: Kacper Szostakow
##
## Date Created: 22.12.2020
##
## Copyright (c) Kacper Szostakow, 2020
## Email: kacper.szostakow@gmail.com
##
## ---------------------------
##
## Notes: This is a Shiny App Dashboard
##
## ---------------------------



##library(shiny) --- delete if not needed
##runApp("Users/kacperszostakow/Google Drive/02_Education/01_Humboldt University/PMP/Shiny app - trading dashboard")

# Define UI for the app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("PMP Quant - Portfolio Performance"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
