create trigger set_timestamp_groundwater_statistical_daily_value
before update on ${AQTS_SCHEMA_NAME}.groundwater_statistical_daily_value
for each row
execute procedure ${AQTS_SCHEMA_NAME}.trigger_set_timestamp();
