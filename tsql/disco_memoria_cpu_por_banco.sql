--CPU
WITH DB_CPU_Stats
AS
(SELECT DatabaseID, DB_Name(DatabaseID) AS db, SUM(total_worker_time) AS [CPU_Time_Ms]
 FROM sys.dm_exec_query_stats AS qs
 CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID] 
              FROM sys.dm_exec_plan_attributes(qs.plan_handle)
              WHERE attribute = N'dbid') AS F_DB
 GROUP BY DatabaseID)
SELECT @@servername server, ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num],
       db, [CPU_Time_Ms], 
       CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUPercent]
FROM DB_CPU_Stats
WHERE DatabaseID > 4 -- system databases
AND DatabaseID <> 32767 -- ResourceDB
ORDER BY row_num OPTION (RECOMPILE);

--Regarding CPU see above script
 --Which DBs are consuming most Buffer Cache
SELECT @@servername server, db_name(database_id) as db,
       count(page_id)  as pages,
   convert(decimal(20,2),count(page_id)*8192.0/1048576) as Mb
from sys.dm_os_buffer_descriptors
group by database_id
order by convert(decimal(20,2),count(page_id)*8192.0/1048576) desc
go

--Disk
WITH DBIO AS
(
 SELECT
   DB_NAME(IVFS.database_id) AS db,
   CASE WHEN MF.type = 1 THEN 'log' ELSE 'data' END AS file_type,
   SUM(IVFS.num_of_bytes_read +IVFS.num_of_bytes_written) AS io,
   SUM(IVFS.io_stall) AS io_stall
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS IVFS
   JOIN sys.master_files AS MF
     ON IVFS.database_id = MF.database_id
     AND IVFS.file_id = MF.file_id
 GROUP BY DB_NAME(IVFS.database_id), MF.type
)
SELECT @@servername server, db, file_type,
  CAST(1. *io/ (1024 *1024) AS DECIMAL(12, 2))AS io_mb,
  CAST(io_stall /1000. AS DECIMAL(12,2))AS io_stall_s,
  CAST(100.*io_stall / SUM(io_stall)OVER()
       AS DECIMAL(10,2))AS io_stall_pct,
  ROW_NUMBER()OVER(ORDER BY io_stall DESC) AS rn
FROM DBIO
ORDER BY io_stall DESC;

