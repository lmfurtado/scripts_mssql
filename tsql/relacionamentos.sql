declare @tabela_pai varchar(50) = 'cliente';
declare @tabela_filha varchar(50) = '';

select * from (
	select 
		object_name(referenced_object_id) as tabela_pai,
		object_name(parent_object_id) as tabela_filha, 
		object_name(object_id) as chave_estrangeira
	from sys.foreign_keys) t
where 
	(@tabela_pai = tabela_pai or @tabela_pai = '') and
	(@tabela_filha = tabela_filha or @tabela_filha = '')

	order by 2