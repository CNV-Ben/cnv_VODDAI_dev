select * from user_constraints
where constraint_type not in ('C')

select * from user_cons_columns
where constraint_name = 'UQ_SCTE_REQ_OPP'
/*  SCTE_REQUEST_OPPORTUNITY.UQ_SCTE_REQ_OPP (pk):
      REQUEST_MESSAGE_ID and OPPORTUNITY_ID must be Unique.
*/      

/*================================================*/
truncate table SCTE_RQST_TMP
truncate table SCTE_RQST_OPPTY_TMP
truncate table SCTE_RESPONSE
truncate table SCTE_RESPONSE_PLACEMENT
truncate table SCTE_PSN
--truncate table SCTE_REQUEST;
--truncate table SCTE_REQUEST_OPPORTUNITY;



select
 count(message_id) num_mssgs, count(unique(message_id)) unq_mssgs
from SCTE_RESPONSE
where request_message_id in (select message_id from SCTE_RQST_TMP)    ---> 72

select 
 count(opportunity_id||decision_id||placement_id)         item_cnt,
 count(unique(opportunity_id||decision_id||placement_id)) unq_cnt
from SCTE_RESPONSE_PLACEMENT 
 
select
 opportunity_id||'|'||decision_id||'|'||placement_id tgt_rec,  count(1) num_tgts
from SCTE_RESPONSE_PLACEMENT 
group by opportunity_id||'|'||decision_id||'|'||placement_id
having count(1) > 1
order by 1



select *
from SCTE_RESPONSE_PLACEMENT 
where opportunity_id = '0}:{ec979bf7-de7e-4836-a88e-bda9c2724b0f'
order by SESSION_ID, decision_id, opportunity_id, placement_id, tracking_id










--select message_id, session_id, client_dt_string, last_etl_dt
select count(message_id) num_mssgs, count(distinct(message_id)) unq_mssgs
from SCTE_RQST_TMP
order by 1, 2

     
select request_message_id, opportunity_id
--from SCTE_REQUEST_OPPORTUNITY
from SCTE_RQST_OPPTY_TMP
order by 1, 2


select nvl(request_message_id, 'Not Found') request_message_id, count(*) mssg_cnt
from SCTE_RQST_OPPTY_TMP
group by nvl(request_message_id, 'Not Found')
order by 1


select opportunity_id, service_reg_ref
from SCTE_RQST_OPPTY_TMP
where nvl(request_message_id, 'Not Found') = 'Not Found'
order by 1




select request_message_id, count(opportunity_id) oppty_cnt, count(unique(opportunity_id)) unq_oppty
from SCTE_RQST_OPPTY_TMP
where request_message_id in 
  (select message_id from SCTE_RQST_TMP)
group by request_message_id  
order by request_message_id






      
---===============================================================
delete
from SCTE_RESPONSE_PLACEMENT 
where opportunity_id = '0}:{8f34ecd1-d0a3-4343-ba47-29e277367001'
  and session_id = 'test-Session_id_B';
  
delete
from SCTE_RESPONSE_PLACEMENT 
where opportunity_id = '1}:{8f34ecd1-d0a3-4343-ba47-29e277367001'
  and session_id = 'test-Session_id_B';
  
delete
from SCTE_RESPONSE_PLACEMENT 
where opportunity_id = '1}:{8f34ecd1-d0a3-4343-ba47-29e277367001'
  and session_id = 'test-Session_id_C';
  
delete
from SCTE_RESPONSE_PLACEMENT 
where opportunity_id = '0}:{ec979bf7-de7e-4836-a88e-bda9c2724b0f'
  and session_id = 'test-Session_id_C';
      
commit