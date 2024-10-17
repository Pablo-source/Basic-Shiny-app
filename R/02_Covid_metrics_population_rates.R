# R Script: \R\02_Covid_metrics_population_rates.R" 

# This script runs using source_all() function from Shiny app main script.

# AIM
# merge original METRICS_FOR_POP_RATES.csv file stored in \original_data_processed 
# with WDI_countries_pop_2019_clean.csv file stored in the same folder. 
# This new R script will replace previous existing “02 Leaf and pop figures_SHINY.R” file. 

# Load required libraries
pacman::p_load(readr,dplyr,ggplot2,here)

# COVID METRICS POPULATION RATES calculation steps:

# 1. Read in .csv files from \original_data_processed folder

# 1. Load METRICS_FOR_POP_RATES.csv file from \original_data_processed folder

# This step below loads .csv file into R in a new dataframe called "data_METRICS_FOR_POP_RATES"
metrcs_input_file  <- list.files("original_data_processed/", pattern = "METRICS_FOR_POP_RATES.*\\.csv")

file_Name <- c("METRICS_FOR_POP_RATES")

for (name in file_Name) {
  
  match_name <- metrcs_input_file[grepl(name, metrcs_input_file)]
  
  if(length(match_name) > 0) {
    assign(paste0("data_",name), read_csv(paste0("original_data_processed/",match_name)))
  }
}

# Rename data_METRICS_FOR_POP_RATES data frame as METRICS_original

METRICS_original <- data_METRICS_FOR_POP_RATES %>%  
  select(Country, Lat, Long, date, Confirmed, Recovered, Deaths)


METRICS <- METRICS_original

# Check unique country names from this METRICS file
METRICS_country_unique <- METRICS_original %>% select(Country) %>% distinct(Country)
METRICS_country_unique
nrow(METRICS_country_unique)
write.csv(METRICS_country_unique,here("original_data_processed","METRICS_country_unique.csv"), row.names = TRUE)

# 2. Get population figures from {WDI} package
library(tidyverse)
library(here)
# library {WDI} installed in the "Setup renv for this project.R"
library(WDI)

# 2.1. Load  World Bank Total population by country indicator "SP.POP.TOTL" from {WDI} package
WDI_population <- WDI(indicator = c("SP.POP.TOTL"), extra = TRUE)
WDI_population
