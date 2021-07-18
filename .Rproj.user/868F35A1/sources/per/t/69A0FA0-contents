


fluidPage(
  
  titlePanel("Greenhouse Gas Emissions"),
  
  sidebarPanel(
    
    selectInput('year', 'Select year to display', 
                choices = years_available,
                selected = '2019')
  
  ),
  
  mainPanel(
    plotOutput('plot'),
    plotOutput('bargasplot')
  )
)