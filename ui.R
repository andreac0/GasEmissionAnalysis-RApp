
# Header
header <- dashboardHeader(title = "Gas Emission in the EU", titleWidth = 350) 

# Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    width = 252,
    # Menu on the blue bar on the LH side
    menuItem("Summary Page", tabName = "start_page",icon = icon("th")),
    menuItem("Country Level Analysis", tabName = "add_analysis",  icon = icon("chart-line"))
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
                    width = 3,
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
                ),
                
                DT::dataTableOutput("comparison_table")
                )
              )),
              
            
    tabItem(tabName = "add_analysis",
            h2(""),
            
            fluidRow(
              box(title = "Greenhouse Gas Emissions",
                  width = 12,
                  height = 120,
                  solidHeader = TRUE,
                  status = "primary",
                  
                  
                  column(
                    width = 3,
                    selectInput('country', 'Select country', 
                                choices = countries,
                                selected = 'Germany')
                  ),
              )),
            
            fluidRow(
              box(title = "Time evolution of greenhouse emissions",
                  width = 12,
                  solidHeader = TRUE,
                  status = "primary",
                  

                  plotlyOutput("barplot_comp"),
                  
                  DT::dataTableOutput("country_table")
                  
              ))
            
            
            )       
            
    )
)



# UI
ui <- dashboardPage(header, sidebar, body)