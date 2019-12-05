In weeks 5 and 6 we transitioned back to QGIS and utilized its Database Manager and POSTGIS functions to analyze openstreetmap data and data collected through the Rumani Huria Project in Dar es Salaam, as acessed through [resilience academy]( https://geonode.resilienceacademy.ac.tz/geoserver/ows).  For my analysis, my partner and I chose to explore what percentage of buildings in each subward of Dar es Salaam were especially vulnerable to flooding based on their location relative to water sources.

In order to access these data in QGIS, the OpenStreetMap database was downloaded from the website and stored as an .osm file. Then, it was run through the [batch script](convertOSM.bat) with notepad++ which extracted the relevant data and extracted it to the PostGIS database.  We utilized the buildings from OSM in order to create a base layer by subward for flooding.  The data from Resilience Academy was loaded in the WFS feature section of QGIS, we used the water and subward layers from their website. From the WFS feature in QGIS, the layers can be added to the PostGIS database within QGIS.

Below, find the SQL that was utilized for this lab, in which we found the percentage of buildings by subward that would likely be affected by flooding in Dar es Salaam.  The basic idea behind this was to identify the subwards that were most at risk if flooding was to occur in Dar es Salaam, based solely on preexisting water.  The water was taken from the natural layer of Resilience Academy, where natural was either water or wetland.  From there, we found the percentage of builings by subward that were at risk for immediate flooding by comparing the buildings at risk by subward with the total quantity of buildings in that subward.

Here is a basic overview of the steps conducted with the SQL code:
  1. Select buildings and water layers
    a. Select buildings from OSM 
    b. Select water Resilience Academy
  2. Convert buildings to points
  3. Check buildings' flood status
    a. Add a column to the buildings for flooding
    b. Populate the column with an intersection with the water
  4. Calculate the percentage of flooded buildings by subward
    a. Create a table of subwards with a column for the count of flooded buildings
    b. Intersect buildings with subwards
    c. Count the buildings flooded by subward and add that data to the new column
    d. Count the buildings in each subward
    e. Add a column for the percentage of flooded buildings in each subward and populate it
  
[SQL Dar es Salaam](lab6.sql)

The following is the visualization of our final map, produced through leaflet in QGIS, in which the water and subwards can be visualized together and separately.  From this map, it can be seen that there are certain subwards which are much more vulnerable to flooding than others.  For example, most of the outside subwards of Dar es Salaam seem relatively safe from normal acts of flooding and therefore would need less focus if action were taken to help counteract or prevent flooding.  Conversely, many of the subwards most at risk for flooding are near the center of the city, so if resources were to be allocated, those are the locations where they should be concentrated. 

[Leaflet Map of Flooding Density in Dar es Salaam](dsmap/index.html)

Another important note for this lab is to take into consideration the sources of these data coming from open sources.  Data collected for OSM and Resilience Academy in Malawi are largely collected by individuals, not official agencies.  Therefore, it is important to recognize that absolute accuracy cannot be guaranteed from the conclusions drawn here.  Rather, it serves as a framework to potentially look at a similar issue in the future.

[Return to homepage](pdickson.github.io)
