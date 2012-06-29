select
  substr(last_etl_dt, 1, 18) etl_proc_dt
 ,count(1) num_rows
from CNV_REQUEST
group by substr(last_etl_dt, 1, 18)
order by 1, 2

select count(1) rec_count from CNV_REQUEST
select count(1) rec_count from CNV_RESPONSE_PLACEMENT_DCSN
select count(1) rec_count from CNV_PSN_START_PLACEMENT_VIEWS
-------------------------------------------------------------------
select count(1) rec_count from CNV_REQUEST_ERR
select count(1) rec_count from CNV_RESPONSE_PLCMT_DCSN_ERR
select count(1) rec_count from CNV_PSN_START_PLCMNT_VIEWS_ERR
-------------------------------------------------------------------

select error_message, count(*) num_errs
from CNV_REQUEST_ERR
group by error_message

select error_message, count(*) num_errs
from CNV_RESPONSE_PLCMT_DCSN_ERR
group by error_message

select error_msg, count(*) num_errs
from CNV_PSN_START_PLCMNT_VIEWS_ERR
group by error_msg



select entertainment_provider_id, service_group, count(1) item_cnt
from AGG_CAMPAIGN_DETAIL_MV
group by entertainment_provider_id, service_group


update AGG_CAMPAIGN_DETAIL_MV
set entertainment_provider_id = 'bravotv.com'
where entertainment_provider_id = 'BRAVOTV.COM'