create or replace function ${AQTS_SCHEMA_NAME}.adjust_timestamp(timestamp_text character varying)
returns timestamp
language plpgsql
as $$
declare
  adjusted_timestamp timestamp;
begin
  case
    when substring(timestamp_text from '[T,\s](.*)[-,+]') = '24:00:00.0000000'
      /* Daily Values with HH of 24 are statitical for that day. Use only the date portion to prevent PostgreSQL
         from moving them to the next day. */
      then
        adjusted_timestamp = to_timestamp(substring(timestamp_text from '(.*)[T,\s]'), 'YYYY-MM-DD');
    when substring(timestamp_text from '\.([^-+]*)[-+]?') = '9999999'
      /* AQTS has 7 digit precision for fractional seconds. Drop the last 9 of a max value to prevent
         rounding to the next microsecond and possibly day. */
      then
        adjusted_timestamp = replace(timestamp_text, '9999999', '999999')::timestamptz at time zone 'UTC';
    else
      adjusted_timestamp = timestamp_text::timestamptz at time zone 'UTC';
    end case;
    return adjusted_timestamp;
end
$$