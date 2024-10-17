# R Script: \R\01_Shiny_app_data_prep.R

# This script runs using source_all() function from Shiny app main script.

# Load required libraries
pacman::p_load(here,shiny,shinydashboard,DT,fs,leaflet,plotly,tidyverse)

# Check project directory
My_project_directory <- here()
# Check installed packages
Mypath <-.libPaths() 
(.packages())

# DATA WRANGLING steps in this "01_Shiny_app_data_prep.R" script:

# 1. Read in the downloaded .csv files
# 2. Pivot wide to long original files to TIDY data frames
# 3. Merge together Confirmed, Recovered and Deceased files now in LONG format 
#  confirmed_tidy, deceased_tidy, recovered_tidy
# 4. Create data sets used in LEAFLET MAP and METRICS tables
# 5. Save final two data sets created LEAFLET_MAPS_DATA,METRICS_FOR_POP_RATES in new "original_data_processed" folder


#  1. Read in the downloaded .csv files

# From the download files 

# We exclude these three files "ncov" because they have date and time format in date columns
# 1/21/20 22:00	1/22/20 12:00	1/23/20 12:00
# time_series_2019-ncov-Confirmed.csv,  time_series_2019-ncov-Deaths.csv,  time_series_2019-ncov-Recovered.csv


#file_Name <-c("time_series_covid19_confirmed_global.csv","time_series_covid19_deaths_global.csv",
# "time_series_covid19_recovered_global.csv")

# 1.1 From downloaded folder "original_data_download
# Input files with "time_series_19-covid"
# read in those files with pattern "time_series_19-covid"

input_covid <- list.files("original_data_download/", pattern = "time_series_19-covid-.*\\.csv")

# [1] "time_series_19-covid-Confirmed_archived_0325.csv" "time_series_19-covid-Deaths_archived_0325.csv"   
# [3] "time_series_19-covid-Recovered_archived_0325.csv"

# From original files downloaded we only work with the ones matching above pattern
NFILES <- length(input_covid)

# 1.2 adhoc loop to read in all selected files into a dataframe in R 
#     Names assigned to new input dataframe "data_Confirmed,data_Deaths,data_Recovered"

file_Name <- c("Confirmed", "Deaths", "Recovered")

for (name in file_Name) {
  
  match_name <- input_covid[grepl(name, input_covid)]
  
  if(length(match_name) > 0) {
    assign(paste0("data_",name), read_csv(paste0("original_data_download/",match_name)))
  }
}

# 2. Pivot wide to long original files to TIDY data frames
# We want date to be in one single column and metric in columns too

# 2.1 Creating CONFIRMED TIDY file. Pivot file from wide to long. 
names(data_Confirmed)

# [1] "Province/State" "Country/Region" "Lat"            "Long"           "1/22/20"        "1/23/20"        "1/24/20"       
# [8] "1/25/20"        "1/26/20"        "1/27/20"        "1/28/20"        "1/29/20" 

# Working with time_series_19-covid-Confirmed_archived_0325.csv" input file saved as "data_Confirmed" data frame 
confirmed_tidy <- data_Confirmed %>% 
  rename(Province = 'Province/State',
         Country = 'Country/Region') %>% 
  pivot_longer(names_to = "date", 
               cols = 5:ncol(data_Confirmed)) %>% 
  group_by(Province,Country,Lat,Long,date) %>% 
  summarise("Confirmed"= sum(value,na.rm = T)) %>% 
  mutate(date =as.Date(date,"%m/%d/%y")) %>% 
  ungroup()

# 2.2 Creating DECEASED TIDY file. Pivot file from wide to long. 
# DECEASED TIDY
deceased_tidy <- data_Deaths %>% 
  rename(Province = 'Province/State',
         Country = 'Country/Region') %>% 
  pivot_longer(names_to = "date",
               cols = 5:ncol(data_Deaths)) %>% 
  group_by(Province,Country,Lat,Long,date) %>% 
  summarise("Deaths" = sum(value,na.rm = T)) %>% 
  mutate(date = as.Date(date,"%m/%d/%y")) %>% 
  ungroup()

# 2.3 Creating RECOVERED TIDY file. Pivot file from wide to long. 
# RECOVERED TIDY
recovered_tidy <- data_Recovered %>% 
  rename(Province = 'Province/State',
         Country = 'Country/Region') %>% 
  pivot_longer(names_to = "date",
               cols = 5:ncol(data_Recovered)) %>% 
  group_by(Province,Country,Lat,Long,date) %>% 
  summarise("Recovered" = sum(value,na.rm = T)) %>% 
  mutate(date = as.Date(date,"%m/%d/%y")) %>% 
  ungroup()

