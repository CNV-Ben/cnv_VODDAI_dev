create table rpt_date_dim
 ( id         integer   not null,
   date_value date      not null,
   hour_value number(2) not null,
   primary key (id)
)

drop table RPT_CAMPAIGN_RUNNING_TOTAL;

CREATE TABLE RPT_CAMPAIGN_RUNNING_TOTAL(
   CAMPAIGN_ID       INTEGER       not null,
   CAMPAIGN_ITEM_ID  INTEGER       not null,
   MEDIA_ASSET_ID    INTEGER       not null,
   INSERT_COUNT      INTEGER       not null,
   VIEW_COUNT        INTEGER       not null,
--   PROGRAMMER        VARCHAR2(255) not null,
   OPERATOR          VARCHAR2(255) not null,
   SERVICE_GROUP     VARCHAR2(255) null
);

   
select id, identity from dai_vod_endpoint

update scte_request t
  set t.identity_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.identity)
  where t.identity_vod_endpt_id is null

update scte_request t
  set t.adm_data_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.adm_data)
  where t.adm_data_vod_endpt_id is null
 
update  SCTE_RESPONSE_PLACEMENT set last_etl_proc_name = 'xmlparser'

-- parse from SCTE_RESPONSE_PLACEMENT and get running total count
-- note: "AD_Title_Brief" is an outer join on metadata_field_id 5 (may be 19, or 34)?
select p.tracking_id
     , substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id
     , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id
     , m.id media_asset_id
     , mv.value ad_title_brief
     , op.company_name mso
     , req.adm_data service_group
from SCTE_RESPONSE_PLACEMENT p
    ,SCTE_RESPONSE resp
    ,SCTE_REQUEST req
    ,dai_media_asset m    
    ,dai_vod_endpoint endpt
    ,dai_operator op
    ,dai_media_asset_metadata_value mv
where p.placement_id is not null
  and p.last_etl_proc_name = 'xmlparser'
  and resp.message_id = p.response_message_id
  and req.message_id = resp.request_message_id
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and  p.tracking_asset_id = m.asset_idstring
  and  p.tracking_provider_id = m.provider_id
  and m.id = mv.media_asset_id (+)
  and mv.metadata_field_id(+) = 5
  
 
SELECT  m.type, m.id, mv.metadata_field_id, mv.value
  FROM dai_media_asset m, SCTE_RESPONSE_PLACEMENT p, dai_media_asset_metadata_value mv
 WHERE p.placement_id is not null
  and  p.last_etl_proc_name = 'xmlparser'
  and  p.tracking_asset_id = m.asset_idstring
  and  p.tracking_provider_id = m.provider_id
  and m.id = mv.media_asset_id (+)
  and mv.metadata_field_id(+) = 5

  
select metadata_field_id, value,media_asset_id
  from dai_media_asset_metadata_value 
 where media_asset_id in (10044, 10003, 10042)
  

truncate table  RPT_CAMPAIGN_RUNNING_TOTAL;

insert into  RPT_CAMPAIGN_RUNNING_TOTAL(
   CAMPAIGN_ID ,
   CAMPAIGN_ITEM_ID,
   MEDIA_ASSET_ID,
   VIEW_COUNT,
--   PROGRAMMER,
   OPERATOR,
   SERVICE_GROUP, 
   INSERT_COUNT
) 
select 
     substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1)  campaign_id
     ,substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1)  campaign_item_id
     ,m.id media_asset_id
     ,0 view_count
--     , 'dummy' programmer
     ,op.company_name operator
     ,req.adm_data service_group
     ,count(*) insert_count
from SCTE_RESPONSE_PLACEMENT p
    ,dai_media_asset m
    ,SCTE_RESPONSE resp
    ,SCTE_REQUEST req
    ,dai_vod_endpoint endpt
    ,dai_operator op
where p.placement_id is not null
  and p.last_etl_proc_name = 'xmlparser'
  and resp.message_id = p.response_message_id
  and req.message_id = resp.request_message_id
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and  p.tracking_asset_id = m.asset_idstring
  and  p.tracking_provider_id = m.provider_id 
group by
   substr(p.tracking_id, 1
 , instr(p.tracking_id, '-', 1)-1)
 , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1)
 , m.id
-- , 0
 , op.company_name
 , req.adm_data


select * from RPT_CAMPAIGN_RUNNING_TOTAL

-- update  RPT_CAMPAIGN_RUNNING_TOTAL t
--  set t.programmer = (select p.name 
--                      from dai_programmer p, dai_campaign c 
--                      where c.id = t.campaign_id
--                        and p.id = c.programmer_id)
  

select count(*) from rpt_date_dim 

drop table RPT_AGG_CAMPAIGN_DETAIL;

CREATE TABLE RPT_AGG_CAMPAIGN_DETAIL(
   CAMPAIGN_ID       INTEGER       not null,
   CAMPAIGN_ITEM_ID  INTEGER       not null,
   MEDIA_ASSET_ID    INTEGER       not null,
--   PROGRAMMER        VARCHAR2(255) not null,
   OPERATOR          VARCHAR2(255) not null,
   SERVICE_GROUP     VARCHAR2(255) null,
   date_dim_id       INTEGER       not null,
   INSERT_COUNT      INTEGER       not null,
   VIEW_COUNT        INTEGER       not null
);

