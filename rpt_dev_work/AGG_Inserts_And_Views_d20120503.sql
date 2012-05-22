select * from (
select
 rp.response_message_id, rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1) CAMPAIGN_ID,
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1) CAMPAIGN_ITEM_ID,
 req.content_provider_id, dc.programmer_id,
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
group by
 rp.response_message_id, rp.session_id,
 substr(rp.tracking_id,1,instr(rp.tracking_id,'-',1)-1),
 substr(rp.tracking_id,  instr(rp.tracking_id,'-', 1)+1,instr(rp.tracking_id,'-',2)-1),
 req.content_provider_id, dc.programmer_id,
 op.company_name,
 to_date(substr(CLIENT_DT_STRING,1,13),'YYYY-MM-DD"T"HH24')
--order by 1, 2
)
where session_id in
 ('Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SA6+DYmSO934o4xoDwPwNxL',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SACnpGZMhDMv8bxuDK428j3',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SB2d9O3S3JePjpNbPPFWy7F',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SBJQavoP3zTOhQBrbsyy1Mn',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SByNRWr77g9rwpiS2tqNet8',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SD7OAXlrZn0AFORWaCjxVFN',
  'Kn/CuphFqeFjPmTCiERrv9+sCADokj+hiEOBbmon7SDI0SjZA90iAoIstOAywkLr')

  
