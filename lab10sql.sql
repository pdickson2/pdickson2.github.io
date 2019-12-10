-- Insert the CRS data for the USA Contiguous Lambert Conformal Conic projection, as it is valid for distance and area calculations
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 9102004, 'esri', 102004, '+proj=lcc +lat_1=33 +lat_2=45 +lat_0=39 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ', 'PROJCS["USA_Contiguous_Lambert_Conformal_Conic",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",-96],PARAMETER["Standard_Parallel_1",33],PARAMETER["Standard_Parallel_2",45],PARAMETER["Latitude_Of_Origin",39],UNIT["Meter",1],AUTHORITY["EPSG","102004"]]')

-- Add the geometry column to the the tweet data and set the tweets to have spatial data as points, then transfrom from WGS 84 (twitter's default projection) to the conic selected above
SELECT addgeometrycolumn ('public', 'november', 'geom', 102004, 'point', 2);
UPDATE november
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004);
SELECT addgeometrycolumn ('public', 'dorian', 'geom', 102004, 'point', 2);
UPDATE dorian
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004)

-- Update the counties to the counties to the proper coordinate reference system
SELECT addgeometrycolumn ('public', 'counties', 'geom', 102004, 'multipolygon', 2);
update counties
SET geom = st_transform(geometry, 102004);

-- Then, we set the geographic region to only include those states which were potentially affected by Hurricane Dorian and had tweets relating to it.
WHERE statefp NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
 '36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
 '13', '12', '11', '10', '09', '05', '01')
 
 -- In order to intersect the tweets with their counties, add the geoid, which is distinct for both counties, then combine them with the geoid
ALTER TABLE november ADD COLUMN geoid varchar(5);
ALTER TABLE dorian ADD COLUMN geoid varchar(5);
UPDATE dorian
SET geoid = counties.geoid 
FROM counties
WHERE st_intersects(dorian.geom, counties.geom)

-- Create a new table for the count of tweets relating to dorian and november grouped by the county
create table doriancount as
SELECT geoid, 
count(dorian)  
FROM dorian
GROUP BY geoid;

create table novcount as
SELECT geoid, 
count(november)  
FROM november
GROUP BY geoid

-- Alter the county table to include a column for the count of tweets 
ALTER TABLE counties ADD COLUMN ncount integer;
ALTER TABLE counties ADD COLUMN dcount integer

-- Update the counties to include the count of tweets 
UPDATE counties
SET dcount = 0;
UPDATE counties
SET dcount = count
FROM doriancount
WHERE counties.geoid = doriancount.geoid;

UPDATE counties
SET ncount = 0;
UPDATE counties
SET ncount = count
FROM novcount
WHERE counties.geoid = novcount.geoid

-- Find the rate of tweets about Dorian by county
ALTER TABLE counties ADD COLUMN drate real;
UPDATE counties
SET drate = (dcount / 10000) * 1.0

-- Find the rate of tweets about Dorian by county population
ALTER TABLE counties ADD COLUMN dnorm real;
UPDATE counties
SET dnorm = (dcount / (pop/10000)) * 1.0

--Create a new comlumn for the counties which calculates the normalized tweet difference index 
ALTER TABLE counties ADD COLUMN ndti integer 
UPDATE counties
SET ndti = 0;
UPDATE counties
SET ndti = (dcount - ncount) / ((dcount + ncount) * 1.0)
where (dcount + ncount) > 0.0