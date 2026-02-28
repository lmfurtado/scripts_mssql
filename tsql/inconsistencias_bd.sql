--DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS
drop table #inconsistencias;

create table #inconsistencias (tab varchar(1000), con varchar(1000), whe varchar(1000)) 
declare @dbcc nvarchar(50) = 'DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS'
insert into #inconsistencias 
exec dbo.sp_executesql @dbcc

update #inconsistencias set con = replace(replace(con, '[', ''), ']', '') 

select * from #inconsistencias

select concat('delete from ',tab  COLLATE SQL_Latin1_General_CP1_CI_AS,' where ', whe  COLLATE SQL_Latin1_General_CP1_CI_AS) from #inconsistencias

select  
	tab as Tabela_Inconsistente, 
	substring(whe, 2, charindex(']',whe)-2) as Referencia_Faltando
from #inconsistencias

select 
	i.tab as _Tabela_Inconsistente, 
	object_name(fk.referenced_object_id) _Referencia_Faltando,
	whe as _Where
from sys.foreign_keys fk join #inconsistencias i on name COLLATE SQL_Latin1_General_CP1_CI_AS = con COLLATE SQL_Latin1_General_CP1_CI_AS 
