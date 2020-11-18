create or replace function ${AQTS_SCHEMA_NAME}.trigger_set_timestamp()
returns trigger as $$
begin
  new.updated_at = NOW();
  return new;
end;
$$ language plpgsql;
