select * from all_objects
where object_name like '%PAIGN%'


select owner, object_type, object_name, object_id, created, timestamp, status
from all_objects
where object_name like '%PAIGN%' 
  and object_type not in ('SEQUENCE','INDEX')
order by object_type, object_name  



select count(*) 
from DAI.CAMPAIGN