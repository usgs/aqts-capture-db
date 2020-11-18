create or replace trigger set_timestamp_discrete_ground_water
before update on ${AQTS_SCHEMA_NAME}.discrete_ground_water
for each row
execute procedure ${AQTS_SCHEMA_NAME}.trigger_set_timestamp();
