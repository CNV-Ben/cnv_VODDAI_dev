select *
from user_tables
where table_name like 'SCTE%'


select
 column_id, column_name, data_type, data_length, data_precision, data_scale, nullable, data_default
from user_tab_cols
where table_name = 'SCTE_REQUEST'
  and column_id > 17
order by column_id



select
 column_id, column_name, data_type, data_length, data_precision, data_scale, nullable
from user_tab_cols
where table_name = 'SCTE_REQUEST_OPPORTUNITY'
order by column_id



alter table SCTE_REQUEST modify (created_by NULL)

alter table SCTE_REQUEST modify (created_dt default systimestamp)
alter table SCTE_REQUEST modify (last_etl_dt default systimestamp)



--- 04/12/2012, logged into "oraclehost" as system/canoe:
alter table dai_ods.SCTE_REQUEST modify created_dt default systimestamp-100
alter table dai_ods.SCTE_REQUEST modify last_etl_dt default systimestamp-30


