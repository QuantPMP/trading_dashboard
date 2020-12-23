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
ui <- navbarPage(
  title = 'PMP Quant - Portfolio Performance',
  tabPanel('Trade History',     DT::dataTableOutput('ex1')),
  tabPanel('Length menu',        DT::dataTableOutput('ex2')),
  tabPanel('No pagination',      DT::dataTableOutput('ex3')),
  tabPanel('No filtering',       DT::dataTableOutput('ex4')),
  tabPanel('Function callback',  DT::dataTableOutput('ex5'))
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # display 10 rows initially
  output$ex1 <- DT::renderDataTable(
    DT::datatable(read.csv("tradeLog.csv"), options = list(pageLength = 25))
  )
  
  # -1 means no pagination; the 2nd element contains menu labels
  output$ex2 <- DT::renderDataTable(
    DT::datatable(
      iris, options = list(
        lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
        pageLength = 15
      )
    )
  )
  
  # you can also use paging = FALSE to disable pagination
  output$ex3 <- DT::renderDataTable(
    DT::datatable(iris, options = list(paging = FALSE))
  )
  
  # turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(iris, options = list(searching = FALSE))
  )
  
  # write literal JS code in JS()
  output$ex5 <- DT::renderDataTable(DT::datatable(
    iris,
    options = list(rowCallback = DT::JS(
      'function(row, data) {
      // Bold cells for those >= 5 in the first column
      if (parseFloat(data[1]) >= 5.0)
      $("td:eq(1)", row).css("font-weight", "bold");
}'
    ))
    ))
  }

# Create Shiny app ----
shinyApp(ui = ui, server = server)
