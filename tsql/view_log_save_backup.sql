declare @tab table (LogDate datetime, ProcessInfo varchar(50), Text varchar(max))
insert into @tab EXEC sp_readerrorlog

select 
	LogDate,
	ProcessInfo,
	Text
from 
	@tab 
where 
	ProcessInfo != 'Backup' and 
	Text not like 'I/O was resumed%' and 
	Text not like 'I/O is frozen%' and
	Text not like '%misaligned log IOs%' and 
	Text not like '%Login succeeded%' and 
	Text not like 'I/O is frozen%' and
	Text not like '%FlushCache%' and 
	Text not like '%average throughput%' and 
	Text not like '%last target outstanding%' and 
	LogDate > getdate() - 1
order by 
	logdate desc