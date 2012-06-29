CREATE TABLE CNV_REQUEST
( MESSAGE_ID                VARCHAR2(128 CHAR),
  IDENTITY_VOD_ENDPT_ID     NUMBER,
  ENTERTAINMENT_PROVIDER_ID VARCHAR2(64 CHAR),
  ENTERTAINMENT_ASSET_ID    VARCHAR2(64 CHAR),
  RQST_TIMESTAMP 			TIMESTAMP(6) WITH TIME ZONE,
  constraint UQ_CNV_REQUEST unique (MESSAGE_ID)
);
  
create table CNV_REQUEST_ERR
( MESSAGE_ID                VARCHAR2(128 CHAR),
  IDENTITY_VOD_ENDPT_ID     NUMBER,
  ENTERTAINMENT_PROVIDER_ID VARCHAR2(64 CHAR),
  ENTERTAINMENT_ASSET_ID    VARCHAR2(64 CHAR),
  RQST_TIMESTAMP		    TIMESTAMP(6) WITH TIME ZONE,
  ERROR_MSSG                varchar2(300)
);


CREATE TABLE CNV_RESPONSE_PLACEMENT_DCSN
( REQUEST_MESSAGE_ID   VARCHAR2(128 CHAR),
  OPPORTUNITY_ID       VARCHAR2(64 CHAR),
  OPPORTUNITY_TYPE     VARCHAR2(16 CHAR),
  OPPORTUNITY_NUMBER   NUMBER(3,0),
  PLACEMENT_ID         VARCHAR2(64 CHAR),
  PLACEMENT_POS        NUMBER(3,0),
  CAMPAIGN_ID          NUMBER,
  CAMPAIGN_ITEM_ID	   NUMBER,
  TRACKING_ID          VARCHAR2(64 CHAR),
  TRACKING_ASSET_ID    VARCHAR2(32 CHAR),
  TRACKING_PROVIDER_ID VARCHAR2(64 CHAR),
  constraint UQ_CNV_RSPNSE_PLACEMENT_DCSN
      unique (REQUEST_MESSAGE_ID, OPPORTUNITY_TYPE, OPPORTUNITY_NUMBER, PLACEMENT_POS)
);

CREATE TABLE DAI_REPORTING_ETL.CNV_RESPONSE_PLCMT_DCSN_ERR
( REQUEST_MESSAGE_ID VARCHAR2(128),
  OPPORTUNITY_ID VARCHAR2(64),
  OPPORTUNITY_TYPE VARCHAR2(16),
  OPPORTUNITY_NUMBER NUMBER,
  PLACEMENT_ID VARCHAR2(64),
  PLACEMENT_POS NUMBER,
  CAMPAIGN_ID NUMBER,
  CAMPAIGN_ITEM_ID NUMBER,
  TRACKING_ID VARCHAR2(64),
  TRACKING_ASSET_ID VARCHAR2(32),
  TRACKING_PROVIDER_ID VARCHAR2(32),
  ERROR_MESSAGE VARCHAR2(300)
);



CREATE TABLE CNV_PSN_START_PLACEMENT_VIEWS
( PLAYDATA_SERVICE_GROUP    VARCHAR2(16 CHAR),
  CAMPAIGN_ID      		    NUMBER,
  CAMPAIGN_ITEM_ID          NUMBER,
  ACTUAL_TRACKING_ID        VARCHAR2(64 CHAR),
  ACTUAL_ASSET_ID           VARCHAR2(64 CHAR),
  ACTUAL_PROVIDER_ID        VARCHAR2(64 CHAR),
  START_PLACEMENT_TIMESTAMP TIMESTAMP(6) WITH TIME ZONE,
  constraint UQ_CNV_PSN_START_PLACEMENT_VW unique (START_PLACEMENT_TIMESTAMP, ACTUAL_TRACKING_ID)
);

