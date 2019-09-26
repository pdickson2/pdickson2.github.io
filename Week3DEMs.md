Our third week focused on digital elevation models of Mt. Kilimanjaro in SAGA.  This began with aster data courtesy of [NASA Earthdata](https://earthdata.nasa.gov/) for elevation and created a model of streamflow from this elevation data.

The lab began with integrating the two sections of the map which visualized Mt. Kilimanjaro to the scale.

![Mosaic](Mosaic1.png)  ![Legend](Mosaic1_legend.png)

After the creation of a unified study area, we created a shaded visualization of the area that easily shows elevation.

![Hillshade](analyticalhillshading2.png) ![legend2](analyticalhillshading2_legend.png)

Following this elevation shading, we utilized SAGA's sink detection function to identify possible holes of flow to remove these from our final product.

![Sinks](SinkRoute3.png) ![Legend3](SinkRoute3_legend.png)

Then, we removed these sinks from our area by filling them to ensure smooth flow lines.

![FilledSinks](SinkFilled4.png) ![Legend4](SinkFilled4_legend.png)

Then, we calculated flow accumulation to determine the quantity of flow given a cell and its surrounding elevation.

![FlowAccumulation](FlowAccumulation5.png) ![Legend5](FlowAccumulation5_legend.png)

Finally, we visualized the channel network of water flow in the area around Kilimanjaro on top of the shaded elevation.

![ChannelDirection](hillshadingchannels.png) ![Legend6](hillshadingchannels_legend.png)


The ultimate image is the ultimate visualization of the flow of streams and rivers as would be estimated by elevation data from Mt Kilimanjaro.
