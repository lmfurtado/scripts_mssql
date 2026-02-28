use master 
if exists (select * from sys.tables where name = 'tabela_lucas')
	drop table tabela_lucas;
--BANCO, hora , cliente , usuario , loja , data, count(*) qtde	
create table tabela_lucas(banco varchar(30), loja int, saldo_inventario int, saldo int, produtos int)
go

declare @texto nvarchar(max);
declare ponteiro cursor 
for 
	select concat('if exists (select * from [', name, '].sys.objects where name = ''cep'')begin try use [', name, 
		'] 
		insert into master.dbo.tabela_lucas (banco, loja, saldo_inventario, saldo, produtos) 		
		select 
			db_name() banco, 
			codigo, 
			(select count(*) from saldo_inventario s where loja = codigo and ano = 2019) as saldo_inventario,
			(select count(*) from saldo s where loja = codigo) as saldo, 
			(select count(*) from produto p where datacadastro > ''20191231'' ) produtos_ate_2019
		from loja

		'-- troque o conteudo dessa linha pelo select. é bom manter o db_name() no select para facilitar 
		+' end try begin catch end catch; ' 
		) 
	from sys.databases where state_desc = 'online' and name not like '%TESTE%'
	order by name
open ponteiro 
fetch ponteiro into @texto
while (@@fetch_status = 0)
begin
	execute sp_executesql  @texto; 
	fetch next from ponteiro into @texto;		
end
close ponteiro;
deallocate ponteiro;
go	

select *, saldo_inventario - saldo
from tabela_lucas
where saldo_inventario < saldo
and banco != 'HUMANITARIAN_852' and (saldo_inventario - saldo) < -500


select *, saldo - saldo_inventario
from tabela_lucas
where saldo_inventario > saldo
and banco != 'HUMANITARIAN_852' and saldo > 0 