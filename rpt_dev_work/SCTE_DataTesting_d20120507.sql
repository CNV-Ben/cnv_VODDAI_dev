select * from SCTE_RQST_TMP

truncate table SCTE_RQST_OPPTY_TMP
truncate table SCTE_RQST_TMP

select created_dt, last_etl_dt, count(*) item_cnt
from SCTE_RQST_TMP
group by created_dt, last_etl_dt
order by 1, 2
 
--====================================================================== 
truncate table SCTE_RESPONSE_PLACEMENT
truncate table SCTE_RESPONSE

select created_dt, last_etl_dt, count(*) item_cnt
from SCTE_RESPONSE
group by created_dt, last_etl_dt
order by 1, 2


--====================================================================== 
truncate table SCTE_PSN

select created_dt, last_etl_dt, count(*) item_cnt
from SCTE_PSN
group by created_dt, last_etl_dt
order by 1, 2





--====================================================================== 
select pse_event_type, spot_npt_scale, spot_npt_value, count(actual_tracking_id) cnt_track, count(unique(actual_tracking_id)) unq_track
from SCTE_PSN
group by pse_event_type, spot_npt_scale, spot_npt_value
order by 1, 2, 3

select unique spot_npt_scale, spot_npt_value
from SCTE_PSN


select psn.playdata_session_id, count(psn.actual_tracking_id) NUM_VIEWS
from SCTE_PSN psn
where psn.PSE_EVENT_TYPE = 'startPlacement'
  and psn.spot_npt_scale = 1
  and psn.spot_npt_value = 0
  and exists 
      (select session_id
       from SCTE_RESPONSE_PLACEMENT
       where session_id = psn.playdata_session_id)
group by psn.playdata_session_id
order by 1






select
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1) CAMPAIGN_ID,
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
 to_date(substr(req.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24') TXN_DATE_HOUR,
 count(rp.placement_id) num_insertions
from SCTE_RESPONSE_PLACEMENT rp, SCTE_RESPONSE res, SCTE_RQST_TMP req
where rp.response_message_id = res.message_id
  and RES.REQUEST_MESSAGE_ID = REQ.MESSAGE_ID
group by
 rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1),
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1),
 TO_DATE(SUBSTR(req.CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24')
order by 1


select unique placement_action
from SCTE_RESPONSE_PLACEMENT





