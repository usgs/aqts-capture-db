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

	/* recreate the indexes */
	/* json_data */
	execute format('create unique index if not exists json_data_%s_json_data_id on %I.json_data_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_approvals */
	execute format('create unique index if not exists time_series_approvals_%s_time_series_approvals_id on %I.time_series_approvals_%s (time_series_approvals_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_approvals_%s_json_data_id on %I.time_series_approvals_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_gap_tolerances */
	execute format('create unique index if not exists time_series_gap_tolerances_%s_time_series_gap_tolerances_id on %I.time_series_gap_tolerances_%s (time_series_gap_tolerances_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_gap_tolerances_%s_json_data_id on %I.time_series_gap_tolerances_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_grades */
	execute format('create unique index if not exists time_series_grades_%s_time_series_grades_id on %I.time_series_grades_%s (time_series_grades_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_grades_%s_json_data_id on %I.time_series_grades_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_header_info */
	execute format('create unique index if not exists time_series_header_info_%s_time_series_header_info_id on %I.time_series_header_info_%s (time_series_header_info_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create unique index if not exists time_series_header_info_%s_ak on %I.time_series_header_info_%s (json_data_id, time_series_unique_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_header_info_%s_time_series_unique_id on %I.time_series_header_info_%s (time_series_unique_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_interpolation_types */
	execute format('create unique index if not exists time_series_interpolation_types_%s_time_series_interpolation_types_id on %I.time_series_interpolation_types_%s (time_series_interpolation_types_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_interpolation_types_%s_json_data_id on %I.time_series_interpolation_types_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_methods */
	execute format('create unique index if not exists time_series_methods_%s_time_series_methods_id on %I.time_series_methods_%s (time_series_methods_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_methods_%s_json_data_id on %I.time_series_methods_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_points */
	execute format('create unique index if not exists time_series_points_%s_time_series_points_id on %I.time_series_points_%s (time_series_points_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create unique index if not exists time_series_points_%s_ak on %I.time_series_points_%s (json_data_id, time_step)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

	/* time_series_qualifiers */
	execute format('create unique index if not exists time_series_qualifiers_%s_time_series_qualifiers_id on %I.time_series_qualifiers_%s (time_series_qualifiers_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);
	execute format('create index if not exists time_series_qualifiers_%s_json_data_id on %I.time_series_qualifiers_%s (json_data_id)', month_name, '${AQTS_SCHEMA_NAME}', month_name);

end
$$