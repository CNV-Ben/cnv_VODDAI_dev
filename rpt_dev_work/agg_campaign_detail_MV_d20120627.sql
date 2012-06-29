Drop MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV;


CREATE MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV
AS
SELECT
  cnv_response_placement_dcsn.campaign_id
 ,cnv_response_placement_dcsn.campaign_item_id
 ,cnv_psn_start_placement_views.actual_tracking_id
 ,DAI_REPORTING.operator.company_name AS OPERATOR_NAME
 ,cnv_request.adm_data                AS SERVICE_GROUP
 ,cnv_request.rqst_timestamp          AS DATE_HOUR
 ,trunc(cnv_request.rqst_timestamp)   AS TXN_DATE
 ,DAI_REPORTING.media_asset.id        AS MEDIA_ASSET_ID
 ,DAI_REPORTING.media_asset.asset_idstring
 ,lower(cnv_request.entertainment_provider_id) AS ENTERTAINMENT_PROVIDER_ID
 ,cnv_response_placement_dcsn.placement_id
FROM cnv_response_placement_dcsn
    ,DAI_REPORTING.media_asset
    ,DAI_REPORTING.operator
    ,cnv_request
    ,cnv_psn_start_placement_views
WHERE DAI_REPORTING.media_asset.provider_id               = cnv_response_placement_dcsn.tracking_provider_id
  AND DAI_REPORTING.media_asset.asset_idstring            = cnv_response_placement_dcsn.tracking_asset_id
  AND cnv_request.identity_vod_endpt_id                   = DAI_REPORTING.operator.id
  AND cnv_request.message_id                              = cnv_response_placement_dcsn.request_message_id
  AND CNV_PSN_START_PLACEMENT_VIEWS.ACTUAL_TRACKING_ID(+) = CNV_RESPONSE_PLACEMENT_DCSN.TRACKING_ID;
  COMMENT ON MATERIALIZED VIEW DAI_REPORTING_ETL.AGG_CAMPAIGN_DETAIL_MV IS 'snapshot table for snapshot DAI_REPORTING_ETL.AGG_CAMPAIGN_DETAIL_MV'
;



CREATE OR REPLACE Force VIEW AGG_CAMPAIGN_COMBINED_VW
  (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, OPERATOR_NAME, SERVICE_GROUP, ASSET_ID, ASSET_IDSTRING,
   ENTERTAINMENT_PROVIDER_ID, TRANS_DATE, INSERT_COUNT, VIEW_COUNT)
AS 
select 
  CAMPAIGN_ID, CAMPAIGN_ITEM_ID, OPERATOR_NAME, SERVICE_GROUP,
  MEDIA_ASSET_ID, ASSET_IDSTRING, ENTERTAINMENT_PROVIDER_ID,
  TRUNC(DATE_HOUR) TRANS_DATE,
  COUNT(ACTUAL_TRACKING_ID) INSERT_COUNT, COUNT(PLACEMENT_ID) VIEW_COUNT
from AGG_CAMPAIGN_DETAIL_MV
group by
 CAMPAIGN_ID, CAMPAIGN_ITEM_ID, OPERATOR_NAME, SERVICE_GROUP,
 TRUNC(DATE_HOUR),
 MEDIA_ASSET_ID, ASSET_IDSTRING, ENTERTAINMENT_PROVIDER_ID
---------------------
union all 
---------------------
select
 CAMPAIGN_ID, CAMPAIGN_ITEM_ID, OPERATOR_NAME, SERVICE_GROUP,
 ASSET_ID, ASSET_IDSTRING, 
 LOWER(ENTERTAINMENT_PROVIDER_ID) ENTERTAINMENT_PROVIDER_ID,
 TRUNC(DATE_HOUR) TRANS_DATE,
 insert_count, view_count
from AGG_CAMPAIGN_DETAIL_BA


select * from AGG_CAMPAIGN_COMBINED_VW