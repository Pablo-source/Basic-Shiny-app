# R script: app_launch_TRIGGER.R script

## 1. After cloning this github repo, we would have run renv::restore() to ensure required packages to run the Shiny app
#     Are available in our project environment.
# > renv::restore() 

# 2. Open this "app_launch_TRIGGER.R" script and press the "Source" button to trigger this Shiny app.
# This script will trigger the entire Shiny app and it will be displayed on your browser
# Initialising renv for this project 
library(renv)

# 2. Load shiny and shinydashboard libraries
# Following readme file we would have loaded required packages into R after executing renv::restore() command
# renv::restore()

library(shiny)
library(shinydashboard)
library(janitor)

# 3. Run this helper function to download original data and compute population rates for Confirmed, Recovered
# and Death cases

# Helper function
#  Source all required R scripts to download COVID data, create new fields 
#  and compute rates calculations (confirmed,recovered, deaths) per 10,000 population
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


# 4. Source script to launch Shiny app
source("app_launcher.R")