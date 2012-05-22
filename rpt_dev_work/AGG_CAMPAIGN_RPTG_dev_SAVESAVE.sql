update SCTE_RQST_TMP t
  set t.identity_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.identity)
  where t.identity_vod_endpt_id is null

update SCTE_RQST_TMP t
  set t.adm_data_vod_endpt_id = (select id from dai_vod_endpoint where identity = t.adm_data)
  where T.ADM_DATA_VOD_ENDPT_ID is null






/**
 Step 1)  Number of VIEWS:
   count number of PSN records and retrieve Session and Tracking IDs
   where Tracking ID can be traced back to Placement Response
   and PSN Event Type is "startPlacement".

   The Session ID is used to join to Insertions count.

 Questions:
    should we count ALL PSE_EVENT_TYPES, or only the startPlacments?
    does this code adequately capture the required information?   

*/
---=============================================================================
select playdata_session_id, count(actual_tracking_id) NUM_VIEWS
from SCTE_PSN
where PSE_EVENT_TYPE = 'startPlacement'
  and playdata_session_id in (select session_id from SCTE_RESPONSE_PLACEMENT)
group by playdata_session_id
order by 1
--- VIEWs are startPlacements with addt'l attributes

select distinct PSE_EVENT_TYPE, SPOT_NPT_SCALE, SPOT_NPT_VALUE from SCTE_PSN

select
 PSE_EVENT_TYPE,
-- SPOT_NPT_SCALE, SPOT_NPT_VALUE,
COUNT(*) ITEM_CNT
from SCTE_PSN
where pse_event_type = 'startPlacement'
  and SPOT_NPT_SCALE = 1
  and SPOT_NPT_VALUE = 0
group by PSE_EVENT_TYPE  --, SPOT_NPT_SCALE, SPOT_NPT_VALUE


/**
 Step 2) Number of Insertions:
  This is MUCH more involved because I am joining to a variety of Table to “extend”
  the SCTE XML transaction data.
  Again, I want Session ID to join with PSN data (Step 1 query).
*/
---=============================================================================
select
 rp.session_id,
 op.company_name OPERATOR,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1) CAMPAIGN_ID,
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
 req.content_provider_id, dc.programmer_id,
 med.media_asset_id, 
 ------
 ------
 
 to_date(substr(CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24') TXN_DATE_HOUR,
 count(rp.placement_id) num_insertions
from SCTE_RESPONSE_PLACEMENT rp, SCTE_RESPONSE res, SCTE_RQST_TMP req,
     DAI_OPERATOR op, DAI_VOD_ENDPOINT endpt, DAI_CAMPAIGN dc
where rp.response_message_id = res.message_id
  and RES.REQUEST_MESSAGE_ID = REQ.MESSAGE_ID
--  and rp.placement_action = 'fill'
  and op.id = endpt.operator_id
  and endpt.id = req.identity_vod_endpt_id
  and dc.id = substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1)
group by
-- rp.response_message_id,
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1),
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1),
 req.content_provider_id, dc.programmer_id,
 op.company_name,
 rp.tracking_asset_id,
 TO_DATE(SUBSTR(CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24')
order by 1, 6

select distinct PLACEMENT_ACTION
from SCTE_RESPONSE_PLACEMENT









-----------------------------------------------------------------------------
-- Step 3) Combine the above
--  If any of you are curious how this ultimately looks, I wrote the below
--  to combine the INSERTIONS and VIEWS data sets for the 8 overlapping 
--  Sessions (only).  I included the query results at the bottom.
----------------------------------------------------------------------------
select
 s2.operator, s2.programmer_id, s2.network, s2.campaign_id,
 s2.campaign_item_id, s2.txn_date_hour,
 sum(s2.num_insertions) TOT_INSERTS,
 sum(s1.num_views) TOT_VIEWS
from
(
select playdata_session_id, count(actual_tracking_id) NUM_VIEWS
from SCTE_PSN
where PSE_EVENT_TYPE = 'startPlacement'
  and playdata_session_id in (select session_id from SCTE_RESPONSE_PLACEMENT)
group by playdata_session_id
) S1,
(
select
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1) CAMPAIGN_ID,
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
 req.content_provider_id NETWORK, dc.programmer_id,
 op.company_name OPERATOR,
 to_date(substr(CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24') TXN_DATE_HOUR,
 count(rp.placement_id) num_insertions
from SCTE_RESPONSE_PLACEMENT rp, SCTE_RESPONSE res, SCTE_RQST_TMP req,
     DAI_OPERATOR op, DAI_VOD_ENDPOINT endpt, DAI_CAMPAIGN dc
where rp.response_message_id = res.message_id
  and res.request_message_id = req.message_id
  and rp.placement_action = 'fill'
  and op.id = endpt.operator_id
  and endpt.id = req.identity_vod_endpt_id
  and dc.id = substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1)
  and rp.session_id in
  ('Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SA6+DYmSO934o4xoDwPwNxL',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SACnpGZMhDMv8bxuDK428j3',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SB2d9O3S3JePjpNbPPFWy7F',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SBJQavoP3zTOhQBrbsyy1Mn',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SByNRWr77g9rwpiS2tqNet8',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SD7OAXlrZn0AFORWaCjxVFN',
   'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SDI0SjZA90iAoIstOAywkLr')
group by
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1),
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1),
 req.content_provider_id, dc.programmer_id,
 op.company_name,
 to_date(substr(CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24')
) S2 
where s1.playdata_session_id = s2.session_id
group by
 s2.operator, s2.programmer_id, s2.network, s2.campaign_id,
 s2.campaign_item_id, s2.txn_date_hour
order by 1, 2, 3




====================================================================================================
===== 05/09/2012 =====
select
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1) CAMPAIGN_ID,
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
 rp.tracking_asset_id,
 to_char(TO_DATE(SUBSTR(REQ.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24'),'mm/dd/yyyy hh24:mi:ss') TXN_DATE_HOUR,
 to_char(to_date(SUBSTR(REQ.CLIENT_DT_STRING,1,16),'YYYY-MM-DD"T"HH24:MI'),'mm/dd/yyyy hh24:mi:ss') TEST_DT,
 count(rp.placement_id) num_insertions
from SCTE_RESPONSE_PLACEMENT rp, SCTE_RESPONSE res, SCTE_RQST_TMP req
where rp.response_message_id = res.message_id
  and RES.REQUEST_MESSAGE_ID = REQ.MESSAGE_ID
group by
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1),
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1),
 rp.tracking_asset_id,
 to_char(TO_DATE(SUBSTR(REQ.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24'),'mm/dd/yyyy hh24:mi:ss'),
 to_char(to_date(SUBSTR(REQ.CLIENT_DT_STRING,1,16),'YYYY-MM-DD"T"HH24:MI'),'mm/dd/yyyy hh24:mi:ss')
order by 1


















