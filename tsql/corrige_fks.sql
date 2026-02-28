
--select * from sys.indexes where is_disabled = 1
--select * from sys.foreign_keys where is_disabled = 1



select 
concat('alter table ',object_name(parent_object_id),' check constraint ',object_name(object_id)) comando_acertar, *
from sys.foreign_keys with (nolock) where is_disabled = 1