select 
	substring(substring(name, 7, len(name)), charindex('_', substring(name, 7, len(name)))+1, len(name)) name_alt,
	name, create_date, RANK() over (order by create_date) ordem_criacao
from sys.databases
where name like 'TESTE%'
order by substring(substring(name, 7, len(name)), charindex('_', substring(name, 7, len(name)))+1, len(name))