# Final Project

For my final project in this class, I chose to continue looking at the lab we conducted in the seventh and eight weeks of our class, which can be viewed [here](malawi.md).  The initial lab attempted to recreate work conducted by Malcomb et al. in 2014, linked [here](https://reader.elsevier.com/reader/sd/pii/S0143622814000058?token=078A0ACAE18D01995A67473D93E5DC36A07C5779021CF903B8334CF1D7C8EAD9277467C394E80035D5AD73BF0FD401F0).  The paper examines social vulnerability in Malawi as a lens for possible future reseach into the topic. I looked at the uncertainty of one of the initial sources of data for the lab, the locations of the DHS Survey points.  

In an attempt to protect privacy of survey takers, the DHS Survey points were randomized up to 2km for those located in urban areas and up to 5km for those located in rural areas.  While this randomization did not cross over official district boundaries, the scale at which they were measured, they can cross over the traditional authority boundaries, which are used to create the third and fourth figures in the analysis, as seen below.  Therefore, I wanted to look at the probability that each point was misassigned in its randomization to further examine the accuracy of this methodology.

![fig3](figure3.PNG "Malcomb Figure 3") ![fig4](figure4.PNG "Malcomb Figure 4")

The data for this specific part of the analysis are the Demographic and Health survey data and districts, which cannot be published and the major waterways and traditional authorities of Malawi, which can be found at [MASDAP](http://www.masdap.mw/). This analysis was conducted in the PostGIS database manager in QGIS 3.8.1.


## Methodology
Firstly, as the buffers' distance was contingent on the urban/rural status of the point.  While this data is included in the initial DHS points, it is represented as a varchar, which made it unable to be selected in SQL.  To rectify this, before entering my database, I created a new urbanrural column which used an integer classification, then set urban = 1 and rural = 2.

Then, I brought my layers into the PostGIS database manager.  I created the following [sql](final.sql) which explained my methodology in finding the likelihood that each point sits within the correct traditional authority.  While each individual step is detailed in the SQL, a basic synopsis of my methodology is as follows.

 - Create the buffers for the rural (5km) and urban (2km) points
 - Eliminate the area of the buffers that overlaps with waterways
 - Eliminate the area of the buffers which lie in the incorrect district
 - Calculate area of the possible buffer
 - Find the buffer which sits in the correct Traditional Authority
 - Calculate the are of the buffer in the correct TA
 - Add the areas to the survey points and calculate the chance they are correctly located.
