CREATE TABLE DAI_REPORTING_ODS.SCTE_REQUEST_OPPTY_RAW
(REQUEST_MESSAGE_ID				VARCHAR2(128 CHAR), 
 OPPORTUNITY_ID					VARCHAR2(96 CHAR), 
 SERVICE_REG_REF				VARCHAR2(96 CHAR), 
 OPPORTUNITY_TYPE 				VARCHAR2(16 CHAR), 
 OPPORTUNITY_NUMBER				NUMBER(3,0), 
 OPPORTUNITY_DURATION			VARCHAR2(32 CHAR), 
 OPPORTUNITY_PLACEMENT_COUNT	NUMBER(3,0), 
 CREATED_BY						VARCHAR2(64 CHAR), 
 CREATED_DT						TIMESTAMP(6), 
 ETL_FILE_NAME					VARCHAR2(255 CHAR), 
 LAST_ETL_DT					TIMESTAMP(6)
)
TABLESPACE USERS



select object_type, object_name, object_id, created, timestamp, status
from user_objects
where object_type = 'TABLE'


select count(message_id), count(unique(message_id)) from SCTE_REQUEST_RAW
--- 1,101 and 1,071

select message_id, session_id
from SCTE_REQUEST_RAW
order by 1


select *
from SCTE_REQUEST_RAW
order by message_id, session_id, client_dt_string

---> missing ADM_DATA, CONTENT_PROVIDER_ID, ENTERTAINMENT_DURATION


select count(unique(message_id)) 
from SCTE_REQUEST_RAW    ---> 1071
where message_id in (select message_id from SCTE_REQUEST)  --- zero



select
 'select count(*) row_cnt from '||table_name||' where '||column_name||' is null;', column_id
from  user_tab_cols
where table_name = 'SCTE_REQUEST_RAW'
order by 2


select count(*) row_cnt from SCTE_REQUEST_RAW;    --- 1,101
select count(*) row_cnt from SCTE_REQUEST_RAW where MESSAGE_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where VERSION is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where IDENTITY is null;
--select count(*) row_cnt from SCTE_REQUEST_RAW where IDENTITY_VOD_ENDPT_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where ADM_DATA is null;               --1,100
--select count(*) row_cnt from SCTE_REQUEST_RAW where ADM_DATA_VOD_ENDPT_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where TERMINAL_ADDR is null;           -- 1
select count(*) row_cnt from SCTE_REQUEST_RAW where TARGET_CODE is null;             -- 1
select count(*) row_cnt from SCTE_REQUEST_RAW where SESSION_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where SERVICE_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where CONTENT_PROVIDER_ID is null;     --1,100
select count(*) row_cnt from SCTE_REQUEST_RAW where ENTERTAINMENT_PROVIDER_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where ENTERTAINMENT_ASSET_ID is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where ENTERTAINMENT_DURATION is null;  --1,100
select count(*) row_cnt from SCTE_REQUEST_RAW where CLIENT_DT_STRING is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where CREATED_BY is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where CREATED_DT is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where ETL_FILE_NAME is null;
select count(*) row_cnt from SCTE_REQUEST_RAW where LAST_ETL_DT is null;


select *
from SCTE_REQUEST_RAW
where terminal_addr is null  ---> placement-requests.g.2012-03-20.xml

select *
from SCTE_REQUEST_RAW
where etl_file_name like '%placement-requests.g.2012-03-20.xml'

--- In the above Placement Request message ONLY, the TERMINAL_ADDR and TARGET_CODE fields
--- ARE Null, while the CONTENT_PROVIDER_ID and ENTERTAINMENT_DURATION are NOT Null.
---
--- ALL the other rows are exactly opposite: TERMINAL_ADDR and TARGET_CODE are populated while 
--- CONTENT_PROVIDER_ID and ENTERTAINMENT_DURATION are Null.
---
--- Strangely inconsistent...







select
 'select count(*) row_cnt from '||table_name||' where '||column_name||' is null;', column_id
from  user_tab_cols
where table_name = 'SCTE_REQUEST_OPPTY_RAW'
order by 2

select * from SCTE_REQUEST_OPPTY_RAW



select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW;                                           --1,885
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where REQUEST_MESSAGE_ID is null           --1,885
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where OPPORTUNITY_ID is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where SERVICE_REG_REF is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where OPPORTUNITY_TYPE is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where OPPORTUNITY_NUMBER is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where OPPORTUNITY_DURATION is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where OPPORTUNITY_PLACEMENT_COUNT is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where CREATED_BY is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where CREATED_DT is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where ETL_FILE_NAME is null;
select count(*) row_cnt from SCTE_REQUEST_OPPTY_RAW where LAST_ETL_DT is null;


truncate table SCTE_REQUEST_OPPTY_RAW;
truncate table SCTE_REQUEST_RAW;



