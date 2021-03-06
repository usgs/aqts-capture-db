create table if not exists ${AQTS_SCHEMA_NAME}.datum_converted_values
(datum_converted_values_id                bigint generated by default as identity (start with 1),
json_data_id                              bigint,
field_visit_identifier                    text,
target_datum                              text,
unit                                      text,
display_value                             text,
partition_number                          integer,
primary key (datum_converted_values_id, partition_number)
)
partition by list (partition_number);
