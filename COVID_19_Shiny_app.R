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

