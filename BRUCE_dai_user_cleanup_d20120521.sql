select *
from ALL_USERS
order by 1


--- DAI_INTEG, DAI_REPORTING, DAI_REPORTING_ODS, DAI_USER


select OWNER, OBJECT_TYPE, COUNT(OBJECT_NAME) CNT_OBJS
from DBA_OBJECTS
where OWNER like 'DAI%'
group by OWNER, OBJECT_TYPE
order by 1, 2


select object_NAME, OWNER
from DBA_OBJECTS
where OWNER like 'DAI%'
  and object_type = 'TABLE'
order by 1, 2


select *
from DBA_VIEWS
where owner = 'DAI_USER'

OWNER     VIEW_NAME         TEXT_LENGTH
DAI_USER	MEDIA_ASSET_VIEW	  1239

TEXT:

"select ma.id, ma.asset_idstring, ma.provider_id, ma.duration, ma.isci, ma.ad_id, ma.video_def, mv1.value
            "ADVERTISER",
            mv2.value "ADVERTISER_ID",
            mv3.value "ASSET_NAME", mv4.value "PRODUCT", to_date(mv5.value, 'YYYY-MM-DD"T"HH24:MI:SS') "LICENSE_START",
            to_date(mv6.value, 'YYYY-MM-DD"T"HH24:MI:SS') "LICENSE_END"
            from media_asset ma
            left outer join media_asset_metadata_value mv1 on ( ma.id = mv1.media_asset_id and mv1.metadata_field_id =
            17 )
            left outer join media_asset_metadata_value mv2 on ( ma.id = mv2.media_asset_id and mv2.metadata_field_id =
            18 )
            left outer join media_asset_metadata_value mv3 on ( ma.id = mv3.media_asset_id and mv3.metadata_field_id =
            19 )
            left outer join media_asset_metadata_value mv4 on ( ma.id = mv4.media_asset_id and mv4.metadata_field_id =
            20 )
            left outer join media_asset_metadata_value mv5 on ( ma.id = mv5.media_asset_id and mv5.metadata_field_id = 3
            )
            left outer join media_asset_metadata_value mv6 on ( ma.id = mv6.media_asset_id and mv6.metadata_field_id = 4
            )
            where ma.type = 'A'"



select COUNT(*) from DAI_USER.CAMPAIGN
select COUNT(*) from DAI_INTEG.CAMPAIGN
select count(*) from DAI_REPORTING.CAMPAIGN






select 'select count(*) as ITEM_CNT from '||t1.owner||'.'||T1.OBJECT_NAME||';'
from
(
  select object_NAME, OWNER
  from DBA_OBJECTS
  where OWNER = 'DAI_USER'
    and OBJECT_TYPE = 'TABLE'
  order by 1, 2
) t1  


select object_NAME, OWNER
  from DBA_OBJECTS
  where OWNER in ('DAI_USER', 'DAI_REPORTING')
    and OBJECT_TYPE = 'TABLE'
  order by 1, 2


drop table DAI_USER.ADM_RESPONSE
drop table DAI_USER.ASSET_CHECK purge
drop table DAI_USER.CAMPAIGN_ITEM_BREAK_POS purge
drop table DAI_USER.CAMPAIGN_ITEM_GOAL_DAILY purge
drop table DAI_USER.CAMPAIGN_ITEM_METADATA_TARGET  purge
drop table DAI_USER.CAMPAIGN_ITEM_METADATA_TGT_GRP purge 
drop table DAI_USER.CAMPAIGN_ITEM_TIME purge
drop table DAI_USER.PRODUCT_CATEGORY_EXCLUDED purge
drop table DAI_USER.PROGRAMMER_CIS purge
drop table DAI_USER.REVIEW_CAMPAIGN purge
drop table DAI_USER.VOD_ENDPOINT_REGISTRATION purge
drop table DAI_USER.VOD_ENDPOINT_REG_CHECK purge
drop table DAI_USER.VOD_ENDPOINT_STATUS purge
drop table DAI_USER.CAMPAIGN_ITEM purge
drop table DAI_USER.VOD_ENDPOINT purge
drop table DAI_USER.PRODUCT_CATEGORY purge
drop table DAI_USER.METADATA_FIELD purge
drop table DAI_USER.MEDIA_ASSET purge
drop table DAI_USER.CANOE_ADS_ENDPOINT purge
drop table DAI_USER.CAMPAIGN purge
drop table DAI_USER.PROVIDER purge
drop table DAI_USER.PROGRAMMER purge
drop table DAI_USER.operator purge
drop view DAI_USER.MEDIA_ASSET_VIEW


select count(*) as ITEM_CNT from DAI_USER.CAMPAIGN_ITEM;
select COUNT(*) as ITEM_CNT from DAI_USER.CAMPAIGN;
select count(*) as ITEM_CNT from DAI_USER.CANOE_ADS_ENDPOINT;
select count(*) as ITEM_CNT from DAI_USER.MEDIA_ASSET;
select count(*) as ITEM_CNT from DAI_USER.METADATA_FIELD;
select count(*) as ITEM_CNT from DAI_USER.OPERATOR;
select count(*) as ITEM_CNT from DAI_USER.PRODUCT_CATEGORY;
select count(*) as ITEM_CNT from DAI_USER.PROGRAMMER;
select count(*) as ITEM_CNT from DAI_USER.PROVIDER;
select count(*) as ITEM_CNT from DAI_USER.VOD_ENDPOINT;