-- find out "insert_count" as sum @ group by campaign, item, media_asset, operator, service_group, and dateDim (date and hr)
select p.tracking_id
     , substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id
     , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id
     , m.id media_asset_id   
     , op.company_name mso
     , req.adm_data service_group
     , rptd.id
     , count(*)
from SCTE_RESPONSE_PLACEMENT p
    ,dai_media_asset m
    ,SCTE_RESPONSE resp
    ,SCTE_REQUEST req
    ,dai_vod_endpoint endpt
    ,dai_operator op
    ,rpt_date_dim rptd
where p.placement_id is not null
  and p.last_etl_proc_name = 'xmlparser'
  and resp.message_id = p.response_message_id
  and req.message_id = resp.request_message_id
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and p.tracking_asset_id = m.asset_idstring
  and p.tracking_provider_id = m.provider_id
  and rptd.date_value = req.local_date
  and rptd.hour_value = req.local_hour
  -- and m.id = mv.media_asset_id (+)
  -- and mv.metadata_field_id(+) = 5 
group by 
    p.tracking_id
  , substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1)
  , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1)
  , m.id
  , op.company_name
  , req.adm_data
  , rptd.id



-- INSERT into RPT_AGG_CAMPAIGN_DETAIL 
INSERT INTO RPT_AGG_CAMPAIGN_DETAIL(
   CAMPAIGN_ID 
   ,CAMPAIGN_ITEM_ID
   ,MEDIA_ASSET_ID
 --  ,PROGRAMMER
   ,OPERATOR
   ,SERVICE_GROUP
   ,date_dim_id
   ,VIEW_COUNT
   ,INSERT_COUNT
)
select substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id
     , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id
     , m.id media_asset_id   
 --    , 'dummy'
     , op.company_name operator
     , req.adm_data service_group
     , rptd.id date_dim_id
     , 0 view_count
     , count(*) insert_count
from SCTE_RESPONSE_PLACEMENT p
    ,dai_media_asset m
    ,SCTE_RESPONSE resp
    ,SCTE_REQUEST req
    ,dai_vod_endpoint endpt
    ,dai_operator op
    ,rpt_date_dim rptd
where p.placement_id is not null
  and p.last_etl_proc_name = 'xmlparser'
  and resp.message_id = p.response_message_id
  and req.message_id = resp.request_message_id
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and p.tracking_asset_id = m.asset_idstring
  and p.tracking_provider_id = m.provider_id
  and rptd.date_value = req.local_date
  and rptd.hour_value = req.local_hour
group by
    substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) 
  , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) 
  , m.id     
  , op.company_name 
  , req.adm_data 
  , rptd.id 
--     , 0
     
--update  RPT_AGG_CAMPAIGN_DETAIL t
--  set t.programmer = (select p.name 
--                      from dai_programmer p, dai_campaign c 
--                      where c.id = t.campaign_id
--                        and p.id = c.programmer_id)
 

select * from RPT_AGG_CAMPAIGN_DETAIL

---------------------
-- Aggregate view counts
---------------------

-- find valid "VIEW" where PSN tracking_id, asset_id, and provider_id match with Decision@SCTE_RESPONSE_PLACEEMNT
-- group by camp, camp_id, media_asset, operatr, service_group, and date_dim_id
SELECT 
--psn.actual_tracking_id, psn.actual_asset_id, psn.actual_provider_id, resp.tracking_id, resp.tracking_asset_id, resp.tracking_provider_id, resp.decision_id
     substr(psn.actual_tracking_id, 1, instr(psn.actual_tracking_id, '-', 1)-1) campaign_id
   , substr(psn.actual_tracking_id, instr(psn.actual_tracking_id, '-', 1)+1, instr(psn.actual_tracking_id, '-', 2)-1) campaign_item_id
   , m.id media_asset_id 
   , op.company_name operator
   , req.adm_data service_group
   , rptd.id date_dim_id
   , count(*) view_count
FROM SCTE_PSN psn
   , SCTE_RESPONSE_PLACEMENT p
   , dai_media_asset m
   , SCTE_RESPONSE resp
   , SCTE_REQUEST req
   , dai_vod_endpoint endpt
   , dai_operator op
   , rpt_date_dim rptd
WHERE upper(trim(psn.pse_event_type)) = 'STARTPLACEMENT'
  and psn.spot_npt_scale = 1
  and psn.spot_npt_value = 0
  and psn.last_etl_proc_name = 'loader'
  and p.session_id = psn.playdata_session_id
  and p.tracking_id = psn.actual_tracking_id
  and p.tracking_asset_id = psn.actual_asset_id
  and p.tracking_provider_id = psn.actual_provider_id
  and psn.actual_asset_id = m.asset_idstring
  and psn.actual_provider_id = m.provider_id
  and resp.message_id = p.response_message_id
  and req.message_id = resp.request_message_id
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and rptd.date_value = req.local_date
  and rptd.hour_value = req.local_hour
group by  
     substr(psn.actual_tracking_id, 1, instr(psn.actual_tracking_id, '-', 1)-1) 
   , substr(psn.actual_tracking_id, instr(psn.actual_tracking_id, '-', 1)+1, instr(psn.actual_tracking_id, '-', 2)-1) 
   , m.id 
   , op.company_name 
   , req.adm_data 
   , rptd.id 
 
update RPT_AGG_CAMPAIGN_DETAIL set view_count = 0;

-- update 'view_count'


