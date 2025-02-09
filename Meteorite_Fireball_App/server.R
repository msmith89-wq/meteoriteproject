
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram

function(input, output, session){ 
  meteorite_landings_reactive <- reactive({
    
    meteorite_landings_reactive <- meteorite_landings
    
    if (input$Class_Filter != "All"){
    meteorite_landings_reactive <- meteorite_landings_reactive |> 
      filter(recclass == input$Class_Filter) 
    }
    
    
      meteorite_landings_reactive <- meteorite_landings_reactive |> 
        filter(between(year, input$Year_Filter[1], input$Year_Filter[2])) 
    
      
    if (input$Fall_Filter != "All"){
      meteorite_landings_reactive <- meteorite_landings_reactive |> 
        filter(fall == input$Fall_Filter) 
    }
      
      return(meteorite_landings_reactive)
    
  })
  
  
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
      meteorite_landings_reactive(),
      options = list(pageLength = 5)
    )
  )
  
  output$Landings_Map <- renderPlotly({
    
    g <- list(
      scope = 'world',  # Change to 'world' to show global data
      projection = list(type = 'mercator'),  # Change projection if needed
      showland = TRUE,
      landcolor = toRGB("gray95"),
      subunitcolor = toRGB("gray85"),
      countrycolor = toRGB("gray85"),
      countrywidth = 0.5,
      subunitwidth = 0.5
    )
    
    fig <- plot_geo(meteorite_landings_reactive(), lat = ~reclat, lon = ~reclong)
    #fig <- fig %>% add_markers(
      #text = ~paste(city, state, sep = "<br />"),
      #color = ~cnt, symbol = I("circle"), size = I(8), hoverinfo = "text"
    #)
    #fig <- fig %>% colorbar(title = "Meteorite Landings Count")  # Update colorbar title
    fig <- fig %>% layout(
      title = 'Global Meteorite Landings',  # Updated title
      geo = g
    )
    
    fig
    
    
  })
  
}  
