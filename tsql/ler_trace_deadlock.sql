declare @tabela_xml table (_xml xml)

insert @tabela_xml
select top 30 cast(event_data as xml) _xml
from fn_xe_file_target_read_file('C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Log\Deadlock*.xel', null, null, null)
order by timestamp_utc desc

select 
	_xml.value('(/event/data/value/deadlock/process-list/process/@lasttranstarted)[1]', 'datetime') _hora,
	_xml,
	_xml.value('(/event/data/value/deadlock/process-list/process/inputbuf)[1]', 'varchar(max)') _comando1,
	_xml.value('(/event/data/value/deadlock/process-list/process/inputbuf)[2]', 'varchar(max)') _comando2,
	_xml.value('(/event/data/value/deadlock/resource-list/keylock/@objectname)[1]', 'varchar(max)') _tabela1,
	coalesce(
		_xml.value('(/event/data/value/deadlock/resource-list/pagelock/@objectname)[1]', 'varchar(max)'), 
		_xml.value('(/event/data/value/deadlock/resource-list/keylock/@objectname)[2]', 'varchar(max)'),
		_xml.value('(/event/data/value/deadlock/resource-list/objectlock/@objectname)[1]', 'varchar(max)')
	) _tabela2
from @tabela_xml