--- Aggregated Materialized View
CREATE MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV
AS
SELECT 
	 psn.campaign_id
	,psn.campaign_item_id
	,psn.actual_tracking_id 
	,op.company_name AS OPERATOR_NAME
	,req.adm_data AS SERVICE_GROUP
	,req.rqst_timestamp AS DATE_HOUR
	,ma.id AS Asset_id
	,ma.asset_idstring
	,REQ.ENTERTAINMENT_PROVIDER_ID
	,CRD.PLACEMENT_ID
from  
	CNV_RESPONSE_PLACEMENT_DCSN   CRD,
	MEDIA_ASSET                   MA,
	operator                      OP,
	CNV_REQUEST                   REQ,
	CNV_PSN_START_PLACEMENT_VIEWS PSN
where ma.provider_id            = crd.tracking_provider_id
  and ma.asset_idstring         = crd.tracking_asset_id
  and REQ.IDENTITY_VOD_ENDPT_ID = op.id
  and REQ.MESSAGE_ID            = CRD.REQUEST_MESSAGE_ID
  and PSN.CAMPAIGN_ID(+)        = CRD.CAMPAIGN_ID
  and psn.campaign_item_id(+)   = crd.campaign_item_id
;


select unique CRD.TRACKING_PROVIDER_ID
from CNV_RESPONSE_PLACEMENT_DCSN   CRD

select unique PROVIDER_ID from MEDIA_ASSET order by 1

select *
from CNV_REQUEST
where rownum < 6

select * from MEDIA_ASSET

select *
from CNV_RESPONSE_PLACEMENT_DCSN
where rownum < 6


select *
from CNV_PSN_START_PLACEMENT_VIEWS
where rownum < 6








---- Campaign Summary
SELECT 
   campaign.name                                    as "Campaign"
  ,agg_campaign_detail_mv.campaign_id               as "campaign_id"
  ,programmer.name                                  as "Programmer"
  ,agg_campaign_detail_mv.asset_idstring            as "Ad Asset ID"
  ,agg_campaign_detail_mv.id                        as "AD-ID"
  ,campaign_item.goal                               as "Goal"
  ,count(agg_campaign_detail_mv.placement_id        as INSERT_COUNT
  ,count(agg_campaign_detail_mv.actual_tracking_id) as VIEWS_COUNT
from
   agg_campaign_detail_mv
  ,campaign
  ,campaign_item
  ,programmer
where agg_campaign_detail_mv.campaign_id      = campaign.id
  AND agg_campaign_detail_mv.campaign_item_id = campaign_item.id
  AND campaign.programmer_id                  = programmer.id
GROUP BY
   campaign.name 
  ,agg_campaign_detail_mv.campaign_id 
  ,programmer.name 
  ,agg_campaign_detail_mv.asset_idstring 
  ,agg_campaign_detail_mv.id 
  ,campaign_item.goal 
;

  
  
---- Proof of Performance
SELECT 
   agg_campaign_detail_mv.campaign_item_id 
  ,agg_campaign_detail_mv.entertainment_provider_id 
  ,agg_campaign_detail_mv.date_hour
  ,count(agg_campaign_detail_mv.placement_id)
  ,count(agg_campaign_detail_mv.actual_tracking_id)
from  agg_campaign_detail_mv
where agg_campaign_detail_mv.campaign_id = '1'
GROUP BY
   agg_campaign_detail_mv.campaign_item_id 
  ,agg_campaign_detail_mv.entertainment_provider_id
  ,agg_campaign_detail_mv.date_hour
;



  