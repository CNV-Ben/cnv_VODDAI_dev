CREATE MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV
  (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, ACTUAL_TRACKING_ID, OPERATOR_NAME, SERVICE_GROUP, DATE_HOUR,
   ASSET_ID, ASSET_IDSTRING, ENTERTAINMENT_PROVIDER_ID, PLACEMENT_ID)
as
SELECT
 psn.campaign_id, psn.campaign_item_id, psn.actual_tracking_id,
 op.company_name    AS OPERATOR_NAME,
 req.adm_data       AS SERVICE_GROUP,
 req.rqst_timestamp AS DATE_HOUR,
 -----
 -----
 ma.id, ma.asset_idstring
 lower(req.entertainment_provider_id),  
 rpd.placement_id
from CNV_RESPONSE_PLACEMENT_DCSN    rpd,
     DAI_REPORTING.MEDIA_ASSET      ma,
     DAI_REPORTING.operator         op,
     CNV_REQUEST                   req,
     CNV_PSN_START_PLACEMENT_VIEWS psn
where ma.PROVIDER_ID   = rpd.TRACKING_PROVIDER_ID
  and ma.ASSET_IDSTRING= rpd.TRACKING_ASSET_ID
  and req.IDENTITY_VOD_ENDPT_ID = op.id
  and req.MESSAGE_ID            = rpd.REQUEST_MESSAGE_ID
  and psn.CAMPAIGN_ID(+)        = rpd.CAMPAIGN_ID
  and psn.CAMPAIGN_ITEM_ID(+)   = rpd.CAMPAIGN_ITEM_ID
  and psn.ACTUAL_TRACKING_ID(+) = rpd.TRACKING_ID

  
  

CREATE MATERIALIZED VIEW DAI_REPORTING_ETL.AGG_CAMPAIGN_DETAIL_MV
 (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, ACTUAL_TRACKING_ID, OPERATOR_NAME, SERVICE_GROUP, DATE_HOUR, ASSET_ID, ASSET_IDSTRING, ENTERTAINMENT_PROVIDER_ID, PLACEMENT_ID)
ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE DAI_DATA 
  BUILD IMMEDIATE USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT 
	 cnv_response_placement_dcsn.campaign_id
    ,cnv_response_placement_dcsn.campaign_item_id
    ,cnv_psn_start_placement_views.actual_tracking_id 
    ,DAI_REPORTING.operator.company_name AS OPERATOR_NAME
	,cnv_request.adm_data AS SERVICE_GROUP
	,cnv_request.rqst_timestamp AS DATE_HOUR
	,DAI_REPORTING.media_asset.id AS ASSET_ID
    ,DAI_REPORTING.media_asset.asset_idstring
    ,cnv_request.entertainment_provider_id
	,cnv_response_placement_dcsn.placement_id
FROM  
	 cnv_response_placement_dcsn
	,DAI_REPORTING.media_asset
	,DAI_REPORTING.operator
	,cnv_request
   ,cnv_psn_start_placement_views
where DAI_REPORTING.media_asset.provider_id    = cnv_response_placement_dcsn.tracking_provider_id
  and DAI_REPORTING.media_asset.asset_idstring = cnv_response_placement_dcsn.tracking_asset_id
  and cnv_request.identity_vod_endpt_id = DAI_REPORTING.operator.id
  and cnv_request.message_id = cnv_response_placement_dcsn.request_message_id
  and CNV_PSN_START_PLACEMENT_VIEWS.ACTUAL_TRACKING_ID(+) =	CNV_RESPONSE_PLACEMENT_DCSN.TRACKING_ID


  
  
select
 count(nvl(actual_tracking_id,0)) num_tracks, 
 count(distinct(nvl(actual_tracking_id,0))) unq_tracks,
 count(nvl(placement_id,0)) num_decs,
 count(distinct(nvl(placement_id,0))) unq_decs
from
(
SELECT
 psn.campaign_id, psn.campaign_item_id, psn.actual_tracking_id,
 req.adm_data       AS SERVICE_GROUP,
 req.rqst_timestamp AS DATE_HOUR,
 req.entertainment_provider_id, 
 rpd.placement_id,
 op.company_name    AS OPERATOR_NAME,
 ma.id, ma.asset_idstring
from  CNV_RESPONSE_PLACEMENT_DCSN    rpd,
      DAI_REPORTING.MEDIA_ASSET       ma,
      DAI_REPORTING.operator          op,
      CNV_REQUEST                    req,
      CNV_PSN_START_PLACEMENT_VIEWS  psn
where ma.PROVIDER_ID            = rpd.TRACKING_PROVIDER_ID
  and ma.ASSET_IDSTRING         = rpd.TRACKING_ASSET_ID
  and req.IDENTITY_VOD_ENDPT_ID = op.id
  and req.MESSAGE_ID            = rpd.REQUEST_MESSAGE_ID
  and psn.ACTUAL_TRACKING_ID(+) = rpd.TRACKING_ID
)
---- 1204  |   1192   |   1204   |   1204  