create table CNV_PSN_START_PLCMTS_ERR
( PLAYDATA_SERVICE_GROUP    VARCHAR2(16 CHAR),
  CAMPAIGN_ID      		    NUMBER,
  CAMPAIGN_ITEM_ID          NUMBER,
  ACTUAL_TRACKING_ID        VARCHAR2(64 CHAR),
  ACTUAL_ASSET_ID           VARCHAR2(64 CHAR),
  ACTUAL_PROVIDER_ID        VARCHAR2(64 CHAR),
  START_PLACEMENT_TIMESTAMP TIMESTAMP(6) WITH TIME ZONE,
  ERROR_MSSG                varchar2(300)   
);   

/*
drop table CNV_REQUEST                   purge;
drop table CNV_REQUEST_ERR               purge;
drop table CNV_RESPONSE_PLACEMENT_DCSN   purge;
drop table CNV_RESPONSE_PLCMT_DCSN_ERR   purge;
drop table CNV_PSN_START_PLACEMENT_VIEWS purge;
drop table CNV_PSN_START_PLCMTS_ERR      purge;


select * from SCTE_REQUEST_CNV
truncate table SCTE_REQUEST_CNV


select 
 name, type, min(LINE) START_HERE, max(LINE) END_HERE, COUNT(LINE) PROC_LENGTH
from USER_SOURCE
group by name, type


select
  C.TABLE_NAME, C.CONSTRAINT_NAME, C.CONSTRAINT_TYPE,
  CC.COLUMN_NAME, CC.POSITION, C.STATUS, C.VALIDATED
from user_CONSTRAINTS C, user_CONS_COLUMNS CC
where C.TABLE_NAME = CC.TABLE_NAME
  and C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME
  and C.CONSTRAINT_TYPE != 'C'
  and C.TABLE_NAME like 'C%'
order by 1, 2, 3, 4, 5





truncate table SCTE_REQUEST;
truncate table SCTE_REQUEST_OPPORTUNITY;
truncate table SCTE_RESPONSE;
truncate table SCTE_RESPONSE_PLACEMENT_DCSN;
truncate table SCTE_PSN;
-------------------------------
truncate table CNV_REQUEST;
truncate table CNV_RESPONSE_PLACEMENT_DCSN;
truncate table CNV_PSN_START_PLACEMENT_VIEWS;
truncate table CNV_REQUEST_ERR;
truncate table CNV_RESPONSE_PLCMT_DCSN_ERR;
truncate table CNV_PSN_START_PLCMNT_VIEWS_ERR;


select count(*) from SCTE_REQUEST
select count(*) from SCTE_REQUEST_OPPORTUNITY
select count(*) from SCTE_RESPONSE
select count(*) from SCTE_RESPONSE_PLACEMENT_DCSN
select count(*) from SCTE_PSN
-------------------------------
select count(*) row_cnt from CNV_REQUEST;
select count(*) row_cnt from CNV_RESPONSE_PLACEMENT_DCSN;
select count(*) row_cnt from CNV_PSN_START_PLACEMENT_VIEWS;
select count(*) row_cnt from CNV_REQUEST_ERR;
select count(*) row_cnt from CNV_RESPONSE_PLCMT_DCSN_ERR;
select count(*) row_cnt from CNV_PSN_START_PLCMNT_VIEWS_ERR;






*/




--=================================================================================================
--=================================================================================================
PROCEDURE CNV_REQUEST_PRC is
    v_error_msg     varchar2(500);

