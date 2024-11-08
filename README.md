# Basic-Shiny-app
This is a Shiny app displaying COVID cases over time. Users can explore COVID19 confirmed, recovered and death cases, interacting with maps and charts to visualize these indicators by countries.

Following RAP principles, applied renv::init() to initialise environment and also taken a snapshot of the project with renv::snapshot(), once the Shiny app has ran. The entire environment can be replicated just by running renv::restore() after opening the R project file.

Features:  

- Created a couple of adhoc functions to download original .csv files from (JHU CSSE) repository, they include an automated triger to downlod the data every half an hour. This shows how to get online data for Shiny applications runing 24/7. 

- In  *API_Obtain_countries_Lat_Long.R* script, there is an example on how to use {tidygeocoder] to perform geocoding queries to obtain latitute and longitude coordinates with geo() function. The api_parameter_reference maps the API parameters for each geocoding service common set of “generic” parameters.
  
## How to run this Shiny app on your machine

To run this **Shiny-app-using-COVID-data** app locally, please follow these **three** steps below:

1-3. Clone **Shiny-app-using-COVID-data** repo using git on you IDE or your terminal using local Clone HTTPS option
<https://github.com/Pablo-source/Basic-Shiny-app.git>

> **git clone https://github.com/Pablo-source/Basic-Shiny-app.git**

Navigate to the cloned repo, then open Rproject by clicking on the **Basic-Shiny-app.Rproj** file. This will display the Shiny app files on your "Files" tab in RStudio.

2-3. Run **renv::restore()** in a new Rscript. The first time the app finshed running, I captured its final state using **renv::snapshot()**
To ensure all required packages are loaded, we reinstall exact packages declared in the project lockfile renv.lock.
Then we run **renv::restore()** to ensure we have all required packages loaded and ready in our R environment.

> **renv::restore()**

If prompted, after running restore() function, choose "1: Activate the project and use the project library." from menu displayed in the R Console.

In the next step when using **app_launch_TRIGGER.R** script, we will have all required packages for the app loaded by the **renv::restore()** command.

3-3. Open “**app_launch_TRIGGER.R** script”
- Then  press **"Source"** button in RStudio to trigger the Shiny app.

This script triggers another script called "app_launch.R" containing runAPP() Shiny function to start the Shiny app.

## Data downloaded from Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) repository

Data for this app is produced by the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) for their 2019 Novel Coronavirus Visual Dashboard and Supported by ESRI Living Atlas Team and the Johns Hopkins University Applied Physics Lab (JHU APL).

John Hopkins repository stores daily CODIV-19 data files for each country worldwide

https://github.com/CSSEGISandData/COVID-19 

Original data to populate this Shiny dashboard can be found in the CSSEGISandData main GitHub website. <https://github.com/CSSEGISandData>

The set of three specific files used on this Shiny Dashboard, can be found found under the  “archived_time_series” folder: <https://github.com/CSSEGISandData/COVID-19/tree/master/archived_data/archived_time_series>

I have read the data directly into R with an ad hoc function DownloadCOVIDData() using download.file() function with specific URL address for each of the three individual files, this function used the **Raw** path provided on the GitHub repo location of each of the invidual input files: 

- [1] "time_series_19-covid-Confirmed_archived_0325.csv"
- [2] "time_series_19-covid-Deaths_archived_0325.csv"   
- [3] "time_series_19-covid-Recovered_archived_0325.csv"

## Shiny app design

In **August 2024**, I introduced several re-design changes to the app. Imrpvpving its design and applying RAP principles to the project: 

Back end:
-   Built new functions to download CSSEGIS data: (from original JHU CSSE repo: https://github.com/CSSEGISandData/COVID-19)
https://github.com/Pablo-source/Basic-Shiny-app/blob/main/R/00_Initial_data_download.R
-   From {tidygeocoder} package, used geo() function to conduct specific calls to the API to retrieve Lat and Long values. Using batches of 10 up to 50 countries to test the API response time.
https://github.com/Pablo-source/Basic-Shiny-app/blob/main/Checks/API_Obtain_countries_Lat_Long.R 
-	Following RAP principles, applied **renv::init()** to initialise environment and also taken a snapshot of the project using **renv::snapshot()**. By creating the lockfile, we ensure all packages required for this project are available. These actions create a  project library directory, ensuring we have loaded the right packages and the right versions. 
https://github.com/Pablo-source/Basic-Shiny-app/blob/main/Setup%20renv%20for%20this%20project.R

Front end:
- Shiny app designed into a single tab combining all previous charts and plots. I will change slightly the existing charts arrangement in the dashboard.
- Included pop-up tooltips containing daily confirmed, recovered and death cases by country

Added legend to leaflet map
![00_Added_legend_to_leaflet_map](https://github.com/user-attachments/assets/2b55ac43-f125-43e7-b785-a4eca01fa4b8)

Included new dynamic **plotly** bar charts in a tabbed container using tabsetPanel() function to display Confirmed, Recovered and Death covid cased by time
![04_Plotly_interactive_charts_01](https://github.com/user-attachments/assets/24b1a55a-4502-42b4-a3de-da564722e0d2)

![06_Tabbed_panels_terminal_screenshot](https://github.com/user-attachments/assets/1bfbea15-9501-4807-a710-6751bce86ba9)

Overall design of this shiny app - Top section includiong animated leaflet map and plotly charts
![07_full_shiny_app_top](https://github.com/user-attachments/assets/37530e5e-408c-483d-a2bd-41e97d9dee84)

Bottom section displaying line chart cases by selected countries
![08_full_shiny_app_bottom](https://github.com/user-attachments/assets/ab363d43-df4f-4f0b-a00b-02332e0ed821)

Previos Iteration of this Shiny app (initial design): <https://github.com/Pablo-source/Shiny-app-using-COVID-data>
