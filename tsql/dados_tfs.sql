/*
CREATE TABLE TAREFAS(
	id	int, 
	STATUS varchar(max),	
	MOVIDESK	 int,
	TRIAGE		 varchar(max),
	esteira		 varchar(max),
	versao		 varchar(max),
	Branch		 varchar(max),
	DevInicial	 varchar(max),
	HsDev		 float,
	HsTeste		 varchar(max),
	resp		 varchar(max),
	DATA		 datetime)*/

begin tran
delete from tarefas; 

insert TAREFAS
SELECT 
ID,STATUS ,MOVIDESK,TRIAGE,Esteira,Versao,Branch,DevInicial,HsDev,HsTeste,Resp, DATA 
FROM 
  (SELECT
        i.id,
        state as STATUS ,
        coalesce((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where FIELDID = 10426 AND u.id = i.Id ), '') AS MOVIDESK,
        coalesce((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where FIELDID = 10009 AND u.id = i.Id ), '') AS TRIAGE,
        coalesce((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10396), '') as esteira,
        coalesce ((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10425), '') versao,
        coalesce ((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10424), '') Branch,
        coalesce ((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10439), '') DevInicial,
        coalesce ((select u.FloatValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10020), '') HsDev,
        coalesce ((select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u (nolock) where u.id = i.Id and FieldId = 10016), '') HsTeste,
        coalesce(x.NamePart , '') as resp, 
        (select top 1 data from
					  ( select d.ChangedDate as data , d.State status , d.id , d.rev from 
                        tbl_WorkItemCoreWere d , tbl_WorkItemCoreLatest t where d.workitemtype = 'Task'
                        and t.Id = i.Id and t.Id = d.Id and t.IsDeleted <> 1 and d.Rev > coalesce((select max(coalesce(d.rev , 0))
						from 
                        tbl_WorkItemCoreWere d , tbl_WorkItemCoreLatest t where d.workitemtype = 'Task'
                        and t.Id = i.Id and t.Id = d.Id and t.IsDeleted <> 1 and d.Reason = 'Reactivated'),0)
						union all
						select ChangedDate as data , State status , id , rev from 
                        tbl_WorkItemCoreLatest d where  workitemtype = 'Task'
                        and d.Id = i.Id and IsDeleted <> 1		) t		where status = 'Closed'
                        order by rev ) as data

      from 
          Tfs_USECollection.dbo.tbl_WorkItemCoreLatest i (nolock)
          OUTER APPLY (  
            Select TOP 1 words from Tfs_USECollection.dbo.WorkItemLongTexts where id = i.Id ORDER BY textid DESC
          ) m
          left join Tfs_USECollection.dbo.Constants  x (nolock) on x.ConstID = i.AssignedTo where IsDeleted <> 1 
            and (select StringValue from Tfs_USECollection.dbo.tbl_WorkItemCustomLatest u(nolock) where u.id = i.Id and FieldId = 10426) is not NULL
      AND state = 'Closed')x
  
  WHERE(x.DATA >= '20201123' AND X.DATA >= DATEADD(DAY, -30, GETDATE())) AND x.MOVIDESK <> ''
commit;


select * from TAREFAS