begin
insert into CNV_REQUEST
 select distinct
  req.MESSAGE_ID,
  req.IDENTITY,
  req.ENTERTAINMENT_PROVIDER_ID,
  req.ENTERTAINMENT_ASSET_ID,
  TO_TIMESTAMP_TZ(REQ.CLIENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM')
 from SCTE_REQUEST REQ;
commit;

EXCEPTION
when OTHERS then
  V_ERROR_MSG  := SQLERRM;


insert into CNV_REQUEST_ERR
 select distinct
  req.MESSAGE_ID,
  req.IDENTITY,
  req.ENTERTAINMENT_PROVIDER_ID,
  req.ENTERTAINMENT_ASSET_ID,
  TO_TIMESTAMP_TZ(REQ.CLIENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM'),
  v_error_msg
 from SCTE_REQUEST REQ;

commit;

end CNV_REQUEST_PRC;



CREATE OR REPLACE PROCEDURE CNV_RESPONSE_PLCMT_DCSN_PRC is
  v_error_msg     varchar2(500);

begin

insert into CNV_RESPONSE_PLACEMENT_DCSN
 select distinct
   pd.REQUEST_MESSAGE_ID,  
   pd.OPPORTUNITY_ID,
   pd.OPPORTUNITY_TYPE,
   pd.OPPORTUNITY_NUMBER,
   pd.PLACEMENT_ID,
   pd.PLACEMENT_POS,
   pd.CAMPAIGN_ID,  
   pd.CAMPAIGN_ITEM_ID,  
   pd.TRACKING_ID,
   pd.TRACKING_ASSET_ID,
   pd.TRACKING_PROVIDER_ID
 from SCTE_RESPONSE_PLACEMENT_DCSN pd
 where pd.placement_action in ('fill','replace');

commit;

EXCEPTION
when OTHERS then
  V_ERROR_MSG  := SQLERRM;

insert into CNV_RESPONSE_PLCMT_DCSN_ERR
 select distinct
   pd.REQUEST_MESSAGE_ID,  
   pd.OPPORTUNITY_ID,
   pd.OPPORTUNITY_TYPE,
   pd.OPPORTUNITY_NUMBER,
   pd.PLACEMENT_ID,
   pd.PLACEMENT_POS,
   pd.CAMPAIGN_ID,  
   pd.CAMPAIGN_ITEM_ID,  
   pd.TRACKING_ID,
   pd.TRACKING_ASSET_ID,
   pd.TRACKING_PROVIDER_ID,
   v_error_msg
 from SCTE_RESPONSE_PLACEMENT_DCSN pd
 where pd.placement_action in ('fill','replace');
  
commit;
  
end CNV_RESPONSE_PLCMT_DCSN_PRC;


CREATE OR REPLACE PROCEDURE CNV_PSN_PRC is
   v_error_msg     varchar2(500);

begin

insert into CNV_PSN_START_PLACEMENT_VIEWS
 select distinct
  psn.playdata_service_group,
  psn.campaign_id,
  psn.campaign_item_id,
  psn.actual_tracking_id,
  psn.actual_asset_id,
  psn.actual_provider_id,
  TO_TIMESTAMP_TZ(psn.pse_event_dt_string,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM')
 from SCTE_PSN psn
 where psn.pse_event_type = 'startPlacement'
   and psn.spot_npt_scale = 1
   and psn.spot_npt_value = 0;

commit;


EXCEPTION
when OTHERS then
  V_ERROR_MSG  := SQLERRM;


insert into CNV_PSN_START_PLCMTS_ERR  
 select distinct
  psn.playdata_service_group,
  psn.campaign_id,
  psn.campaign_item_id,
  psn.actual_tracking_id,
  psn.actual_asset_id,
  psn.actual_provider_id,
  TO_TIMESTAMP_TZ(psn.pse_event_dt_string,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM'),
  v_error_msg
 from SCTE_PSN psn
 where psn.pse_event_type = 'startPlacement'
   and psn.spot_npt_scale = 1
   and psn.spot_npt_value = 0;

commit;

end CNV_PSN_PRC;
--=================================================================================================
--=================================================================================================



----+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create or replace trigger CNV_REQUEST_TRG
 after insert on SCTE_REQUEST
 for each row

 declare
	v_error_msg		varchar2(4000);

begin

insert into CNV_REQUEST
   (MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID, RQST_TIMESTAMP)
values
   (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id,
    TO_TIMESTAMP_TZ(:new.CLIENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFFTZH:TZM')
   )
;


EXCEPTION
when OTHERS then   V_ERROR_MSG  := SQLERRM;

insert into CNV_REQUEST_ERR
   (MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID, RQST_TIMESTAMP,
    error_message)
values
   (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id,
    TO_TIMESTAMP_TZ(:new.CLIENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFFTZH:TZM'), v_error_msg
   );

end CNV_REQUEST_TRG;


----+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---- alter table CNV_RESPONSE_PLCMT_DCSN_ERR rename column error_msg to error_message

create or replace trigger CNV_RESPONSE_PLCMT_DCSN_TRG
 after insert on SCTE_RESPONSE_PLACEMENT_DCSN
 for each row
 when (new.placement_action in ('fill','replace'))
 declare
	v_error_msg		varchar2(4000);

begin
 insert into CNV_RESPONSE_PLACEMENT_DCSN
   (REQUEST_MESSAGE_ID,  OPPORTUNITY_ID, OPPORTUNITY_TYPE, OPPORTUNITY_NUMBER, PLACEMENT_ID, PLACEMENT_POS,
    CAMPAIGN_ID, CAMPAIGN_ITEM_ID, TRACKING_ID, TRACKING_ASSET_ID, TRACKING_PROVIDER_ID)
 values
   (:new.REQUEST_MESSAGE_ID, :new.OPPORTUNITY_ID, :new.OPPORTUNITY_TYPE, :new.OPPORTUNITY_NUMBER, :new.PLACEMENT_ID,
    :new.PLACEMENT_POS, :new.CAMPAIGN_ID, :new.CAMPAIGN_ITEM_ID, :new.TRACKING_ID, :new.TRACKING_ASSET_ID, :new.TRACKING_PROVIDER_ID
   );

EXCEPTION
when OTHERS then V_ERROR_MSG  := SQLERRM;

 insert into CNV_RESPONSE_PLCMT_DCSN_ERR
   (REQUEST_MESSAGE_ID,  OPPORTUNITY_ID, OPPORTUNITY_TYPE, OPPORTUNITY_NUMBER, PLACEMENT_ID, PLACEMENT_POS,
    CAMPAIGN_ID, CAMPAIGN_ITEM_ID, TRACKING_ID, TRACKING_ASSET_ID, TRACKING_PROVIDER_ID, ERROR_MESSAGE)
 values
   (:new.REQUEST_MESSAGE_ID, :new.OPPORTUNITY_ID, :new.OPPORTUNITY_TYPE, :new.OPPORTUNITY_NUMBER, :new.PLACEMENT_ID,
    :new.PLACEMENT_POS, :new.CAMPAIGN_ID, :new.CAMPAIGN_ITEM_ID, :new.TRACKING_ID, :new.TRACKING_ASSET_ID, :new.TRACKING_PROVIDER_ID,
	V_ERROR_MSG);

end CNV_RESPONSE_PLCMT_DCSN_TRG;


----+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create or replace trigger CNV_PSN_TRG
 after insert on SCTE_PSN
 for each row
 when (new.pse_event_type = 'startPlacement'
   and new.spot_npt_scale = 1
   and new.spot_npt_value = 0)
 declare
	v_error_msg		varchar2(4000);

begin

insert into CNV_PSN_START_PLACEMENT_VIEWS
   (playdata_service_group, campaign_id, campaign_item_id, actual_tracking_id, actual_asset_id, actual_provider_id,
    start_placement_timestamp)
values
   (:new.playdata_service_group, :new.campaign_id, :new.campaign_item_id, :new.actual_tracking_id, :new.actual_asset_id,
    :new.actual_provider_id,
    TO_TIMESTAMP_TZ(:new.PSE_EVENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM')
	);
   

EXCEPTION
when OTHERS then   V_ERROR_MSG  := SQLERRM;

insert into CNV_PSN_START_PLCMNT_VIEWS_ERR
   (playdata_service_group, campaign_id, campaign_item_id, actual_tracking_id, actual_asset_id, actual_provider_id,
    start_placement_timestamp, error_msg)
values
   (:new.playdata_service_group, :new.campaign_id, :new.campaign_item_id, :new.actual_tracking_id, :new.actual_asset_id,
    :new.actual_provider_id,
    TO_TIMESTAMP_TZ(:new.PSE_EVENT_DT_STRING,'YYYY-MM-DD"T"HH24:MI:SSxFF TZH:TZM'), V_ERROR_MSG
	);

end CNV_PSN_TRG;