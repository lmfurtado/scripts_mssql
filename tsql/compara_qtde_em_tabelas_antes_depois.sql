/*
drop table tabela1 ;
drop table tabela2 ;
*/

create table tabela1 (nometabela varchar(50), total int)
go
sp_msforeachtable 'insert into tabela1 select ''?'', count(*) from ?'

--RODE O PROCESSO ANTES DE RODAR O RESTO!
--EX1: INSERT INTO COR (LOJA, DESCRICAO) VALUES (1, NULL)
--EX2: CREATE TABLE KKKPAROU (ID INT)


create table tabela2 (nometabela varchar(50), total int)
go
sp_msforeachtable 'insert into tabela2 select ''?'', count(*) from ?'


select t1.nometabela, t2.nometabela, t1.total antes, t2.total depois
from tabela1 t1 full join tabela2 t2 on t1.nometabela = t2.nometabela
where coalesce(t1.total, 0) != coalesce(t2.total, 0) and coalesce(t1.nometabela, '') not like '%tabela%'
order by 1

drop table tabela1 ;
drop table tabela2 ;
