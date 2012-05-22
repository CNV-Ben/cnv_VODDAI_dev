select * from DBA_TAB_COLS where rownum < 21

select unique data_type
from DBA_TAB_COLS
where data_type not in ('NUMBER','VARCHAR2')
order by 1

select unique data_type, data_type_mod, data_length, data_precision, data_scale, default_length
from DBA_TAB_COLS
where data_type like 'AQ$%'
   or data_type like 'EXF$%'
   or data_type like 'KU$%'
   or data_type like 'RE$%'
   or data_type like 'RLM$%'
   or data_type like 'WM$%'
   or data_type like 'XDB$%'
order by 1

select unique owner, table_name, data_type, data_length
from DBA_TAB_COLS
where data_type like 'AQ$%'
   or data_type like 'EXF$%'
   or data_type like 'KU$%'
   or data_type like 'RE$%'
   or data_type like 'RLM$%'
   or data_type like 'WM$%'
   or data_type like 'XDB$%'
order by 3










select unique data_type, data_type_mod, data_length, data_precision, data_scale, default_length
from DBA_TAB_COLS
--where data_type = 'VARCHAR2'
where data_type not in ('NUMBER','VARCHAR2')






select
 owner, table_name, column_name, column_id, 
 case
  when data_type = 'NUMBER' and data_precision is not null then data_type||'('||data_precision||','||data_scale||')'
  when data_type = 'NUMBER' and data_precision is null     then data_type
  when data_type = 'VARCHAR2' then data_type||'('||data_length||')'
  when data_type = 'CHAR'     then data_type||'('||data_length||')'
  when data_type like 'TIMESTAMP%'  then data_type||'('||data_length||','||data_scale||')'
 else data_type end as DATA_TYPO,
 data_type, data_length, data_precision, data_scale, default_length 
from  DBA_TAB_COLS
where table_name in
 ('DIM_CALENDAR','CAMPAIGN','CAMPAIGN_ITEM','CAMPAIGN_GOAL','MEDIA_ASSET_VIEW','NETWORK',
  'OPERATOR','PROGRAMMER','PROVIDER','PROVIDER_NETWORK','PROVIDER_NETWORK_SUMMARY',
  'VOD_ENDPOINT')
  and owner = 'DAI9'
order by 2, 4  

  
select *
from DBA_TAB_COLS
where table_name = 'DATABASECHANGELOG'
  and owner = 'DAI9'
order by column_id

  


