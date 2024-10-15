# R script: Setup renv for this project.R

## Set {renv} for this project 
library(renv)

# 1. Initialize my environment
renv::init()

# 2. Run all required scripts. Whilst running it I will install rqeuried packages


# 3. After we have confirmed the code works as expected, we use renv::snapshot()
#   to record the packages and their sources in the lockfile

