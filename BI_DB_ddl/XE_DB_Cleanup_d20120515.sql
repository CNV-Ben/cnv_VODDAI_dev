--=================================================================================
select table_name, last_analyzed, num_rows, tablespace_name
from user_tables
--where substr(table_name,1,4) not in ('DATA','SCTE', 'RPT_','NUM_','DAI_')
order by 1


select count(*) item_cnt from CAMPAIGN;
select count(*) item_cnt from CAMPAIGN_ITEM;
select count(*) item_cnt from NETWORK;
select count(*) item_cnt from OPERATOR;
select count(*) item_cnt from PROGRAMMER;
select count(*) item_cnt from PROVIDER;
select count(*) item_cnt from PROVIDER_NETWORK;
select count(*) item_cnt from VOD_ENDPOINT;


drop table SCTE_PSN_TMP purge;
drop table SCTE_RESP_PLCMT_TMP purge;
drop table SCTE_RESP_TMP purge;
drop table SCTE_RQST_OPPTY_TMP purge;
drop table SCTE_RQST_TMP purge;
drop table DAI_CAMPAIGN purge;
drop table DAI_CAMPAIGN_ITEM purge;
drop table DAI_NETWORK purge;
drop table DAI_PROGRAMMER purge;
drop table DAI_PROVIDER purge;
drop table DAI_PROVIDER_NETWORK purge;
drop table DAI_VOD_ENDPOINT purge;


select
   table_name, last_analyzed, num_rows, tablespace_name,
   case when substr(table_name,1,4) = 'DAI_'
        then substr(table_name,5,50)
        else table_name end as alt_tab_name
from user_tables
--where substr(table_name,1,4) not in ('DATA','SCTE', 'RPT_','NUM_','DAI_')
where substr(table_name,1,4) not in ('DATA','NUM_')
order by 5,1



--=================================================================================
--=================================================================================
--=================================================================================
--Drop Table AGG_CAMPAIGN_RPTG purge
Truncate Table AGG_CAMPAIGN_RPTG

--Create Table AGG_CAMPAIGN_RPTG as
Insert Into AGG_CAMPAIGN_RPTG
select
 sq1.campaign_id, sq1.campaign_item_id, sq1.media_asset_id, sq1.operator,
 sq1.service_group, sq1.date_hour, sum(nvl(sq1.insert_count,0)) INSERT_COUNT,
 sum(nvl(sq2.view_count,0)) VIEW_COUNT
from
(select
   srp.session_id,
   op.company_name OPERATOR,
   substr(srp.tracking_id,1,instr(srp.tracking_id,'-',1)-1) CAMPAIGN_ID,
   substr(srp.tracking_id,  instr(srp.tracking_id,'-', 1)+1,instr(srp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
   req.adm_data as SERVICE_GROUP, ma.id as media_asset_id,
   to_date(substr(req.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24') DATE_HOUR,
   count(srp.placement_id) insert_count
 from dai_ods.SCTE_RESPONSE_PLACEMENT srp, dai_ods.SCTE_RESPONSE res, dai_ods.SCTE_REQUEST req,
      dai_ods.OPERATOR op, dai_ods.VOD_ENDPOINT endpt, dai_ods.DAI_MEDIA_ASSET ma
 where res.message_id    = srp.response_message_id
   and REQ.MESSAGE_ID    = RES.REQUEST_MESSAGE_ID
   and op.id             = endpt.operator_id 
   and endpt.id          = req.identity_vod_endpt_id
   and ma.provider_id    = srp.tracking_provider_id
   and ma.asset_idstring = srp.tracking_asset_id
 group by   
   srp.session_id,
   op.company_name,
   substr(srp.tracking_id,1,instr(srp.tracking_id,'-',1)-1),
   substr(srp.tracking_id,  instr(srp.tracking_id,'-', 1)+1,instr(srp.tracking_id,'-',2)-1),
   req.adm_data, ma.id,
   to_date(substr(req.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24')
) sq1
left outer join 
(select playdata_session_id, count(distinct(actual_tracking_id)) view_count
 from SCTE_PSN
 where pse_event_type = 'startPlacement'
   and SPOT_NPT_SCALE = 1
   and SPOT_NPT_VALUE = 0
--   and playdata_session_id in (select session_id from SCTE_RESPONSE_PLACEMENT)
 group by playdata_session_id  
) SQ2
on sq1.session_id = sq2.playdata_session_id
group by 
 sq1.campaign_id, sq1.campaign_item_id, sq1.media_asset_id, sq1.operator,
 sq1.service_group, sq1.date_hour
order by 1, 2 
 ;


select
 campaign_id, campaign_item_id, media_asset_id, operator, service_group,
 to_char(date_hour, 'mm/dd/yyyy hh24:mi:ss') txn_date, 
 insert_count, view_count
from AGG_CAMPAIGN_RPTG
order by 1, 2


select * from SCTE_RESPONSE_PLACEMENT
select * from SCTE_RESPONSE
select * from SCTE_REQUEST
select * from OPERATOR
select * from VOD_ENDPOINT
select * from DAI_MEDIA_ASSET


select count(*) from SCTE_REQUEST
select count(*) from SCTE_RESPONSE