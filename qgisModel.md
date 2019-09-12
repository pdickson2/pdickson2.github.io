##My First QGIS Model

In the first lab, we created a model to calculate the distance and direction from a point.

<!DOCTYPE model>
<Option type="Map">
  <Option name="children" type="Map">
    <Option name="native:centroids_1" type="Map">
      <Option name="active" type="bool" value="true"/>
      <Option name="alg_config"/>
      <Option name="alg_id" type="QString" value="native:centroids"/>
      <Option name="component_description" type="QString" value="Centroids"/>
      <Option name="component_pos_x" type="double" value="484.6990291262136"/>
      <Option name="component_pos_y" type="double" value="196.93203883495147"/>
      <Option name="dependencies"/>
      <Option name="id" type="QString" value="native:centroids_1"/>
      <Option name="outputs"/>
      <Option name="outputs_collapsed" type="bool" value="true"/>
      <Option name="parameters_collapsed" type="bool" value="true"/>
      <Option name="params" type="Map">
        <Option name="ALL_PARTS" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="bool" value="false"/>
          </Option>
        </Option>
        <Option name="INPUT" type="List">
          <Option type="Map">
            <Option name="parameter_name" type="QString" value="citycenters"/>
            <Option name="source" type="int" value="0"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option name="native:meancoordinates_1" type="Map">
      <Option name="active" type="bool" value="true"/>
      <Option name="alg_config"/>
      <Option name="alg_id" type="QString" value="native:meancoordinates"/>
      <Option name="component_description" type="QString" value="Mean coordinate(s)"/>
      <Option name="component_pos_x" type="double" value="482.87378640776683"/>
      <Option name="component_pos_y" type="double" value="267.766990291262"/>
      <Option name="dependencies"/>
      <Option name="id" type="QString" value="native:meancoordinates_1"/>
      <Option name="outputs"/>
      <Option name="outputs_collapsed" type="bool" value="true"/>
      <Option name="parameters_collapsed" type="bool" value="true"/>
      <Option name="params" type="Map">
        <Option name="INPUT" type="List">
          <Option type="Map">
            <Option name="child_id" type="QString" value="native:centroids_1"/>
            <Option name="output_name" type="QString" value="OUTPUT"/>
            <Option name="source" type="int" value="1"/>
          </Option>
        </Option>
        <Option name="UID" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="invalid"/>
          </Option>
        </Option>
        <Option name="WEIGHT" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="invalid"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option name="qgis:fieldcalculator_1" type="Map">
      <Option name="active" type="bool" value="true"/>
      <Option name="alg_config"/>
      <Option name="alg_id" type="QString" value="qgis:fieldcalculator"/>
      <Option name="component_description" type="QString" value="Field calculator (distance)"/>
      <Option name="component_pos_x" type="double" value="364.4271844660193"/>
      <Option name="component_pos_y" type="double" value="378.4077669902912"/>
      <Option name="dependencies" type="StringList">
        <Option type="QString" value="native:meancoordinates_1"/>
      </Option>
      <Option name="id" type="QString" value="qgis:fieldcalculator_1"/>
      <Option name="outputs"/>
      <Option name="outputs_collapsed" type="bool" value="true"/>
      <Option name="parameters_collapsed" type="bool" value="true"/>
      <Option name="params" type="Map">
        <Option name="FIELD_LENGTH" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="10"/>
          </Option>
        </Option>
        <Option name="FIELD_NAME" type="List">
          <Option type="Map">
            <Option name="expression" type="QString" value="  concat( @fieldnameprefix , 'Dist')"/>
            <Option name="source" type="int" value="3"/>
          </Option>
        </Option>
        <Option name="FIELD_PRECISION" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="0"/>
          </Option>
        </Option>
        <Option name="FIELD_TYPE" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="0"/>
          </Option>
        </Option>
        <Option name="FORMULA" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="QString" value="distance( centroid($geometry),  make_point(  @Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy ))"/>
          </Option>
        </Option>
        <Option name="INPUT" type="List">
          <Option type="Map">
            <Option name="parameter_name" type="QString" value="inputfeatures"/>
            <Option name="source" type="int" value="0"/>
          </Option>
        </Option>
        <Option name="NEW_FIELD" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="bool" value="true"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option name="qgis:fieldcalculator_2" type="Map">
      <Option name="active" type="bool" value="true"/>
      <Option name="alg_config"/>
      <Option name="alg_id" type="QString" value="qgis:fieldcalculator"/>
      <Option name="component_description" type="QString" value="Field calculator (direction)"/>
      <Option name="component_pos_x" type="double" value="365.4368932038835"/>
      <Option name="component_pos_y" type="double" value="460.6990291262136"/>
      <Option name="dependencies"/>
      <Option name="id" type="QString" value="qgis:fieldcalculator_2"/>
      <Option name="outputs" type="Map">
        <Option name="Direction Distance Output" type="Map">
          <Option name="child_id" type="QString" value="qgis:fieldcalculator_2"/>
          <Option name="component_description" type="QString" value="Direction Distance Output"/>
          <Option name="component_pos_x" type="double" value="368.77669902912635"/>
          <Option name="component_pos_y" type="double" value="532.7281553398058"/>
          <Option name="default_value" type="invalid"/>
          <Option name="mandatory" type="bool" value="false"/>
          <Option name="name" type="QString" value="Direction Distance Output"/>
          <Option name="output_name" type="QString" value="OUTPUT"/>
        </Option>
      </Option>
      <Option name="outputs_collapsed" type="bool" value="true"/>
      <Option name="parameters_collapsed" type="bool" value="true"/>
      <Option name="params" type="Map">
        <Option name="FIELD_LENGTH" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="10"/>
          </Option>
        </Option>
        <Option name="FIELD_NAME" type="List">
          <Option type="Map">
            <Option name="expression" type="QString" value="concat( @fieldnameprefix, 'Dir')"/>
            <Option name="source" type="int" value="3"/>
          </Option>
        </Option>
        <Option name="FIELD_PRECISION" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="3"/>
          </Option>
        </Option>
        <Option name="FIELD_TYPE" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="int" value="0"/>
          </Option>
        </Option>
        <Option name="FORMULA" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="QString" value="degrees(azimuth( make_point(@Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy ),  centroid($geometry)))&#xd;&#xa;"/>
          </Option>
        </Option>
        <Option name="INPUT" type="List">
          <Option type="Map">
            <Option name="child_id" type="QString" value="qgis:fieldcalculator_1"/>
            <Option name="output_name" type="QString" value="OUTPUT"/>
            <Option name="source" type="int" value="1"/>
          </Option>
        </Option>
        <Option name="NEW_FIELD" type="List">
          <Option type="Map">
            <Option name="source" type="int" value="2"/>
            <Option name="static_value" type="bool" value="true"/>
          </Option>
        </Option>
      </Option>
    </Option>
  </Option>
  <Option name="help"/>
  <Option name="modelVariables"/>
  <Option name="model_group" type="QString" value="Middlebury"/>
  <Option name="model_name" type="QString" value="Distance and Direction from Point"/>
  <Option name="parameterDefinitions" type="Map">
    <Option name="citycenters" type="Map">
      <Option name="data_types" type="List">
        <Option type="int" value="5"/>
      </Option>
      <Option name="default" type="invalid"/>
      <Option name="description" type="QString" value="City Center"/>
      <Option name="flags" type="int" value="0"/>
      <Option name="metadata"/>
      <Option name="name" type="QString" value="citycenters"/>
      <Option name="parameter_type" type="QString" value="source"/>
    </Option>
    <Option name="fieldnameprefix" type="Map">
      <Option name="default" type="QString" value="cbd"/>
      <Option name="description" type="QString" value="Field Name Prefix"/>
      <Option name="flags" type="int" value="0"/>
      <Option name="metadata"/>
      <Option name="multiline" type="bool" value="false"/>
      <Option name="name" type="QString" value="fieldnameprefix"/>
      <Option name="parameter_type" type="QString" value="string"/>
    </Option>
    <Option name="inputfeatures" type="Map">
      <Option name="data_types" type="List">
        <Option type="int" value="2"/>
      </Option>
      <Option name="default" type="invalid"/>
      <Option name="description" type="QString" value="Input Features"/>
      <Option name="flags" type="int" value="0"/>
      <Option name="metadata"/>
      <Option name="name" type="QString" value="inputfeatures"/>
      <Option name="parameter_type" type="QString" value="vector"/>
    </Option>
    <Option name="qgis:fieldcalculator_2:Direction Distance Output" type="Map">
      <Option name="create_by_default" type="bool" value="true"/>
      <Option name="data_type" type="int" value="-1"/>
      <Option name="default" type="invalid"/>
      <Option name="description" type="QString" value="Direction Distance Output"/>
      <Option name="flags" type="int" value="0"/>
      <Option name="metadata"/>
      <Option name="name" type="QString" value="qgis:fieldcalculator_2:Direction Distance Output"/>
      <Option name="parameter_type" type="QString" value="sink"/>
      <Option name="supports_non_file_outputs" type="bool" value="true"/>
    </Option>
  </Option>
  <Option name="parameters" type="Map">
    <Option name="citycenters" type="Map">
      <Option name="component_description" type="QString" value="citycenters"/>
      <Option name="component_pos_x" type="double" value="484.66019417475724"/>
      <Option name="component_pos_y" type="double" value="122.09708737864077"/>
      <Option name="name" type="QString" value="citycenters"/>
    </Option>
    <Option name="fieldnameprefix" type="Map">
      <Option name="component_description" type="QString" value="fieldnameprefix"/>
      <Option name="component_pos_x" type="double" value="127.72815533980588"/>
      <Option name="component_pos_y" type="double" value="458.9126213592234"/>
      <Option name="name" type="QString" value="fieldnameprefix"/>
    </Option>
    <Option name="inputfeatures" type="Map">
      <Option name="component_description" type="QString" value="inputfeatures"/>
      <Option name="component_pos_x" type="double" value="122.09708737864071"/>
      <Option name="component_pos_y" type="double" value="302.9126213592232"/>
      <Option name="name" type="QString" value="inputfeatures"/>
    </Option>
  </Option>
</Option>

[Back to Main Page](https://pdickson2.github.io/)
