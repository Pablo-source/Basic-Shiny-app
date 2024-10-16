# Basic-Shiny-app
This is a Shiny app displaying COVID cases over time. Users can explore COVID19 confirmed, recovered and death cases, interacting with maps and charts to visualize these indicators by countries.

Following RAP principles, applied renv::init() to initialise environment and also taken a snapshot of the project with renv::snapshot(), once the Shiny app has ran. The entire environment can be replicated just by running renv::restore() after opening the R project file.

Features:  

- Created a couple of adhoc functions to download original .csv files from (JHU CSSE) repository, they include an automated triger to downlod the data every half an hour. This shows how to get online data for Shiny applications runing 24/7. 

- In  *API_Obtain_countries_Lat_Long.R* script, there is an example on how to use {tidygeocoder] to perform geocoding queries to obtain latitute and longitude coordinates with geo() function. The api_parameter_reference maps the API parameters for each geocoding service common set of “generic” parameters.
  
## How to run this Shiny app on your machine

To run this **Shiny-app-using-COVID-data** app locally, please follow these **three** steps below:

1-3. Clone **Shiny-app-using-COVID-data** repo using git on you IDE or your terminal using local Clone HTTPS option
<https://github.com/Pablo-source/Shiny-app-using-COVID-data.git>

> **git clone https://github.com/Pablo-source/Shiny-app-using-COVID-data.git**

Navigate to the cloned repo, then open Rproject by clicking on the **Shiny-app-using-COVID-data.Rproj** file. This will display the Shiny app files on your "Files" tab in RStudio.

2-3. Run **renv::restore()** in a new Rscript. The first time the app finshed running, I captured its final state using **renv::snapshot()**
To ensure all required packages are loaded, we reinstall exact packages declared in the project lockfile renv.lock.
Then we run **renv::restore()** to ensure we have all required packages loaded and ready in our R environment.

> **renv::restore()**

If prompted, after running restore() function, choose "1: Activate the project and use the project library." from menu displayed in the R Console.

In the next step when using **app_launch_TRIGGER.R** script, we will have all required packages for the app loaded by the **renv::restore()** command.

3-3. Open “**app_launch_TRIGGER.R** script”
- Then  press **"Source"** button in RStudio to trigger the Shiny app.

## Data downloaded from Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) repository

Data for this app is produced by the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) for their 2019 Novel Coronavirus Visual Dashboard and Supported by ESRI Living Atlas Team and the Johns Hopkins University Applied Physics Lab (JHU APL).

John Hopkins repository stores daily CODIV-19 data files for each country worldwide

https://github.com/CSSEGISandData/COVID-19 

