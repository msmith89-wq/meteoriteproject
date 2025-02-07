
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram

function(input, output, session){ 
  output$radiatePlot <- renderPlotly({
    
    plot_2 <- fireball_bolides |> 
      ggplot(aes(x = log(Total_Radiated_Energy_J), y = Altitude_km, text = paste(log(Total_Radiated_Energy_J), Altitude_km))) + 
      geom_point() 
    
    ggplotly(plot_2, tooltip = 'text')
  })
  
  output$impactPlot <- renderPlotly({
    
    plot <- fireball_bolides |> 
      ggplot(aes(x = log(Total_Impact_Energy_kt), y = Altitude_km, text = paste(log(Total_Impact_Energy_kt), Altitude_km))) + 
      geom_point()
    
    ggplotly(plot, tooltip='text')
  })
  
  output$Landings_Data <- renderDataTable(
    datatable(
      meteorite_landings, 
      options = list(pageLength = 5)
    )
  )
  
}  
