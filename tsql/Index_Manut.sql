
/*
ALTER INDEX ALL ON TRANSFERENCIABAIXOU REBUILD ;    
GO
ALTER INDEX ALL ON MARCA REBUILD ;    
GO
ALTER INDEX ALL ON ITEMFAIXAJUROS REBUILD ;    
GO
ALTER INDEX ALL ON CONTAREC REBUILD ;    
GO
ALTER INDEX ALL ON CLIENTE REBUILD ;    
GO
ALTER INDEX ALL ON ITEMVENDA REBUILD ;    
GO
ALTER INDEX ALL ON VENDA REBUILD ;    
GO
ALTER INDEX ALL ON PRODUTOREGIAO REBUILD ;    
GO
ALTER INDEX ALL ON PRODUTO REBUILD ;    
GO
*/

-- View Index Fragmentation
SELECT
	OBJECT_NAME(i.object_id) AS TableName, 
	i.name AS IndexName, 
	cast(indexstats.avg_fragmentation_in_percent as numeric(15,3)) avg_fragmentation_in_percent, 
	indexstats.page_count, 
	indexstats.record_count,
	concat('alter index ',i.name,' on ', object_name(i.object_id), ' rebuild') comando
FROM 
	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') indexstats INNER JOIN 
	sys.indexes i ON i.OBJECT_ID = indexstats.OBJECT_ID
		AND i.index_id = indexstats.index_id
		AND avg_fragmentation_in_percent > 30 
		AND record_count > 1000
order by 
	avg_fragmentation_in_percent desc
	
	
--CUIDADO EM RODAR ISSO!!!! O BANCO FICA BASICAMENTE OFFLINE
--sp_msforeachtable 'ALTER INDEX ALL ON ? REBUILD ; '