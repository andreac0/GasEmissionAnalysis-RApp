##########################
#  App Server
##########################


function(input, output) {
  
  dataset <- reactive({
    green_popu %>% filter(time == input$year) 
  })
  
  output$bargasplot <- renderPlot({
    
    # Basic barplot
    p<-ggplot(data=dataset(), aes(x=reorder(countries, gas_per_pop), y=gas_per_pop)) +
      geom_bar(stat="identity", width=0.7, fill="steelblue")+
      theme_minimal() +
      
      labs(
        y = "Greenhouse gas emissions per population",
        x = "Country"
      ) 
    
    p + coord_flip()
    
  })
  
  output$plot <- renderPlot({
    
    # Plots
    ggp <- ggplot(dataset(), mapping = aes(x=population, y=gas)) +
      geom_point(aes(colour=countries, size = gas/population), alpha=0.6) + 
      geom_text_repel(
        aes(label = countries),
        size = 4,
        min.segment.length = 0,
        seed = 2,
        box.padding = 0.4,
        # arrow = arrow(length = unit(0.010, "npc")),
        nudge_x = .15,
        nudge_y = .5,
        color = "grey30") +
      
      labs(
        title = "Population and Greenhouse Gas Emissions",
        x = "Population (in Millions)",
        y = "Total Greenhouse Emissions (Millions of tonnes)"
      ) +  
      theme(
        legend.position = "none",
        # Customize title and subtitle font/size/color
        plot.title = element_text(
          size = 20,
          face = "bold", 
          color = "#2a475e"
        ),
        plot.subtitle = element_text(
          size = 15, 
          face = "bold", 
          color = "#1b2838"
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
    
    ggp
    
  })
  
}