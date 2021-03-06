create table if not exists ${AQTS_SCHEMA_NAME}.time_series_description
(time_series_description_id              bigint generated by default as identity (start with 1)
,time_series_unique_id                   character varying (32)
,utc_offset                              smallint
,unit                                    text
,label                                   text
,parameter                               text
,parm_cd                                 text
,stat_cd                                 text
,last_modified                           timestamp
,corrected_start_time                    timestamp
,corrected_end_time                      timestamp
,location_identifier                     text
,computation_period_identifier           text
,response_time                           timestamp
,response_version                        integer
,primary key (time_series_description_id)
,constraint time_series_description_ak unique (time_series_unique_id)
);
