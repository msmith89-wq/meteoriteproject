
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  tabsetPanel(
    tabPanel("Radiant Energy and Impact Energy vs Altitude",
             
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
                        plotlyOutput("radiatePlot", height=plot_heights)
                 ),
                 column(width = 6,
                        plotlyOutput("impactPlot", height=plot_heights)
                 )
               )
             )
    ),
    
    tabPanel(
      "Meteorite Landings Dataset",
      fluidRow(
        column(width = 3,
               sliderInput("Year_Filter", "Select a Year Range:", min = min(meteorite_landings$year, na.rm = TRUE), max = max(meteorite_landings$year, na.rm = TRUE), value = c(2000, 2020)),
               selectInput("Class_Filter", "Select a Class:", choices = c('All', unique(meteorite_landings$recclass))),
               selectInput("Fall_Filter", "Select Fell or Found:", choices = c('All', unique(meteorite_landings$fall)))
        ),
        column(width = 9, 
               tabsetPanel(
                 tabPanel("Table",
                          dataTableOutput("Landings_Data")
                          
                 ),
                 tabPanel("Map",
                          plotlyOutput("Landings_Map")
                 )
               )
               
        )
      )
    ),
    
    tabPanel(
      "Fireball and Bolides Dataset",
      fluidRow(
        column(width = 3,
               sliderInput("Altitude_Filter", "Select an Altitude Range:", min = min(fireball_bolides$Altitude_km, na.rm = TRUE), max = max(fireball_bolides$Altitude_km, na.rm = TRUE), value = c(19, 59)),
               #sliderInput("Velocity_Filter", "Select a Velocity Range:", min = min(fireball_bolides$`Velocity (km/s)`, na.rm = FALSE), max = max(fireball_bolides$`Velocity (km/s)`, na.rm = FALSE), value = c(16, 19)),
               sliderInput("Radiated_Energy_Filter", "Select an Energy Range:", min = min(fireball_bolides$Total_Radiated_Energy_J, na.rm = TRUE), max = max(fireball_bolides$Total_Radiated_Energy_J, na.rm = TRUE), value = c(2.20e+10, 2.00e+13
               )),
               sliderInput("Impact_Energy_Filter", "Select an Energy Range:", min = min(fireball_bolides$Total_Impact_Energy_kt, na.rm = TRUE), max = max(fireball_bolides$Total_Impact_Energy_kt, na.rm = TRUE), value = c(0.073, 33)
               )),
        column(width = 9, 
               tabsetPanel(
                 tabPanel("Table",
                          dataTableOutput("Fireball_Bolides_Data")
                          
                 ),
                 tabPanel("Map",
                          plotlyOutput("Fireball_Bolides_Map")
                 )
               )
               
        )
      )
    )
    
  )
)



#fluidRow(
#column(width = 12,
#dataTableOutput("selectedData")
#)





