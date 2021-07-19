
# Header
header <- dashboardHeader(title = "Gas Emission in the EU", titleWidth = 350) 

# Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    width = 252,
    # Menu on the blue bar on the LH side
    menuItem("Summary Page", tabName = "start_page",icon = icon("th")),
    menuItem("Other Analysis", tabName = "add_analysis",  icon = icon("chart-line")),
    menuItem("Time Evolution",tabName = "time_evolution",icon = icon("sitemap"))
    )
)


# Body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "start_page",
            h2(""),
            
            fluidRow(
              box(title = "Greenhouse Gas Emissions",
                  width = 12,
                  height = 120,
                  solidHeader = TRUE,
                  status = "primary",
                  
                  column(
                    width = 6,
                    selectInput('year', 'Select year to display', 
                                choices = years_available,
                                selected = '2019')
                  )
                  
              )),
            
            fluidRow(
              box(
                width = 12,
                column(
                  width = 6,
                  plotlyOutput('plot'),
                  plotlyOutput('bargasplot')
                ),
                
                column(
                  width = 6,
                  plotlyOutput('plotarea'),
                  plotlyOutput('bargasareaplot')
                )

                )
              ))
              
            
            
            
    )
  )



# UI
ui <- dashboardPage(header, sidebar, body)