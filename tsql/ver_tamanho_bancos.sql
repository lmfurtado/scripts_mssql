SELECT 
      database_name = DB_NAME(database_id)
    , log_size_mb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
	, total_all_db_mb = (SUM(CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))) OVER (ORDER BY DB_NAME(database_id)))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id in (select database_id from sys.database_mirroring where mirroring_guid is null)
GROUP BY database_id
ORDER BY DB_NAME(database_id)