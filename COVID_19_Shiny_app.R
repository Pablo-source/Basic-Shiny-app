# R Script: \COVID_19_Shiny_app.R

# Description
# Shiny app displaying confirmed, recovered and death COVID cases by countries.

# Shiny app using {tidyverse} for data wrangling,  {leaflet},{plotly} for interactive visualizations
# and {tidygeocoder} to obtain LAT LONG values using API calls.

library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(leaflet)
library(plotly)

## 1. Helper function
#  Source all required R scripts to download COVID data, create new fields for rates calculations
#  This is an ad hoc function that SOURCES all scripts from \R folder

files <- list.files(here::here("R"),
                    full.names = TRUE,
                    pattern = "R$")

source_all <-function(path = "R"){
  files <- list.files(here::here(path),
                      full.names = TRUE,
                      pattern = "R$")
  suppressMessages(lapply(files,source))
  invisible(path)
}

# Call helper function source_all() to run all R scripts from R folder
# This creates required dataframes to populate the Shiny App
source_all()


## 2.SHINY APP
# In this app, UI and SERVER scripts are both included on the same script "COVID_19_Shiny_app.R" to ease automation

# [1-2] UI SECTION -  User interface - app menus
ui <- dashboardPage(
  
  dashboardHeader(title = "COVID-19"),
  # Sidebar menu allows us to include new items on the sidebar navigation menu
  dashboardSidebar(
    sidebarMenu(
      # Setting id makes input$tabs give the tabName of currently-selected tab
      id = "tabs",
      menuItem("About", tabName = "about", icon = icon("desktop")),
      menuItem("COVID-19 Dashboard", tabName = "main_tab", icon = icon("map"))
    )
  )
  ,
  dashboardBody(  
    
    # Start building dashboard content
    
    # 1. KPIS  at the top of the dashboard:
    
    # Infobox: Total figures KPI UK
    fluidRow(
      infoBoxOutput("Confirmed_cases_UK", width = 3),
      infoBoxOutput("Recovered_cases_UK", width = 3),
      infoBoxOutput("Death_cases_UK", width = 3),
      infoBoxOutput("Date", width = 3)
      
    ),
    
    # 1.2 All content from this "map" tab must be enclosed in this tabItems() function:
    tabItems(
      # 1.3 Then individual content of this map tab must be INSIDE this tabItem() function:  
      
      # First tabItem to include the "about"  tab, defined by the first menuItem() function
      #    tabItem(
      #      tabName ="about",
      #       h1("About the COVID-19 app"),
      #     fluidRow(box(source("Shiny_features/About-tab/about_tab.R", local =T),width=11)),
      
      tabItem( 
        
        tabName ="about",
        h1("About the COVID-19 app"),
        
        fluidRow( box(
          source("Shiny_features/About_tab/about_tab.R", local = T)
          ,width = 12 ))
        
      ),
      
      # Then here goes the content of the SECOND tab, defined by the second menuItem() function
      
      tabItem(
        # 1. Building content for map tabName INSIDE the tabItem() function
        # 1.1 Main title for this MAP tab
        tabName ="main_tab",
        h2("World map COVID19 deaths by contry -hover over dots for country info"),
        
        # 2. MAP 
        fluidRow( box(leafletOutput("map"),p("Map displaying COVID-19 confirmed,recovered and deaths cases"),   width = 12 )),
        # 2. Adding content to the map tab
        # Each tab element goes inside a fluidRow() function
        
        # 3. TIME SLIDER - Used across all charts in the dashboard 
        # Input data set: "map_data"
        #     Variables: date > mutate(date = as.Date(date) )
        fluidRow(       
          box(
            sliderInput(inputId = "Time_Slider",
                        label = "Select Date",
                        min = min(map_data$date),
                        max = max(map_data$date),
                        value = max(map_data$date),
                        width = "100%",
                        timeFormat = "%d%m%Y",
                        animate = animationOptions(interval=3000,loop = TRUE)
            ),
            class = "slider",
            width = 15,
          )
        ),
        fluidRow(
          box(
            dataTableOutput("sitreptable"), width = 15)),
        
        # 4. Container with two objects (A Table and dynamic plotly bar chart) 
        #    Secont Tabbed frame with three plotly bar charts  
        # 1-2 Table
        # 2-2 Plotlty bar chart 
        fluidRow(
          box(  
            column(6, dataTableOutput("tableleft")),
            column(6, 
                   
                   # In this section goes the new tabsetPanel() function to support tabbed frames
                   # Then each tab is populated by tabPanel() function
                   tabsetPanel(id = "Threetabs",
                               tabPanel("Confirmed", plotlyOutput("ToptenCONFtab"),value = "confirmed"),
                               tabPanel("Recovered", plotlyOutput("ToptenRECtab"),value = "recovered"),
                               tabPanel("Deaths", plotlyOutput("ToptenDEATHtab"),value = "deaths")),
                   p("Bar plot displaying  confirmed, recovered and death cases by country ranked by total figures")),
            width = 15), 
        ),
        
        # 5. Drop down menu to choose country for Plotly Line charts section
        fluidRow(h2("Covid 19 Timeline measures by country")),
        fluidRow(h4("Select country from dropdown menu - Interactive Plotly line charts")),
        
        # 5.1 Menu to select country for Plotly charts
        fluidRow(column(4,
                        selectInput("country",
                                    "Country:",
                                    c("All",
                                      unique(as.character(metric_rates$country)))))
        ),
        
        
        
        
        # 6. Three Plotly line charts
        fluidRow( box(  
          column(4, plotlyOutput("Confcountries")),
          column(4, plotlyOutput("Reccountries")),
          column(4, plotlyOutput("Deathscountries")),
          width =12))
        
        
      ) # tabItem() function closing parenthesis
    ) # tabItems() function closing parenthesis
  ) # dashboardBody() function closing parenthesis
) # dashboardPage() function closing parenthesis 

# [2-2] SERVER SECTION - Server  - app content (tables, maps, charts)

server <- function(input,output) {
  
