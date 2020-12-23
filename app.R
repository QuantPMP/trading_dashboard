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

##runApp("Users/kacperszostakow/Google Drive/02_Education/01_Humboldt University/PMP/Shiny app - trading dashboard")

# Load packages ----

library(shiny)
library(quantmod)

# Source helpers ----
source("helpers.R")


# Define UI for the app ----
ui <- navbarPage(
  title = 'PMP Quant - Portfolio Performance',
  tabPanel('Trade History', DT::dataTableOutput('ex1')),
  tabPanel('Stock Chart', titlePanel("stockVis"),
           sidebarLayout(
             sidebarPanel(
               helpText("Select a stock to examine.
                        
                        Information will be collected from Yahoo finance."),
               textInput("symb", "Symbol", "SPY"),
               
               dateRangeInput("dates",
                              "Date range",
                              start = "2013-01-01",
                              end = as.character(Sys.Date())),
               
               br(),
               br(),
               
               checkboxInput("log", "Plot y axis on log scale",
                             value = FALSE),
               
               checkboxInput("adjust",
                             "Adjust prices for inflation", value = FALSE)
               ),
             
             mainPanel(plotOutput("plot"))
             ))
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # display 10 rows initially
  output$ex1 <- DT::renderDataTable(
    DT::datatable(read.csv("tradeLog.csv"), options = list(pageLength = 25))
  )
  
  # Plot the stock performance
  
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  
  output$plot <- renderPlot({
    
    chartSeries(finalInput(), theme = chartTheme("white"),
                type = "line", log.scale = input$log, TA = NULL)
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