select
 count(nvl(actual_tracking_id,0)) num_tracks, 
 count(distinct(nvl(actual_tracking_id,0))) unq_tracks,
 count(nvl(placement_id,0)) num_decs,
 count(distinct(nvl(placement_id,0))) unq_decs
from
(
SELECT
 psn.campaign_id, psn.campaign_item_id, psn.actual_tracking_id,
 req.adm_data       AS SERVICE_GROUP,
 req.rqst_timestamp AS DATE_HOUR,
 req.entertainment_provider_id, 
 rpd.placement_id,
 op.company_name    AS OPERATOR_NAME,
 ma.id, ma.asset_idstring
from  CNV_RESPONSE_PLACEMENT_DCSN    rpd,
      DAI_REPORTING.MEDIA_ASSET       ma,
      DAI_REPORTING.operator          op,
      CNV_REQUEST                    req,
      CNV_PSN_START_PLACEMENT_VIEWS  psn
where ma.PROVIDER_ID = decode(rpd.tracking_provider_id, 'MystroTV','BRAVOTV.COM',rpd.tracking_provider_id)	  
  and ma.ASSET_IDSTRING         = rpd.TRACKING_ASSET_ID
  and req.IDENTITY_VOD_ENDPT_ID = op.id
  and req.MESSAGE_ID            = rpd.REQUEST_MESSAGE_ID
  and psn.ACTUAL_TRACKING_ID(+) = rpd.TRACKING_ID
)
---- 1302  |   1289   |   1302   |   1302







CREATE MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV AS
----------------------------------------------------
SELECT 
 DAI_REPORTING.operator.company_name AS OPERATOR_NAME,
 rpd.campaign_id, rpd.campaign_item_id, rpd.placement_id,
 cnv_request.adm_data AS SERVICE_GROUP,
 cnv_request.rqst_timestamp AS DATE_HOUR,
 cnv_request.entertainment_provider_id,
 psn.actual_tracking_id,
 DAI_REPORTING.media_asset.id AS ASSET_ID,
 DAI_REPORTING.media_asset.asset_idstring
FROM  cnv_response_placement_dcsn rpd,
	  DAI_REPORTING.media_asset,
	  DAI_REPORTING.operator,
	  cnv_request,
      cnv_psn_start_placement_views psn
where DAI_REPORTING.media_asset.provider_id    = rpd.tracking_provider_id
  and DAI_REPORTING.media_asset.asset_idstring = rpd.tracking_asset_id
  and DAI_REPORTING.operator.id                = cnv_request.identity_vod_endpt_id
  and cnv_request.message_id                   = rpd.request_message_id
  and psn.ACTUAL_TRACKING_ID(+)                = rpd.TRACKING_ID 
;




=================================================================================================
select TO_CHAR(TO_DATE('01-JAN-2008', 'DD-MM-YYYY'), 'DDSP-MMSP-YYYYSP')   from DUAL
select TO_CHAR(TO_DATE('01-JAN-2008', 'DD-MON-YYYY'), 'DDSP-MONTH-YYYYSP') from DUAL

select distinct 
 DATE_HOUR,
 TO_CHAR(TRUNC(DATE_HOUR),'mm/dd/yyyy hh24:mi:ss') DT_V2,
 TO_CHAR(TRUNC(DATE_HOUR, 'Mon'),'MONTH')  DATE_MONTH_V1,
 to_char(TRUNC(DATE_HOUR, 'YYYY'),'YYYY') DATE_YEAR_V1,
 TO_CHAR(DATE_HOUR,'MONTH')  DATE_MONTH_V2,
 TO_CHAR(DATE_HOUR,'YYYY') DATE_YEAR_V2
from AGG_CAMPAIGN_DETAIL_MV 








CREATE MATERIALIZED VIEW AGG_CAMPAIGN_DETAIL_MV
  (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, ACTUAL_TRACKING_ID, OPERATOR_NAME, SERVICE_GROUP,
   DATE_HOUR, TXN_DATE, MEDIA_ASSET_ID, ASSET_IDSTRING, ENTERTAINMENT_PROVIDER_ID, PLACEMENT_ID)
/* 
ORGANIZATION HEAP
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
NOCOMPRESS
LOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1
        FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE DAI_DATA
BUILD IMMEDIATE USING INDEX
REFRESH FORCE ON DEMAND USING DEFAULT LOCAL
ROLLBACK SEGMENT USING ENFORCED CONSTRAINTS
DISABLE QUERY REWRITE
*/
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
  COMMENT ON MATERIALIZED VIEW DAI_REPORTING_ETL.AGG_CAMPAIGN_DETAIL_MV IS 'snapshot table for snapshot DAI_REPORTING_ETL.AGG_CAMPAIGN_DETAIL_MV';




