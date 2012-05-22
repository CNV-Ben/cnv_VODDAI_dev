select unique asset_idstring
from dai_media_asset
where asset_idstring in
  (select actual_asset_id
   from scte_psn)
   
   
select unique provider_id
from dai_media_asset
where provider_id in
  (select actual_provider_id
   from scte_psn)
   
select unique asset_idstring||'~~~'||provider_id
from dai_media_asset
where asset_idstring||'~~~'||provider_id in
  (select actual_asset_id||'```'||actual_provider_id
   from SCTE_PSN)
   
   
   
select unique id
from dai_vod_endpoint
where id in
  (select identity_vod_endpt_id from SCTE_RQST_TMP)
  
  
  
  
select resp_pl.session_id, resp_pl.tracking_id, COUNT(*) NUM_VIEWS
from SCTE_PSN PSN, SCTE_RESPONSE_PLACEMENT RESP_PL
where PSN.PLAYDATA_SESSION_ID = RESP_PL.SESSION_ID
  and RESP_PL.PLACEMENT_ID is not null
group by RESP_PL.SESSION_ID, RESP_PL.TRACKING_ID
order by 1, 2
  