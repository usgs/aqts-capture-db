create or replace function ${AQTS_SCHEMA_NAME}.prune_time_series_data(pruneDate date)
returns void
language plpgsql
as $$
declare
	month_number integer := extract( month from pruneDate );
	month_name varchar := trim(to_char(pruneDate, 'month'));
begin

	/* drop the partitions */
	execute format('drop table if exists %I.json_data_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_approvals_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_gap_tolerances_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_grades_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_header_info_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_interpolation_types_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_methods_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_points_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.time_series_qualifiers_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.field_visit_header_info_%s', '${AQTS_SCHEMA_NAME}', month_name);
	execute format('drop table if exists %I.field_visit_readings_%s', '${AQTS_SCHEMA_NAME}', month_name);

	/* recreate the partitions */
	execute format('create table if not exists %I.json_data_%s partition of %I.json_data for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_approvals_%s partition of %I.time_series_approvals for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_gap_tolerances_%s partition of %I.time_series_gap_tolerances for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_grades_%s partition of %I.time_series_grades for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_header_info_%s partition of %I.time_series_header_info for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_interpolation_types_%s partition of %I.time_series_interpolation_types for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_methods_%s partition of %I.time_series_methods for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_points_%s partition of %I.time_series_points for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.time_series_qualifiers_%s partition of %I.time_series_qualifiers for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.field_visit_header_info_%s partition of %I.field_visit_header_info for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.field_visit_readings_%s partition of %I.field_visit_readings for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.field_visit_readings_%s partition of %I.field_visit_readings_by_loc for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);
	execute format('create table if not exists %I.field_visit_readings_%s partition of %I.datum_converted_values for values in (%L)', '${AQTS_SCHEMA_NAME}', month_name, '${AQTS_SCHEMA_NAME}', month_number);

end
$$