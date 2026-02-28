use master 
if exists (select * from sys.tables where name = 'tabela_lucas')
	drop table tabela_lucas;
create table tabela_lucas(banco varchar(max), chave varchar(max), comando varchar(max))
go

declare @texto nvarchar(max);
declare ponteiro cursor 
for 
	select concat('if exists (select * from [', name, '].dbo.sysobjects where xtype=''u'' and name = ''log'')begin try use [', name,'] 
		insert into master.dbo.tabela_lucas 
		
SELECT 
	db_name() banco, 
	''['' + s.name + ''].['' + o.name + ''].['' + i.name + '']'' AS keyname, 
	concat(''alter table'', ''['' , s.name , ''].'',o.name, '' with check check constraint '', i.name) comando_acertar
FROM    sys.foreign_keys i
        INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
        INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE   i.is_not_trusted = 1
        AND i.is_not_for_replication = 0
        AND i.is_disabled = 0
ORDER BY 3
		 end try begin catch end catch; ') 
	from sys.databases where state_desc = 'online' and database_id > 4
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

select  concat('use ', banco, ' ', comando, ';') from tabela_lucas



/*
DELETE FROM ESTOQUELANCAMENTO WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = ESTOQUELANCAMENTO.PRODUTOLOJA AND P.CODIGO = ESTOQUELANCAMENTO.PRODUTO)
DELETE FROM PRODUTOREGIAO WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM SALDO WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM ITEMINVENTARIO WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM SALDO_INVENTARIO WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM ITEMPED WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM ITEMPED WHERE NOT EXISTS (SELECT * FROM PEDIDO P WHERE P.LOJAEMI = PEDIDOLOJA AND P.CODIGO = ITEMPED.PEDIDO)
DELETE FROM ITEMVENDA WHERE NOT EXISTS (SELECT * FROM VENDA P WHERE P.LOJA = VENDALOJA AND P.CODIGO = VENDA)
DELETE FROM CONTAREC WHERE NOT EXISTS (SELECT * FROM VENDA P WHERE P.LOJA = VENDALOJA AND P.CODIGO = VENDA)
DELETE FROM ITEMPEDIDOVENDA WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM CONTAGEM WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM MOVIMENTOCONTAGEM WHERE NOT EXISTS (SELECT * FROM PRODUTO P WHERE P.LOJA = PRODUTOLOJA AND P.CODIGO = PRODUTO)
DELETE FROM PRODUTOREGIAO WHERE NOT EXISTS (SELECT * FROM PRECOREGIAO P WHERE P.CODIGO = PRODUTOREGIAO.PRODUTOREGIAO)
DELETE FROM CONTAGEM WHERE LOJA NOT IN (SELECT CODIGO FROM LOJA)
UPDATE VENDA SET OPERADOR = 26 WHERE NOT EXISTS (SELECT * FROM OPERADOR P WHERE P.LOJA = OPERADORLOJA AND P.CODIGO = OPERADOR)
UPDATE CONTAREC SET OPERADORBAIXA = 26, OPERADORBAIXALOJA = 1 WHERE NOT EXISTS (SELECT * FROM OPERADOR P WHERE P.LOJA = OPERADORBAIXALOJA AND P.CODIGO = OPERADORBAIXA)
UPDATE ACERTO SET MOTESTOQUE = 1, MOTESTOQUELOJA = 1 WHERE MOTESTOQUE NOT IN (SELECT CODIGO FROM MOTESTOQUE)
UPDATE VENDA SET CLIENTE = NULL WHERE NOT EXISTS (SELECT * FROM cliente c where c.loja = clienteloja and c.codigo = cliente)
UPDATE contarec SET CLIENTE = NULL WHERE NOT EXISTS (SELECT * FROM cliente c where c.loja = clienteloja and c.codigo = cliente)
UPDATE PEDIDOVENDA SET venda = NULL WHERE NOT EXISTS (SELECT * FROM venda c where c.loja = vendaloja and c.codigo = venda)
UPDATE BONUS SET venda = NULL WHERE NOT EXISTS (SELECT * FROM venda c where c.loja = vendaloja and c.codigo = venda)
UPDATE MOVIMENTOEST SET PEDIDO = NULL WHERE NOT EXISTS (SELECT * FROM PEDIDO P WHERE P.LOJAEMI = PEDIDOLOJA AND P.CODIGO = MOVIMENTOEST.PEDIDO)

delete from produto where grade not in (select codigo from grade)

set identity_insert colecao on
insert colecao (loja, codigo, descricao)
select distinct colecaoloja, colecao, 'AJUSTE MANUAL DS'
from grade where not exists (select * from colecao c where c.loja = colecaoloja and c.codigo = colecao ) and colecao is not null
set identity_insert colecao off


*/