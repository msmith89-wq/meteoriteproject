
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram

function(input, output, session){ 
  output$radiatePlot <- renderPlot({
    
    fireball_bolides |> 
      ggplot(aes(x = log(Total_Radiated_Energy_J), y = Altitude_km)) + 
      geom_point() 
  })
  
  output$impactPlot <- renderPlot({
    
    fireball_bolides |> 
      ggplot(aes(x = log(Total_Impact_Energy_kt), y = Altitude_km)) + 
      geom_point()
  })
  
}  
