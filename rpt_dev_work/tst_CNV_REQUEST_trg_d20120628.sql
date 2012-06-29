select distinct
 local_timestamp,
 trunc(local_timestamp) LOCAL_DT1
from SCTE_REQUEST

select 
 trunc(local_timestamp) LOCAL_DT1,
 count(1) item_cnt
from SCTE_REQUEST
group by trunc(local_timestamp)
order by 1

select sysdate -15 from dual


select message_id, adm_data, entertainment_provider_id, entertainment_asset_id, client_dt_string
from SCTE_REQUEST
where trunc(local_timestamp) = trunc(sysdate) -15
  and message_id in
    (select message_id from CNV_REQUEST)
    
drop table CNV_REQUEST_ERR

CREATE TABLE DAI_REPORTING_ETL.CNV_REQUEST_ERR (
	MESSAGE_ID VARCHAR2(128),
	IDENTITY_VOD_ENDPT_ID NUMBER,
	ADM_DATA VARCHAR2(64),
	ENTERTAINMENT_PROVIDER_ID VARCHAR2(64),
	ENTERTAINMENT_ASSET_ID VARCHAR2(64),
	RQST_TIMESTAMP TIMESTAMP WITH TIME ZONE,
	ERROR_MESSAGE VARCHAR2(4000)
);    
    
---=============================================================================    



truncate table CNV_REQUEST_ERR

insert into SCTE_REQUEST
 (MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID)
values
 ('TWC_ADM_ALB}:{00027112-871c-4f44-af34-7c913669ee51','ALB','usanetwork.com','NBCU2012041600000465')


select * from CNV_REQUEST_ERR


