create table rpt_date_dim (
   id         integer   not null,
   date_value date      not null,
   hour_value number(2) not null,
   primary key (id)
)

select count(1)  from RPT_DATE_DIM


CREATE TABLE RPT_CAMPAIGN_RUNNING_TOTAL(
   CAMPAIGN_ID       INTEGER       not null,
   CAMPAIGN_ITEM_ID  INTEGER       not null,
   MEDIA_ASSET_ID    INTEGER       not null,
   INSERT_COUNT      INTEGER       not null,
   VIEW_COUNT        INTEGER       not null,
   PROGRAMMER        VARCHAR2(255) not null,
   OPERATOR          VARCHAR2(255) not null,
   SERVICE_GROUP     VARCHAR2(255) null
);

---#############################################################################
   
select id, identity from dai_vod_endpoint

update scte_request t
  set t.identity_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.identity)
  where t.identity_vod_endpt_id is null

update scte_request t
  set t.adm_data_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.adm_data)
  where t.adm_data_vod_endpt_id is null
 
update  SCTE_RESPONSE_PLACEMENT set last_etl_proc_name = 'xmlparser'

-- from SCTE_RESPONSE_PLACEMENT
select p.tracking_id
     , substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id
     , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id
     , m.id ad_asset_id
     , mv.value ad_title_brief
     , op.company_name mso
     , req.adm_data service_group
from SCTE_RESPONSE_PLACEMENT p
    , dai_media_asset m
    , SCTE_RESPONSE resp
    , SCTE_REQUEST req
    , dai_vod_endpoint endpt
    , dai_operator op
    , dai_media_asset_metadata_value mv
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
  

    
insert into  RPT_CAMPAIGN_RUNNING_TOTAL(
   CAMPAIGN_ID ,
   CAMPAIGN_ITEM_ID,
   MEDIA_ASSET_ID,
   INSERT_COUNT,
   VIEW_COUNT,
   PROGRAMMER,
   OPERATOR,
   SERVICE_GROUP
) 
select 
     substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1)  campaign_id
     , substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1)  campaign_item_id
     , m.id ad_asset_id
     , 1 insert_count
     , 0 view_count
     , 'dummy' programmer
     , op.company_name operator
     , req.adm_data service_group
from SCTE_RESPONSE_PLACEMENT p
    , dai_media_asset m
    , SCTE_RESPONSE resp
    , SCTE_REQUEST req
    , dai_vod_endpoint endpt
    , dai_operator op
    , dai_media_asset_metadata_value mv
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


select * from RPT_CAMPAIGN_RUNNING_TOTAL

update RPT_CAMPAIGN_RUNNING_TOTAL t
  set t.programmer = (select p.name 
                      from dai_programmer p, dai_campaign c 
                      where c.id = t.campaign_id
                        and p.id = c.programmer_id)
  

select count(*) from rpt_date_dim 
