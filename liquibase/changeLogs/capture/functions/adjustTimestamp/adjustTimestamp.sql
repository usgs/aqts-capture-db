create or replace function ${AQTS_SCHEMA_NAME}.adjust_timestamp(timestamp_text character varying)
returns timestamp
language plpgsql
as $$
declare
  adjusted_timestamp timestamp;
begin
  case

    -- when 2400 time, 
    -- then keep the date only and convert to UTC (though with date only you won't notice UTC...)
    when substring(timestamp_text from '[T,\s](.*)[-,+]') = '24:00:00.0000000'
      /* Daily Values with HH of 24 are statitical for that day. Use only the date portion to prevent PostgreSQL
         from moving them to the next day. */
      then
        adjusted_timestamp = to_timestamp(substring(timestamp_text from '(.*)[T,\s]'), 'YYYY-MM-DD');

    -- when fractional seconds is 9999999, 
    -- then trim to 6 digits and convert to UTC timestamptz
    when substring(timestamp_text from '\.([^-+]*)[-+]?') = '9999999'
      /* AQTS has 7 digit precision for fractional seconds. Drop the last 9 of a max value to prevent
         rounding to the next microsecond and possibly day. */
      then
        adjusted_timestamp = replace(timestamp_text, '9999999', '999999')::timestamptz at time zone 'UTC';

    -- when fractional seconds is 0000000, 
    -- then convert to UTC timestamptz, which will trim one of the 0s when postgres rounds to 6 digits.
    when substring(timestamp_text from '\.([^-+]*)[-+]?') = '0000000'
      then 
        adjusted_timestamp = timestamp_text::timestamptz at time zone 'UTC';

    -- in all other cases
    -- convert to UTC timestamptz (postgres trims the 7th digit, if present, through rounding), 
    -- then increment the remaining 6 digit value by one microsecond
    else
      adjusted_timestamp = timestamp_text::timestamptz at time zone 'UTC' + interval '0.000001' second;

    end case;
    return adjusted_timestamp;
end
$$