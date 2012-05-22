
select * from CAMPAIGN
select * from CAMPAIGN_ITEM
select * from CAMPAIGN_ITEM_GOAL
select * from CAMPAIGN_ITEM_MEDIA_ASSET
select * from PROGRAMMER
select * from PROVIDER
select * from PROVIDER_NETWORK
select * from MEDIA_ASSET
select * from MEDIA_ASSET_VIEW
select * from NETWORK
select * from OPERATOR
select * from VOD_ENDPOINT
select * from METADATA_FIELD
---+++++++++++++++++++++++++++++++++++++++++++++++++++


select
  c.name CAMPAIGN, p.name PROGAMMER, ci.goal, ma.asset_idstring, ma.ad_id
from CAMPAIGN_ITEM ci, PROGRAMMER p, CAMPAIGN c, CAMPAIGN_ITEM_MEDIA_ASSET cima, MEDIA_ASSET ma
where c.id = ci.campaign_id
  and ci.id = cima.campaign_item_id
  and p.id  = c.programmer_id
  and ma.id = cima.media_asset_id
order by 1, 2




---> 04/12/2012:
select
 REQUEST_MESSAGE_ID, OPPORTUNITY_TYPE, OPPORTUNITY_NUMBER, OPPORTUNITY_DURATION,
 OPPORTUNITY_PLACEMENT_COUNT, CREATED_BY, CREATED_DT,
 LAST_ETL_DT, LAST_ETL_PROC_NAME
from SCTE_REQUEST_OPPORTUNITY
order by 1, 3


select
 MESSAGE_ID, IDENTITY, TARGET_CODE, CLIENT_DT_STRING, CREATED_BY,
 CREATED_DT, LAST_ETL_PROC_NAME, LAST_ETL_DT
from SCTE_REQUEST
order by 1, 4


select
 MESSAGE_ID, CREATED_BY, CREATED_DT,
 LAST_ETL_PROC_NAME, LAST_ETL_DT
from SCTE_REQUEST
order by 1