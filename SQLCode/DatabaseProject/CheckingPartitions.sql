SELECT
 f.NAME													 AS file_group_name
, SCHEMA_NAME(t.schema_id)								 AS table_schema
, t.name												 AS table_name
, p.partition_number
, ISNULL(CAST(left_prv.value AS VARCHAR(MAX)) +
											   CASE
														 WHEN pf.boundary_value_on_right = 0
															 THEN
																 ' < '
														 ELSE
															 ' <= '
											   END, '-INF < ')
 + 'X' + ISNULL(CASE
		   WHEN pf.boundary_value_on_right = 0
			   THEN
				   ' <= '
		   ELSE
			   ' < '
 END + CAST(right_prv.value AS NVARCHAR(MAX)), ' < INF') AS range_desc
, pf.boundary_value_on_right
, ps.name												 AS partition_schem_name
, pf.name												 AS partition_function_name
, left_prv.value										 AS left_boundary
, right_prv.value										 AS right_boundary
FROM
sys.partitions p
	JOIN
	sys.tables t
		ON
			p.object_id = t.object_id
	JOIN
	sys.indexes i
		ON
			p.object_id = i.object_id
			AND
			p.index_id = i.index_id
	JOIN
	sys.allocation_units au
		ON
			p.hobt_id = au.container_id
	JOIN
	sys.filegroups f
		ON
			au.data_space_id = f.data_space_id
	LEFT JOIN
	sys.partition_schemes ps
		ON
			ps.data_space_id = i.data_space_id
	LEFT JOIN
	sys.partition_functions pf
		ON
			ps.function_id = pf.function_id
	LEFT JOIN
	sys.partition_range_values left_prv
		ON
			left_prv.function_id = ps.function_id
			AND
			left_prv.boundary_id + 1 = p.partition_number
	LEFT JOIN
	sys.partition_range_values right_prv
		ON
			right_prv.function_id = ps.function_id
			AND
			right_prv.boundary_id = p.partition_number;


SELECT DISTINCT
 o.name	   AS table_name
, rv.value AS partition_range
, fg.name  AS file_groupName
, p.partition_number
, p.rows   AS number_of_rows
FROM
sys.partitions p
	INNER JOIN
	sys.indexes i
		ON
			p.object_id = i.object_id
			AND
			p.index_id = i.index_id
	INNER JOIN
	sys.objects o
		ON
			p.object_id = o.object_id
	INNER JOIN
	sys.system_internals_allocation_units au
		ON
			p.partition_id = au.container_id
	INNER JOIN
	sys.partition_schemes ps
		ON
			ps.data_space_id = i.data_space_id
	INNER JOIN
	sys.partition_functions f
		ON
			f.function_id = ps.function_id
	INNER JOIN
	sys.destination_data_spaces dds
		ON
			dds.partition_scheme_id = ps.data_space_id
			AND
			dds.destination_id = p.partition_number
	INNER JOIN
	sys.filegroups fg
		ON
			dds.data_space_id = fg.data_space_id
	LEFT OUTER JOIN
	sys.partition_range_values rv
		ON
			f.function_id = rv.function_id
			AND
			p.partition_number = rv.boundary_id
WHERE
	  o.object_id = OBJECT_ID('TblCY');