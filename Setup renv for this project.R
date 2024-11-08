# R script: Setup renv for this project.R

## Set {renv} for this project 
library(renv)

# 1. Initialize my environment
renv::init()

# 2. Run all required scripts. Whilst running it I will install required packages
# When creating script 00_Initial_data_download.R script
renv::install('pacman')
renv::install('here')
renv::install('shiny')
renv::install('shinydashboard')
renv::install('DT')
renv::install('fs')
renv::install('leaflet')
renv::install('plotly')
renv::install('tidyverse')
renv::install('janitor')
# Include {WDI} package in the set of installed packages in renv used in "R\02_Covid_metrics_population_rates.R" script.
renv::install('WDI')
# Include {zoo} package in the set of installed packages in renv used in "R\02_Covid_metrics_population_rates.R" script.
renv::install('zoo')
# Include {tidygeocoder} package in the set of installed packages in renv used in "R\02_Covid_metrics_population_rates.R" script.
renv::install('tidygeocoder')

# 3. Check status of your lockfile using renv::status() function:
renv::status()

# 4. After we have confirmed the code works as expected, we use renv::snapshot()
#   to record the packages and their sources in the lockfile
# After installing {WDI} I ran again renv:snapshot()
renv::snapshot()
