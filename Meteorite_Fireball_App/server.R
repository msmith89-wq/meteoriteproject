
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
  
  
    fireball_bolides_reactive <- reactive({
      
      fireball_bolides_reactive <- fireball_bolides
      
      fireball_bolides_reactive <- fireball_bolides_reactive |> 
        filter(between(Altitude_km, input$Altitude_Filter[1], input$Altitude_Filter[2]))  
        
      #fireball_bolides_reactive <- fireball_bolides_reactive |> 
        #filter(between(`Velocity (km/s)`, input$Velocity_Filter[1], input$Velocity_Filter[2], na.rm = FALSE)) 
        
      fireball_bolides_reactive <- fireball_bolides_reactive |>  
        filter(between(log(Total_Radiated_Energy_J), input$Radiated_Energy_Filter[1], input$Radiated_Energy_Filter[2])) 
        
      fireball_bolides_reactive <- fireball_bolides_reactive |> 
        filter(between(Total_Impact_Energy_kt, input$Impact_Energy_Filter[1], input$Impact_Energy_Filter[2]))
      
      return(fireball_bolides_reactive)
      
    }) 
  
  output$radiatePlot <- renderPlotly({
    
    plot_2 <- fireball_bolides |> 
      ggplot(aes(x = log(Total_Radiated_Energy_J), y = Altitude_km, text = paste(log(Total_Radiated_Energy_J), Altitude_km))) + 
      geom_point() + labs(x = 'Log of Total Radiated Energy', y = 'Altitude (km)')
    
    ggplotly(plot_2, tooltip = 'text')
  })
  
  output$impactPlot <- renderPlotly({
    
    plot <- fireball_bolides |> 
      ggplot(aes(x = log(Total_Impact_Energy_kt), y = Altitude_km, text = paste(log(Total_Impact_Energy_kt), Altitude_km))) + 
      geom_point() + labs(x = 'Log of Total Impact Energy', y = 'Altitude (km)')
    
    ggplotly(plot, tooltip='text')
  })
  
  output$Impact_vs_Radiated_Plot <- renderPlotly({
    
    plot3 <- fireball_bolides |> 
      ggplot(aes(x = log(Total_Radiated_Energy_J), y = log(Total_Impact_Energy_kt), text = paste(log(Total_Radiated_Energy_J), log(Total_Impact_Energy_kt)))) +
      geom_point() + labs(x = 'Log of Total Radiated Energy', y = 'Log of Total Impact Energy')
    
    ggplotly(plot3, tooltip = 'text')
  })
  
  output$Landings_Data <- renderDataTable(
    datatable(
      meteorite_landings_reactive(),
      options = list(pageLength = 5)
    )
  )
  
  output$Landings_Map <- renderPlotly({
    
    g_1 <- list(
      scope = 'world',  # Change to 'world' to show global data
      projection = list(type = 'mercator'),  # Change projection if needed
      showland = TRUE,
      landcolor = toRGB("gray95"),
      subunitcolor = toRGB("gray85"),
      countrycolor = toRGB("gray85"),
      countrywidth = 0.5,
      subunitwidth = 0.5
    )
    
    fig_1 <- plot_geo(meteorite_landings_reactive(), lat = ~reclat, lon = ~reclong) |> 
      add_markers(
        size = ~Mass_Log,  # Use the variable for point size
        sizemax = 50,           # Max size for the largest points
        color = ~Mass_Log, # Optional: color based on the same variable or another one
        colorscale = 'Viridis', # Optional: choose a colorscale
        colorbar = list(title = 'Mass in Grams'), # Optional: Color bar for reference
        hoverinfo = 'text',  # Information to show on hover
        text = ~paste('Size:', Mass_Log, '<br>Lat:', reclat, '<br>Lon:', reclong),
        opacity = 0.5
      )
    #fig <- fig %>% add_markers(
      #text = ~paste(city, state, sep = "<br />"),
      #color = ~cnt, symbol = I("circle"), size = I(8), hoverinfo = "text"
    #)
    #fig <- fig %>% colorbar(title = "Meteorite Landings Count")  # Update colorbar title
    fig_1 <- fig_1 %>% layout(
      title = 'Global Meteorite Landings',  # Updated title
      geo = g_1
    )
    
    fig_1
    
    
  })
  
  output$Landings_Count <- renderText({
    glue("There are {count(meteorite_landings_reactive())} meteorite landings displayed on this map.")
  })
  
  output$Fireball_Bolides_Data <- renderDataTable(
    datatable(
      fireball_bolides_reactive(),
      options = list(pageLength = 5)
    )
  )
  
  output$Fireball_Bolides_Map <- renderPlotly({
    
    g_2 <- list(
      scope = 'world',  # Change to 'world' to show global data
      projection = list(type = 'mercator'),  # Change projection if needed
      showland = TRUE,
      landcolor = toRGB("gray95"),
      subunitcolor = toRGB("gray85"),
      countrycolor = toRGB("gray85"),
      countrywidth = 0.5,
      subunitwidth = 0.5
    )
    
    fig_2 <- plot_geo(fireball_bolides_reactive(), lat = ~Latitude, lon = ~Longitude) |> 
      add_markers(
        size = ~Impact_Log,  # Use the variable for point size
        sizemax = 50,           # Max size for the largest points
        color = ~Impact_Log, # Optional: color based on the same variable or another one
        colorscale = 'Viridis', # Optional: choose a colorscale
        colorbar = list(title = 'Impact Energy in kt'), # Optional: Color bar for reference
        hoverinfo = 'text',  # Information to show on hover
        text = ~paste('Size:', Impact_Log, '<br>Lat:', Latitude, '<br>Lon:', Longitude)
      )
    #fig <- fig %>% add_markers(
    #text = ~paste(city, state, sep = "<br />"),
    #color = ~cnt, symbol = I("circle"), size = I(8), hoverinfo = "text"
    #)
    #fig <- fig %>% colorbar(title = "Meteorite Landings Count")  # Update colorbar title
    fig_2 <- fig_2 %>% layout(
      title = 'Global Fireball and Bolide Reports',  # Updated title
      geo = g_2
    )
    
    fig_2
    
    
  })
  
  output$Bolide_Count <- renderText({
    glue("There are {count(fireball_bolides_reactive())} fireballs or bolides displayed on this map.")
  })
  
  
  output$Year_Histogram <- renderPlot({
    meteorite_landings |> 
      ggplot(aes(x = year)) + geom_histogram() + 
      scale_x_continuous("Year", limits = c(1700, 2024), seq(1700, 2024, by = 50))
  })
  
  
  output$Mass_Histogram <- renderPlot({
    meteorite_landings |> 
      ggplot(aes(x = log(`mass (g)`))) + geom_histogram()
  })
  
  output$Type_Tree_Plot <- renderPlot({
    meteorite_type_count |> 
      slice_max(n = 50, order_by = count) |> 
      ggplot(aes(area=`count`, fill=`recclass`,
                           label=`recclass`, subgroup=`recclass`)) +
                  
      geom_treemap(layout="squarified") +
      geom_treemap_text(place = "centre",size = 12) + 
      labs(title="Sub Grouped Tree Plot using ggplot and treemapify in R") + 
      theme(legend.position="none")
  })
  
  output$Day_vs_Night_Bar_Chart <- renderPlot({
    Day_Night_Tibble |> 
      ggplot(aes(x = Time_of_Day, y = Proportion)) + geom_col() + labs(x = 'Time of Day', y = 'Proportion')
  })
  
  output$Daytime_Nighttime_Radiant_Energy_Bar_Chart <- renderPlot({
    Daytime_Nighttime_Radiant_Energy_Tibble |> 
      ggplot(aes(x = Time_of_Day, y = Proportion)) + geom_col() + labs(x = 'Time of Day', y = 'Proportion')
  })
  
}  
