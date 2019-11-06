--Select buildings from initial osm polygons to create a separate, buildings only analysis
CREATE TABLE builds as
SELECT way, building, osm_id
FROM planet_osm_polygon
WHERE building IS NOT null

--Start by creating a new column in the building table to indicate if the building lies within the floodplain
ALTER TABLE builds ADD COLUMN flooded Boolean

--Update the buildings to indicate if they flooded based on intersection with water
UPDATE builds
SET flooded = TRUE
FROM water
WHERE st_intersects(way, (select geom FROM water))

--Update the buildings to be points to increase efficiency of processing time
UPDATE builds 
set way = st_centroid(way)

--Intersect the buildings with the subwards by creating a new column in the building table and then updating it accordingly with an intersection with the subwards
ALTER TABLE builds ADD COLUMN subward integer

UPDATE builds
SET subward = fid 
FROM subwards
WHERE st_intersects(builds.way, (subwards.geom))

--Calculate percentage of flooded buildings by subward

--Here, we created counts of the flooded buildings and total buildings within each subward
Create table  joinsw as
SELECT 
builds.subward as sw,
sum(builds.flood) as floods,
count(builds.osm_id) as buildcnt
FROM builds as builds
Join subwards as subward_id
ON st_intersects(builds.way, subward_id.geom)
GROUP BY builds.subward

--Next, we created a new column to calculate the percentage of buildings flooded within each subward
ALTER TABLE joinsw ADD COLUMN pctflood float
UPDATE joinsw	
SET pctflood = floods * 1.0 /buildcnt * 100

--Then, we changed the subwards without flooded buildings to be zero, so they could be visualized more easily
UPDATE joinsw
SET pctflood = 0
WHERE pctflood is null

--Finally, we created a view of the subwards in which we could view the percent of each building flooded
CREATE VIEW floodedsubwards as
SELECT a.geom, a.fid, a.subward, b.floods,  b.buildcnt, b.pctflood
FROM subwards AS a FULL JOIN joinsw AS b
ON a.fid = b.sw





