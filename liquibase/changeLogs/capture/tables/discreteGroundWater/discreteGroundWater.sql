create unlogged table if not exists ${AQTS_SCHEMA_NAME}.discrete_ground_water
(discrete_ground_water_id  bigint generated by default as identity (start with 1)
,field_visit_identifier                  text
,location_identifier                     text
,start_time                              timestamp
,end_time                                timestamp
,party                                   text
,remarks                                 text
,weather                                 text
,is_valid_header_info                    text
,completed_work                          text
,last_modified                           timestamp
,parameter                               text
,monitoring_method                       text
,field_visit_value                       text
,unit                                    text
,uncertainty                             text
,reading_type                            text
,manufacturer                            text
,model                                   text
,serial_number                           text
,field_visit_time                        timestamp
,field_visit_comments                    text
,publish                                 text
,is_valid_readings                       text
,reference_point_unique_id               text
,use_location_datum_as_reference         text
,reading_qualifier                       text
,reading_qualifiers                      text
,ground_water_measurement                text
,primary key (discrete_ground_water_id)
,constraint discrete_ground_water_ak unique (field_visit_identifier,location_identifier,parameter,monitoring_method,field_visit_time)
);
