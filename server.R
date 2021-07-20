##########################
#  App Server
##########################


function(input, output) {
  
  dataset <- reactive({
    dataset <- green_popu %>% filter(time == input$year) 
    #dataset <- green_popu %>% filter(time == '2019') 
  })
  

  green_table <- reactive({
    data <- green_popu %>% filter(time == input$year) %>% mutate(population = population * 1000000) %>% mutate(`Tonnes of greenhouse emissions per area` = gas/area)
    
    green_table <- data %>% select(Country = countries, KM2 = area, Emissions = gas, Population = population, `Tonnes of greenhouse emissions per area`) %>%
      mutate(`Tonnes of greenhouse per millions people` = Emissions/Population*1000000) %>% rename(`Tonnes of emissions in terms of CO2` = Emissions)
  })
  
  country_level <- reactive({
    
    aggregate <- greenhouse %>% filter(airpol != 'GHG') %>% inner_join(green_popu %>% select(geo, countries) %>% distinct(), by = 'geo') %>% select(-geo)
    
    aggregate <- aggregate %>% filter(countries == input$country) %>% select(-countries) 
    aggregate$airpol <- as.character(aggregate$airpol)
    
    return(aggregate)
  })
  
  output$barplot_comp <- renderPlotly({ 
    
    dat_long <- country_level() %>%  gather('Type', 'Emissions',-airpol, -time) %>% rename(`Type of emission` = airpol)
    
    if(nrow(dat_long) > 0){
      
      bar_comparison <- ggplot() + 
        geom_bar(data=dat_long, aes(x=time, y=Emissions, fill=`Type of emission`), stat='identity', size= 1.3, width=.5) +
        theme(panel.spacing.y=unit(0.01, "lines"))+xlab("Date") + ylab("Total emissions (in CO2 mil of tonnes)") 
    
    } else {bar_comparison <- ggplot()}
    
    bar_comparison
  })
    
    
    
  output$bargasplot <- renderPlotly({
    
    # Basic barplot
    p<-ggplot(data=dataset(), aes(x=reorder(countries, gas_per_pop), y=gas_per_pop)) +
      geom_bar(stat="identity", width=0.7, fill="steelblue")+
      theme_minimal() +
      
      labs(
        y = "Greenhouse gas emissions per population",
        x = "Country"
      ) 
    
    ggplotly(p + coord_flip())
    
  })
  
  output$bargasareaplot <- renderPlotly({
    
    # Basic barplot
    p<-ggplot(data=dataset(), aes(x=reorder(countries, gas_per_area), y=gas_per_area)) +
      geom_bar(stat="identity", width=0.7, fill="steelblue")+
      theme_minimal() +
      
      labs(
        y = "Greenhouse gas emissions per area",
        x = "Country"
      ) 
    
    ggplotly(p + coord_flip())
    
  })
  
  output$plot <- renderPlotly({
    
    # Plots
    ggp <- ggplot(dataset(), mapping = aes(x=population, y=gas)) +
      geom_point(aes(colour=countries, size = gas/population), alpha=0.6) + 
      # geom_text_repel(
      #   aes(label = countries),
      #   size = 4,
      #   min.segment.length = 0,
      #   seed = 42,
      #   box.padding = 0.4,
      #   arrow = arrow(length = unit(0.010, "npc")),
      #   nudge_x = .15,
      #   nudge_y = .5,
      #   color = "grey30") +
      
      labs(
        title = "Greenhouse Gas Emissions and Population",
        x = "Population (in Millions)",
        y = "Total Greenhouse Emissions (Mil. tonnes)"
      ) +  
      theme(
        legend.position = "none",
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 20,
          color = "#2a475e"
        ),
       
        plot.title.position = "plot",
        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 10, color = "black"),
        axis.title = element_text(size = 12),
        axis.line = element_line(colour = "grey50"),
        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white")
      )
    
    ggplotly(ggp)
    
  })
  
  output$plotarea <- renderPlotly({
    
    # Plots
    ggp <- ggplot(dataset(), mapping = aes(x=area, y=gas)) +
      geom_point(aes(colour=countries, size = gas/area), alpha=0.6) + 
      # geom_text_repel(
      #   aes(label = countries),
      #   size = 4,
      #   min.segment.length = 0,
      #   seed = 42,
      #   box.padding = 0.4,
      #   arrow = arrow(length = unit(0.010, "npc")),
      #   nudge_x = .15,
      #   nudge_y = .5,
      #   color = "grey30") +
      
    labs(
      title = "Greenhouse Gas Emissions per Area",
      x = "Area (KM2)",
      y = "Total Greenhouse Emissions (Mil. of tonnes)"
    ) +  
      theme(
        legend.position = "none",
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 20,
          color = "#2a475e"
        ),

        plot.title.position = "plot",
        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 10, color = "black"),
        axis.title = element_text(size = 12),
        axis.line = element_line(colour = "grey50"),
        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white")
      )
    
    ggplotly(ggp)
    
  })
  
  output$comparison_table <- DT::renderDataTable({
    
    green_table()
  })
  
  output$country_table <- DT::renderDataTable({
    
    country_level() %>% rename(`Type of emission` = airpol) %>% rename(Year = time)
    
  })
}