select * from user_synonyms
select * from DAI.CAMPAIGN

select *
from all_constraints
where owner = 'DAI_REPORTING_ODS'





select table_name, constraint_name, constraint_type
from ALL_CONSTRAINTS
where TABLE_NAME = 'CAMPAIGN'
  and owner = 'DAI'

select table_name, constraint_name, column_name, position
from ALL_CONS_COLUMNS
where TABLE_NAME = 'CAMPAIGN'
  and owner = 'DAI'


----- 06/01/2012:
select
  C.TABLE_NAME, CC.COLUMN_NAME, C.CONSTRAINT_NAME, C.CONSTRAINT_TYPE type, CC.POSITION POSN,
  C.STATUS,
  case when C.CONSTRAINT_TYPE = 'P' then 1
       when C.CONSTRAINT_TYPE = 'U' then 2
       when C.CONSTRAINT_TYPE = 'R' then 3
  else 3.0 end as oda
from ALL_CONSTRAINTS C, ALL_CONS_COLUMNS CC
where C.TABLE_NAME = CC.TABLE_NAME
  and C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME
  and c.owner = cc.owner
--  and C.TABLE_NAME = 'SCTE_REQUEST'
  and C.TABLE_NAME = 'SCTE_REQUEST_OPPORTUNITY'
  and C.OWNER = 'DAI_REPORTING_ODS'
order by 7, 1, 3



--select * from user_recyclebin
--purge user_recyclebin




select *
from SCTE_REQUEST
where LAST_ETL_PROC_NAME like '%2012-05-01%'


select unique message_id, SUBSTR(LAST_ETL_PROC_NAME, INSTR(LAST_ETL_PROC_NAME,'\',1,8)) FILE_NAME
from SCTE_REQUEST
order by 1



select distinct
 LAST_ETL_PROC_NAME,
 SUBSTR(LAST_ETL_PROC_NAME, INSTR(LAST_ETL_PROC_NAME,'\',1,8)) LONG_NAME,
 INSTR(LAST_ETL_PROC_NAME,'\',1,8) INSTR_LOC
from SCTE_REQUEST

select distinct
 LAST_ETL_PROC_NAME,
 SUBSTR(LAST_ETL_PROC_NAME, INSTR(LAST_ETL_PROC_NAME,'\',1,8)) LONG_NAME,
 INSTR(LAST_ETL_PROC_NAME,'\',1,8) INSTR_LOC
from SCTE_REQUEST_OPPORTUNITY


select
  SUBSTR(LAST_ETL_PROC_NAME, INSTR(LAST_ETL_PROC_NAME,'\',1,8)) LONG_NAME,
  count(request_message_id||opportunity_id) NUM_MSSG
from SCTE_REQUEST_OPPORTUNITY
group by SUBSTR(LAST_ETL_PROC_NAME, INSTR(LAST_ETL_PROC_NAME,'\',1,8))
order by 1


select *
from SCTE_REQUEST
--from SCTE_REQUEST_OPPORTUNITY
where last_etl_proc_name like '%\placement-requests.g.2012-03-22.xml'
order by 1, 2


select unique message_id
from SCTE_REQUEST
order by 1

