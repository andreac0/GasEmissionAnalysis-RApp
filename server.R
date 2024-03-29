##########################
#  App Server
##########################


function(input, output) {
  
  dataset <- reactive({
    dataset <- green_popu %>% filter(time == input$year) 
    #dataset <- green_popu %>% filter(time == '2019') 
  })
  

  green_table <- reactive({
    data <- green_popu %>% filter(time == input$year) %>% 
      mutate(population = population * 1000000) %>% 
      mutate(`Tonnes of greenhouse emissions per KM2` = gas/area)
    
    green_table <- data %>% select(Country = countries, KM2 = area, `Population Density` = density_pop, Emissions = gas, Population = population, `Tonnes of greenhouse emissions per KM2`) %>%
      mutate(`Tonnes of greenhouse per million people` = Emissions/Population*1000000)%>%
      rename(`Tonnes of emissions in terms of CO2` = Emissions) 
  })
  
  country_level <- reactive({
    
    aggregate <- greenhouse %>% filter(airpol != 'GHG') %>% inner_join(green_popu %>% select(geo, countries) %>% distinct(), by = 'geo') %>% select(-geo)
    
    aggregate <- aggregate %>% filter(countries == input$country) %>% select(-countries) 
    aggregate$airpol <- as.character(aggregate$airpol)
    
    aggregate$time <- as.numeric(aggregate$time)
    aggregate <- aggregate %>% filter(time >= as.numeric(substr(input$date_range[1],1,4))) %>%  
     filter(time <= as.numeric(substr(input$date_range[2],1,4)))
    
    return(aggregate)
  })
  
  output$barplot_comp <- renderPlotly({ 
    
    dat_long <- country_level() %>%  gather('Type', 'Emissions',-airpol, -time) %>% rename(`Type of emission` = airpol)
    
    if(nrow(dat_long) > 0){
      
      bar_comparison <- ggplot() + 
        geom_bar(data=dat_long, aes(x=time, y=Emissions, fill=`Type of emission`), stat='identity', size= 1.3, width=.5) +
        theme(panel.spacing.y=unit(0.01, "lines"))+xlab("Date") + ylab("Total emissions (in CO2 mil of tonnes)") +
        theme(axis.text.x=element_text(angle = 90, vjust = 0.5))
    } else {bar_comparison <- ggplot()}
    
    bar_comparison
  })
    
    
    
  output$bargasplot <- renderPlotly({
    
    # Basic barplot
    p<-ggplot(data=dataset(), aes(x=reorder(countries, gas_per_pop), y=gas_per_pop)) +
      geom_bar(stat="identity", width=0.7, fill="steelblue")+
      theme_minimal() +
      
      labs(
        title = "Greenhouse gas emissions per million people",
        y = 'Tonnes of greenhouse emissions per million people',
        x = ""
      ) +  
      theme(
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 12,   color = "#2a475e", hjust = 0.5
        ),
        
        plot.title.position = "plot",
        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 8, color = "black"),
        axis.title = element_text(size = 8),
        
        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white")
      )
    
    ggplotly(p + coord_flip())
    
  })
  
  output$bargasareaplot <- renderPlotly({
    
    # Basic barplot
    p<-ggplot(data=dataset(), aes(x=reorder(countries, gas_per_area), y=gas_per_area)) +
      geom_bar(stat="identity", width=0.7, fill="steelblue")+
      theme_minimal() +
      
      labs(
        title = "Greenhouse gas emissions per KM2",
        x = "",
        y = 'Tonnes of greenhouse emissions per KM2'
      ) +  
      theme(
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 12, hjust = 0.5,
          color = "#2a475e"
        ),
        
        plot.title.position = "plot",
        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 7, color = "black"),
        axis.title = element_text(size = 7),

        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white")
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
        title = 'Plot Analysis',
        x = "Population (in Millions)",
        y = "Total Greenhouse Emissions (Mil. tonnes)",
        caption = "<b>Source</b>: *Fisher's Iris dataset*"
      ) +  
      theme(
        legend.position = "none",
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 10, hjust = 0.5,
          color = "#2a475e"
        ),
       
        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 8, color = "black"),
        axis.title = element_text(size = 7),
        axis.line = element_line(colour = "grey50", arrow = grid::arrow(length = unit(0.3, "cm"))),
        
        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white"),
        plot.caption = element_text(colour = "blue")

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
      title = 'Plot Analysis',
      x = "Area (KM2)",
      y = "Total Greenhouse Emissions (Mil. of tonnes)"
    ) +  
      theme(
        legend.position = "none",
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 10,hjust = 0.5,
          color = "#2a475e"
        ),

        
        # Adjust axis parameters such as size and color.
        axis.text = element_text(size = 8, color = "black"),
        axis.title = element_text(size = 7),
        axis.line = element_line(colour = "grey50", arrow = grid::arrow(length = unit(0.3, "cm"))),
        
        
        # Use a light color for the background of the plot and the panel.
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white", color = "white")
      ) + scale_x_continuous(labels = scales::comma)
    
    ggplotly(ggp)
    
  })
  
  
  output$comparison_table <- DT::renderDataTable({
    
    green_table()
  })
  
  output$country_table <- DT::renderDataTable({
    
    country_level() %>% rename(`Type of emission` = airpol) %>% rename(Year = time) %>%  rename(`Greenhouse emissions (CO2 equivalent)` = gas) 
    
  })
}