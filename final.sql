-- SQL to analyze error in DHS survey points in Malawi, as recorded in Malcomb et al, 2014
-- Created by Paige Dickson in GEOG 323 at Middlebury College, 2019

--Transform the layers to a projection suitable for distance and area calculations in Africa (Lambert Conformal Conic - Africa) by inserting a spatial reference system valid for distance and area - taken from https://www.spatialreference.org with the PostGIS SRS insert
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102024, 'esri', 102024, '+proj=lcc +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ', 'PROJCS["Africa_Lambert_Conformal_Conic",GEOGCS["GCS_WGS_1984",DATUM["WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",25],PARAMETER["Standard_Parallel_1",20],PARAMETER["Standard_Parallel_2",-23],PARAMETER["Latitude_Of_Origin",0],UNIT["Meter",1],AUTHORITY["EPSG","102024"]]');

-- Then transfer all of the datasets which will be used in the analysis to   
ALTER TABLE dhspoints
 ALTER COLUMN geom TYPE geometry(Point, 102024)
   USING ST_Transform(ST_SetSRID(geom, 4326), 102024);
   ALTER TABLE lakes
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 102024)
   USING ST_Transform(ST_SetSRID(geom, 4326), 102024);
ALTER TABLE tas
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 102024)
   USING ST_Transform(ST_SetSRID(geom, 4326), 102024);
ALTER TABLE districts
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 102024)
   USING ST_Transform(ST_SetSRID(geom, 4326), 102024); 

--Intersect the dhs points with the district and the Traditional authority to have an initial assignment of the point to its geometry, as will be used later
alter table dhspoints add column district integer;
UPDATE dhspoints
SET district = districts.id 
FROM districts
WHERE st_intersects(dhspoints.geom, (districts.geom));
alter table dhspoints add column ta integer;
UPDATE dhspoints
SET ta = tas.id 
FROM tas
WHERE st_intersects(dhspoints.geom, (tas.geom));


--Create the buffers for each traditional authority based on their urbanity/rurality 
-- Rural points have a buffer of 5 km and urban points have a buffer of 2 km
create table ubuff as 
select 
st_buffer(dhspoints.geom, 2000), id, urbanrural, ta, district
FROM dhspoints
Where urbanrural = 1;
create table rbuff as 
select 
st_buffer(dhspoints.geom, 5000), id, urbanrural, ta, district 
FROM dhspoints
Where urbanrural = 2;

--Populate geometry columns to confirm appearance of buffersselect and prep it for the next step in analysis 
select populate_geometry_columns();

-- Now, the buffers can be intersected with the districts and the lakes to remove invalid areas 
-- First, remove any part of the buffers which sit in water
-- Code adapted from https://gis.stackexchange.com/questions/213851/more-on-cutting-polygons-with-polygons-in-postgis
create table nwrbuff as
WITH union_lakes AS (
    SELECT ST_Union(lakes.geom) as geom
    FROM lakes
    )
SELECT rbuff.id, rbuff.ta, rbuff.district, ST_Difference(rbuff.st_buffer, union_lakes.geom) 
FROM rbuff, union_lakes;

create table nwubuff as
WITH union_lakes AS (
    SELECT ST_Union(lakes.geom) as geom
    FROM lakes
    )
SELECT ubuff.id, ubuff.ta, ubuff.district, ST_Difference(ubuff.st_buffer, union_lakes.geom) 
FROM ubuff, union_lakes;

--Now, the land buffers need to be clipped to the proper district, by taking where the intersection of the waterless buffer and the districts where the district is the same as the initial district assigned in the analysis
create table urbbuff as
SELECT nwubuff.id, nwubuff.ta,
       (ST_INTERSECTION(nwubuff.st_difference, districts.geom))
FROM nwubuff, districts
WHERE nwubuff.district = districts.id;

create table rurbuff as
SELECT nwrbuff.id, nwrbuff.ta,
       (ST_INTERSECTION(nwrbuff.st_difference, districts.geom))
FROM nwrbuff, districts
WHERE nwrbuff.district = districts.id;

--Take the area of the possible area in which the survey points could've fallen by creating a new column in the buffers and calculating its area
alter table rurbuff add column totarea float;
alter table urbbuff add column totarea float;

UPDATE urbbuff
SET totarea = st_area(st_intersection);
UPDATE rurbuff
SET totarea = st_area(st_intersection);

-- Now can intersect with the Traditional Authorities, in order to calculate the chance it lay within the correct TA
-- One of the TAs had an issue with its geometry, so code taken from https://postgis.net/docs/ST_MakeValid.html was utilized in order to get the intersection to function properly
SELECT st_makevalid(geom) FROM tas;

-- Change the geometry name to geom to prevent issues with overlapping names, fix their geometries, and populate the geometry column again so it can function properly
ALTER TABLE urbbuff 
RENAME COLUMN st_intersection TO geom;
ALTER TABLE rurbuff 
RENAME COLUMN st_intersection TO geom;
SELECT st_makevalid(geom) FROM urbbuff;
SELECT st_makevalid(geom) FROM rurbuff;
SELECT populate_geometry_columns();

-- Now, intersect the correct buffers with the Traditional Authorities and select the intersections where the Traditional Authorities are correct given the initial DHS point
-- This step can have the final line of code removed to find the area of each individual subsection of the buffer if one wants to see the percentage of each traditional authority, which can then have the same percentages as calculated below                  
create table ubuffer as
SELECT urbbuff.id, urbbuff.ta, urbbuff.totarea,
       (ST_INTERSECTION(urbbuff.geom, tas.geom))
FROM urbbuff, tas
WHERE urbbuff.ta = tas.id;
create table rbuffer as
SELECT rurbuff.id, rurbuff.ta, rurbuff.totarea,
       (ST_INTERSECTION(rurbuff.geom, tas.geom))
FROM rurbuff, tas
WHERE rurbuff.ta = tas.id;

-- Calculate the areas of these correct buffers for each DHS point without water or incorrect districts 
alter table rbuffer add column area float;
alter table ubuffer add column area float;

UPDATE ubuffer
SET area = st_area(st_intersection);
UPDATE rbuffer
SET area = st_area(st_intersection);

-- Count the number of TAs in which each survey point can sit



--Finally,  add columns to the original points to calculate the likelihood that each DHS points sits in the proper Traditional Authority by calculating the percentage of overlapping area between the possible buffer and the correct buffer
alter table dhspoints add column area float;
alter table dhspoints add column totarea float;
alter table dhspoints add column pctcorrect float;

update  dhspoints 
set area = rbuffer.area
from rbuffer
where dhspoints.id = rbuffer.id;
update  dhspoints 
set area = ubuffer.area
from ubuffer
where dhspoints.id = ubuffer.id;
update  dhspoints 
set totarea = ubuffer.totarea
from ubuffer
where dhspoints.id = ubuffer.id;
update  dhspoints 
set totarea = rbuffer.totarea
from rbuffer
where dhspoints.id = rbuffer.id;

--Calculate the correct percentage
UPDATE dhspoints	
SET pctcorrect = area * 1.0 /totarea * 100;










