
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("Meteorites Data"),
  
  # Sidebar with a slider input for number of bins
  #sidebarLayout(
  #sidebarPanel(
  #selectInput("histvar",
  #"Select variable for histogram:",
  #choices = numeric_vars),
  
  #sliderInput("bins",
  #"Number of bins:",
  # min = 1,
  # max = 50,
  # value = 30),
  
  #selectInput("island", label = "Select Island:",
  #choices = c("All", penguins |> distinct(island) |> pull(island) |> sort())),
  #width = 3
  
  # Show a plot of the generated distribution
  mainPanel(
    fluidRow(
      column(width = 6,
             plotOutput("radiatePlot", height=plot_heights)
      ),
      column(width = 6,
             plotOutput("impactPlot", height=plot_heights)
      )
    )
    #fluidRow(
    #column(width = 12,
    #dataTableOutput("selectedData")
    #)
  )
)
  


