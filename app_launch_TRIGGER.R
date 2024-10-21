# R script: app_launch_TRIGGER.R script

## 1. After cloning this github repo, we would have run renv::restore() to ensure requrired packages to run the Shiny app
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

# 3. Source script to launch Shiny app
source("app_launcher.R")