# 2.4 Save checks in new sub_folder called Checks using HERE package 
if (!file.exists("Checks")) {dir.create("Checks")}

write.csv(confirmed_tidy,here("Checks","CONFIRMED_pivoted.csv"), row.names = TRUE)
write.csv(deceased_tidy,here("Checks","DECEASED_pivoted.csv"), row.names = TRUE)
write.csv(recovered_tidy,here("Checks","RECOVERED_pivoted.csv"), row.names = TRUE)

# 2.5 Create new folder to store Quarto documentation about designing this Shiny dashboard
# Folder name: "Shiny_howto_tutorials
if (!file.exists("Shiny_howto_tutorials")) {dir.create("Shiny_howto_tutorials")}

# Action: Save two .qmd files as templaets: - Mutating_Joins_dplyr.qmd, Pivot_long_wide_tidy.qmd

# 3. Merge together Confirmed, Recovered and Deceased files now in LONG format 
#  confirmed_tidy, deceased_tidy, recovered_tidy

# 3.1 Merge Confirmed and Recovered files
#     by(Province,Country,Lat,Long,date)

confirmed_tidy_sub <- confirmed_tidy %>% select(Country,Lat,Long,date,Confirmed)
recovered_tidy_sub <- recovered_tidy  %>% select(Country,Lat,Long,date,Recovered)
deceased_tidy_sub <- deceased_tidy  %>% select(Country,Lat,Long,date,Deaths)


conf_rec_join <-left_join(confirmed_tidy_sub,recovered_tidy_sub,
                          by = join_by(Country == Country,
                                       Lat == Lat,
                                       Long == Long,
                                       date == date))

# 3.2 Merge previous two files with deceased_tidy file

conf_rec_death_join <- left_join(conf_rec_join,deceased_tidy_sub,
                                 by = join_by(Country == Country,
                                              Lat == Lat,
                                              Long == Long,
                                              date == date))

write.csv(conf_rec_death_join,here("Checks","conf_rec_death_join.csv"), row.names = TRUE)

# Now we have the initial three COVID-19 Metrics into a single file. 

# 4. Create data sets used in LEAFLET MAP and METRICS tables

# 4.1 First we ensure any null values are present in the data. If so we replace them by 0.
conf_rec_death_join_WIDE <- conf_rec_death_join %>% 
  arrange(Country,date) %>% 
  # Recode NA values into 0 
  mutate(  
    Confirmed = ifelse(is.na(Confirmed),0,Confirmed),
    Deaths = ifelse(is.na(Deaths),0,Deaths),
    Recovered = ifelse(is.na(Recovered),0,Recovered)
  )

# 4.2 We need to change the data structure to group Confirmed, Deaths, Recovered  
#     into a single COLUMN with a variable displaying three values 
#     We only need (Country, Lat, Long, date, Confirmed, Recovered, Deaths)
MAPDATA_prep_long <- conf_rec_death_join_WIDE %>% 
  select(Country, Lat, Long, date, Confirmed, Recovered, Deaths) %>% 
  pivot_longer(names_to = "Metric",
               cols = c("Confirmed","Deaths","Recovered")) %>% 
  ungroup()

# 5. Save final two data sets created LEAFLET_MAPS_DATA,METRICS_FOR_POP_RATES in new "original_data_processed" folder

# 5.1 File to be used in the LEAFLET map
# Input file: MAPDATA_prep_long
LEAFLET_MAPS_DATA <- MAPDATA_prep_long

# 5.2 File to be used in the RATES CALCULATION tables
# Input file:conf_rec_death_join_WIDE
METRICS_FOR_POP_RATES <- conf_rec_death_join_WIDE

rm(list=ls()[! ls() %in% c("LEAFLET_MAPS_DATA","METRICS_FOR_POP_RATES")])

# Save both data sets in new "original_data_processed" folder:
if (!file.exists("original_data_processed")) {dir.create("original_data_processed")}

write.csv(LEAFLET_MAPS_DATA,here("original_data_processed","LEAFLET_MAPS_DATA.csv"), row.names = TRUE)
write.csv(METRICS_FOR_POP_RATES,here("original_data_processed","METRICS_FOR_POP_RATES.csv"), row.names = TRUE)
