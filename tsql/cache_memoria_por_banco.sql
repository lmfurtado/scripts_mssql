
SELECT * FROM (
SELECT TOP 1000000 DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)],
COUNT(*) * 8/1048576.0 AS [Cached Size (GB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4 -- - exclude system databases
AND database_id <> 32767 -- exclude ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC) V
union all

SELECT 'TOTAL',
COUNT(*) * 8/1024.0 AS [Cached Size (MB)],
COUNT(*) * 8/1048576.0 AS [Cached Size (GB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4 -- - exclude system databases
AND database_id <> 32767 -- exclude ResourceDB