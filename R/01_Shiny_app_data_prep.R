# R Script: \R\01_Shiny_app_data_prep.R

# This script runs using source_all() function from Shiny app main script.

# Load required libraries
pacman::p_load(here,shiny,shinydashboard,DT,fs,leaflet,plotly,tidyverse)

# Check project directory
My_project_directory <- here()
# Check installed packages
Mypath <-.libPaths() 
(.packages())