
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  tabsetPanel(
    tabPanel("Logarithms of Radiant Energy and Impact Energy vs Altitude",
             
             # Application title
             #titlePanel("Meteorites Data"),
             
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
             sidebarLayout(
               sidebarPanel(
                 p("Correlation of Altitude vs Log of Radiant Energy: -0.2432041"),
                 p("Confidence Interval of Altitude vs Log of Radiant Energy: (-0.455232089  -0.005073145)"),
                 p("p-value of correlation of Altitude vs Log of Radiant Energy: 0.04567"),
                 br(),
                 p("Correlation of Altitude vs Log of Impact Energy: -0.2424925"),
                 p("Confidence Interval of Altitude vs Log of Impact Energy: (-0.454632431  -0.004317007)"),
                 p("p-value of correlation of Altitude vs Log of Impact Energy: 0.04633")
               ),
               
               mainPanel(
                 fluidRow(
                   column(width = 6,
                          plotlyOutput("radiatePlot", height=plot_heights)
                   ),
                   column(width = 6,
                          plotlyOutput("impactPlot", height=plot_heights)
                   )
                 ),
                 fluidRow(
                   p("According to the data above, there appears to be a negative correlation between Altitude and the logarithm of the Total Radiated Energy, perhaps this has to do with the atmosphere being less dense at higher altitudes, therefore causing less friction between the atmosphere and meteorites and less radiated energy."),
                   p("Also, the results of the scatterplot of Altitudes of Fireball/Bolides vs. the logarithm of the Calculated Total Impact Energy above seem to be identical to the results of the scatterplot of Altitudes of Fireball/Bolides vs the logarithm of Total Radiated Energy of Fireball/Bolides. This observation makes sense since radiant energy and impact energy should be directly proportional."),
                   p("Also, as you can see the p-values show there is definitely statistical significance in the correlations of the logarithms of radiant energy and impact energy to the altitude of the fireball/bolides.")
                 )
               )
             )
    ),
    
    
    tabPanel("Log of Impact Energy vs. Log of Radiated Energy of Bolides",
      sidebarLayout(
        sidebarPanel(
          p("Correlation of Log of Impact Energy vs Log of Radiant Energy: 0.999936"),
          p("Confidence Interval of Altitude vs Log of Radiant Energy: (0.9999030  0.9999577)"),
          p("p-value of correlation of Altitude vs Log of Radiant Energy: < 2.2e-16")
       ),
        
        mainPanel(
          fluidRow(
            column(width = 12,
                   plotlyOutput("Impact_vs_Radiated_Plot", height=plot_heights)
            )
          ),
          
          fluidRow(
            p("According to the scatterplot of the logarithm of Total Impact Energy vs the logarithm of Total Radiated Energy, there appears to be a nearly perfect one to one correlation between the two variables, which of course makes logical sense since the more kinetic energy the meteorite has, the higher the both types of bolide energy would be."),
            p("Also looking at both the p-value and the confidence interval, the result of the near exactly 1 correlation is statistically significant by quite a bit.")
          )
        )
      )
    ),
    
    tabPanel(
      "Meteorite Landings Dataset",
      fluidRow(
        column(width = 3,
               sliderInput("Year_Filter", "Select a Year Range:", min = min(meteorite_landings$year, na.rm = TRUE), max = max(meteorite_landings$year, na.rm = TRUE), value = c(2000, 2004), sep = ''),
               selectInput("Class_Filter", "Select a Class:", choices = c('All', unique(meteorite_landings$recclass))),
               selectInput("Fall_Filter", "Select Fell or Found:", choices = c('All', unique(meteorite_landings$fall)))
        ),
        column(width = 9, 
               tabsetPanel(
                 tabPanel("Table",
                          dataTableOutput("Landings_Data"),
                          fluidRow(
                            p("Some information about the variables in this dataset:"),
                            p("Nametype refers to whether the meteorite is valid or relict. Valid means the meteorite is still considered a meteorite and relict means the object is no longer considered a meteorite due to weathering from being on Earth for so long."),
                            p("Fall refers to whether the meteorite fell to Earth during the year listed or was found during the year listed and actually fell some time before."),
                            p("Recclass refers to the type of meteorite listed."),
                            p("Mass_Log is the logarithm of the mass with base 10.")
                          )
                          
                 ),
                 tabPanel("Map",
                          plotlyOutput("Landings_Map"),
                          textOutput("Landings_Count")
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
               sliderInput("Radiated_Energy_Filter", "Select a Radiant Energy Range:", min = min(log(fireball_bolides$Total_Radiated_Energy_J), na.rm = TRUE), max = max(log(fireball_bolides$Total_Radiated_Energy_J), na.rm = TRUE), value = c(log(2.20e+10), log(2.00e+13)
               )),
               sliderInput("Impact_Energy_Filter", "Select an Impact Energy Range:", min = min(fireball_bolides$Total_Impact_Energy_kt, na.rm = TRUE), max = max(fireball_bolides$Total_Impact_Energy_kt, na.rm = TRUE), value = c(0.073, 33)
               )),
        column(width = 9, 
               tabsetPanel(
                 tabPanel("Table",
                          dataTableOutput("Fireball_Bolides_Data")
                          
                 ),
                 tabPanel("Map",
                          plotlyOutput("Fireball_Bolides_Map"),
                          textOutput("Bolide_Count")
                 )
               )
               
        )
      )
    ),
    
    tabPanel(
      'Various EDA Histograms and Bar Charts',
      fluidRow(
        tabsetPanel(
          tabPanel("Histogram of Meteorite Landings over Time",
                   column(width = 12,
                          plotOutput('Year_Histogram', height = plot_heights)
                   ),
                   fluidRow(
                     p(HTML("According to the histogram of meteorite landings over time, the distribution seems to be extremely left skewed, <br> meaning there has been very few meteorite discoveries until around the 1970s. <br>Maybe this can be explained by the advancement of knowledge and technology of how to find meteorite landings or to know what to look for."), style = "text-align: center;")
                   )
                   
          ),
          tabPanel("Distribution of Log of Meteorite Mass of Meteorite Landings",
                   column(width = 12,
                          plotOutput('Mass_Histogram', height = plot_heights)
                   ),
                   fluidRow(
                     p(HTML("The distribution of meteorite mass was extremely skewed, so the distribution of the logarithm of meteorite mass was taken instead. <br>According to this histogram, the distribution seems fairly close to normal."), style = "text-align: center;")
                   )
          ),
          tabPanel("Tree Plot of Distribution Among Meteorite Types",
                   column(width = 12,
                          plotOutput('Type_Tree_Plot', height = plot_heights)
                   ),
                   fluidRow(
                     p(HTML("According to the tree map above, L6, H5, H6, and L5 meteorites are the most common types of meteorites found on Earth. <br>It appears that both low iron and high iron content meteorites are common, but all these types have undergone a moderate or high level of metamorphosis since their formation."), style = "text-align: center;")
                   )
          ),
          tabPanel("Day vs Night Frequency of Fireball/Bolides",
                   column(width = 12,
                          plotOutput('Day_vs_Night_Bar_Chart', height = plot_heights)
                   ),
                   fluidRow(
                     p(HTML("According to the bar chart above, the proportion of fireball/bolides that happen during the day is around 0.31, <br>whereas the proportion of fireball/bolides that happen at night is close to 0.69"), style = "text-align: center;"),
                     p(HTML("Also a chi-squared test was performed on the results above, and the p-value generated from this test ended up being 2.896e-4, showing that the results above are indeed statistically significant, and supports the alternative hypothesis that fireball/bolides happen more during the night than during the day."), style = "text-align: center;"),
                     p(HTML("This does not, however, prove that this is because of the Sun's gravitational pull. Rather another possible reason for the increased frequency of fireball/bolides at night could be these events being more easily observed at night with no sunlight, but this depends on how exactly the fireball/bolides data was recorded."), style = "text-align: center;")
                   )
          ),
          tabPanel("Day vs Night Proportions of Radiated Energies of Bolides",
                   column(width = 12,
                          plotOutput('Daytime_Nighttime_Radiant_Energy_Bar_Chart', height = plot_heights)
                   ),
                   fluidRow(
                     p(HTML("Lets investigate the possibility of the increased frequency of bolides being at night because of the fact that they would more easily be observed at night because of no sunlight."), style = "text-align: center;"),
                     p(HTML("All the radiated energies of the daytime bolides were summed and all the radiated energies of the nighttime bolides were summed, and from these daytime and nighttime proportions were calculated and graphed in the bar chart above."), style = "text-align: center;"),
                     p(HTML("According to the bar chart above, the proportion of the radiated energies of the daytime bolides greatly outweighs the proportion of the nighttime bolides. This shows that even though the daytime bolides happen when sunlight is overwhelming, the average daytime bolide should have enough energy to be recorded or spotted, so this result potentially or more likely rules out the possibility that nighttime bolides are more frequent because they are spotted or recorded easier."), style = "text-align: center;"),
                     p(HTML("This still does not 100% prove that the Sun's gravitational pull is the reason for bolides happening less during the day, these results just mean that it is more possible."), style = "text-align: center;")
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





