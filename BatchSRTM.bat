::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=srtm_

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\GEOG323\batch\%pre%

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%

:: Run Mosaicking tool, with consideration for the input -GRIDS, the -
saga_cmd grid_tools 3 -GRIDS=Insert inputs here -NAME=%pre%Mosaic -TYPE=9 -RESAMPLING=0 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd

:: Run UTM Projection tool - change zone to accurately reflect sample region
saga_cmd pj_proj4 24 -SOURCE=%od%\%pre%Mosaic.sgrd -RESAMPLING=0 -KEEP_TYPE=1 -GRID=%od%\%pre%mosaicUTM.sgrd -UTM_ZONE=37 -UTM_SOUTH=1

::Run Sink Drainage Routes
saga_cmd ta_preprocessor 1 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd

::Run Sink Removal
saga_cmd ta_preprocessor 2 -DEM=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd -DEM_PREPROC=%od%\%pre%sinkremoveddem.sgrd

::Run Flow Accumulation (top-down)
saga_cmd ta_hydrology 0 -ELEVATION=%od%\%pre%sinkremoveddem.sgrd -SINKROUTE=%od%\%pre%sinkroutes.sgrd -FLOW_UNIT=0 -FLOW=%od%\%pre%flowaccumulation.sgrd

::Run Channel Networks
saga_cmd ta_channels 0 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=NULL -CHNLNTWRK=%od%\%pre%channelnetwork.sgrd -CHNLROUTE=%od%\%pre%channelroutes.sgrd -SHAPES=%od%\%pre%shapes.sgrd -INIT_GRID=%od%\%pre%flowaccumulation.sgrd -INIT_VALUE=1000

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE

