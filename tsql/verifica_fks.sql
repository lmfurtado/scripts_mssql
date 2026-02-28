 select 
	(select top 1 name from sys.objects o where f.parent_object_id = o.object_id) as tablename, 
	name as foreign_key,
	delete_referential_action_desc as behaviour
 from sys.foreign_keys f
 where parent_object_id = (select OBJECT_ID from sys.objects where name = 'BONUS')
 order by 
	delete_referential_action_desc, name
