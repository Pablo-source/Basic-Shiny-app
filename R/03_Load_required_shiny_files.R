# 03_Load_required_Shiny_files.R
library(here)
library(tidyverse)
library(janitor)
library(shiny)
library(shinydashboard)   # Library to build dashboard
library(DT)               # Library for interactive tables
library(tidyverse)        # Library for data manipulation
library(leaflet)          # Library to create interactive maps (Enables pop-ups and animations)
library(plotly)  
library(lubridate)

# Shiny input file 01-02: \data\LEAFLET_MAPS_DATA.csv
## From this file we use "map_data" data set in Shiny leaflet map 

# 1. Load initial map data  LEAFLET_MAPS_DATA.csv file
# here("data","LEAFLET_MAPS_DATA.csv")
map_data_prep  <-read.table(here("data", "LEAFLET_MAPS_DATA.csv"),
                            header =TRUE, sep =',',stringsAsFactors =TRUE) %>% clean_names() 

# 1.1 Transform initial date variable into a standard R date using as.Date() function.
map_data <- map_data_prep %>% select(!c("x")) %>% mutate(date = as.Date(date) )

names(map_data)
# [1] "country"     "date"        "confirmed_d" "recovered_d" "deaths_d"    "lat"         "long"        "country_map"



# Shiny input file 02-02:METRICS_POP_RATES_DATA.csv
## From this file we use "metric_rates" data set in Shiny leaflet map 

# 2. Load initial population rates file METRICS_POP_RATES_DATA.csv 
# here("data","METRICS_POP_RATES_DATA.csv"),

metrics_rates_prep   <-read.table(here("data", "METRICS_POP_RATES_DATA.csv"),
                                  header =TRUE, sep =',',stringsAsFactors =TRUE) %>% clean_names() 

# 2.1 Transform initial date variable into a standard R date using as.Date() function.
metrics_rates_select <- metrics_rates_prep %>% select(!c("x")) %>% mutate(date = as.Date(date) )

head(metrics_rates_select)


# 2.1 Apply format to metric rates data frame to be used in renderDataTable() function:
metric_rates_fmt <- metrics_rates_select %>% 
  select(country, date, confirmed,recovered,deaths,population,
         confirmed_7dma,recovered_7dma,deaths_7dma,
         conf_ma07_rates,rec_ma07_rates,death_ma07_rates) %>% 
  # Create new vars to apply format 
  mutate(
    conf_7Days_moving_avg = round(confirmed_7dma,0), 
    rec_7Days_moving_avg = round(recovered_7dma,0), 
    deaths_7Days_moving_avg =round(deaths_7dma,0),
    'conf_x10,000pop_rate' = round(conf_ma07_rates,0),
    'rec_x10,000pop_rate' = round(rec_ma07_rates,0),
    'deaths_x10,000pop_rate' = round(death_ma07_rates,0)) %>% 
  arrange(desc(confirmed))

# 2.2 This metric_rates files is the dataframe used in the Shiny app
metric_rates <- metric_rates_fmt %>% 
  select(country, date, confirmed,recovered,deaths,population,
         conf_7Days_moving_avg,rec_7Days_moving_avg,deaths_7Days_moving_avg,
         'conf_x10,000pop_rate', 'rec_x10,000pop_rate','deaths_x10,000pop_rate'
  )

write.csv(metric_rates,here("data","METRICS_POP_RATES_DATA_FORMATED.csv"), row.names = TRUE)

## Keep just these two data frames for the Shiny APP: (map_data,metric_rates)
rm(list=ls()[!(ls()%in%c('map_data','metric_rates'))])


