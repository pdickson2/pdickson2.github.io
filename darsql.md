In weeks 5 and 6 we transitioned back to QGIS and utilized its Database Manager and POSTGIS functions to analyze openstreetmap data and data collected through the Rumani Huria Project in Dar es Salaam, as acessed through resilience academy.

In order to access these data in QGIS, the OpenStreetMap database was downloaded from the website and stored as an .osm file. Then, it was run through the [batch script](convertOSM.bat) which extracted the relevant data and extracted it to the PostGIS database.  We utilized the buildings from OSM in order to create a base layer by subward for flooding.  The data from Resilience Academy was loaded in the WFS feature section of QGIS, we used the water and subward layers from their website. From the WFS feature in QGIS, the layers can be added to the PostGIS database within QGIS.

Below, find the SQL that was utilized for this lab, in which we found the percentage of buildings by subward that would likely be affected by flooding in Dar es Salaam.  The basic idea behind this was to identify the subwards that were most at risk if flooding to occur in Dar es Salaam, based solely on preexisting water.  The water was taken from the natural layer of Resilience Academy, where natural was either water or wetland.

[SQL Dar es Salaam](lab6.sql)

The following is the visualization of our final map, produced through leaflet in QGIS, in which the water and subwards can be visualized together and separately.

[Leaflet Map of Flooding Density in Dar es Salaam](dsmap/index.html)
