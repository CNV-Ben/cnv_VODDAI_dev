--##### DAI Dev 04/17/2012
--------------------------

create table KTR_FILE_LOOKUP (KTR_LOOKUP_COL    varchar2(255))
select * from KTR_FILE_LOOKUP

select
 owner, segment_name, segment_type, tablespace_name,
 case when segment_type = 'TABLE' then 1
      when segment_type = 'INDEX' then 2
 else 7 end segment_oda
from dba_segments
--where owner like 'DAI%'
where owner = 'DAI_ODS'
  and segment_name like '%SCTE%'
order by 1, 5


select * from DBA_SEGMENTS
select * from DBA_EXTENTS
select * from DBA_OBJECTS


select
 owner, object_name, object_type, object_id,
 case when object_type = 'TABLE' then 1
      when object_type = 'INDEX' then 2
 else 7 end obj_oda
from dba_objects
--where owner like 'DAI%'
where owner = 'DAI_ODS'
  and object_name like '%SCTE%'
order by 1, 5, 4


select
 owner, object_name, object_type, object_id,
 case when object_type = 'TABLE' then 1
      when object_type = 'INDEX' then 2
 else 7 end obj_oda
from dba_objects
--where owner like 'DAI%'
where owner = 'DAI_ODS'
  and object_name like '%SCTE%'
order by 1, 5, 4

select * from user_objects
select * from SCTE_REQUEST
select * from SCTE_REQUEST_OPPORTUNITY
select * from SCTE_RESPONSE
select * from SCTE_PSN

select *
from dai_ods.SCTE_REQUEST

select * from DAI_CAMPAIGN_ITEM
select * from DAI_CAMPAIGN
select * from DAI_CAMPAIGN_ITEM

select
 dc.id, dc.name, dc.programmer_id,
 dci.campaign_id, dci.id as camp_item_id
from DAI_CAMPAIGN dc, DAI_CAMPAIGN_ITEM dci
where dc.id = dci.campaign_id
order by 1

select
 dc.id, dc.name, dc.programmer_id,
 dci.campaign_id, dci.id as camp_item_id
from DAI_CAMPAIGN dc, DAI_CAMPAIGN_ITEM dci
where dc.id = dci.campaign_id
  and dc.id in (10005, 10022, 10045, 10067, 10068, 10089)
order by 1
select * from DAI_CAMPAIGN_ITEM_MEDIA_ASSET
select * from DAI_CAMPAIGN_ITEM_MEDIA_ASSET
select * from DAI_MEDIA_ASSET





select
 table_name, column_name, column_id,
 case when data_type = 'VARCHAR2' then data_type||'('||data_length||')'
       when data_type = 'NUMBER' then data_type||'('||data_precision||','||data_scale||')'
 else data_type end as data_type,
 case when substr(table_name,-4,4) = 'VIEW' then 7
       when substr(table_name,-4,4) = 'XREF' then 6
       when substr(table_name,-4,4) = 'TRIB' then 5
else 3 end as ODA
from  USER_TAB_COLS
--where table_name = 'SCTE_RESPONSE'
--where table_name = 'SCTE_RESPONSE_PLACEMENT'
--where table_name = 'SCTE_PSN'
where table_name = 'AGG_CAMPAIGN_DETAIL'
order by 5, 1, 3 




select * from DAI_CANOE_ADS_ENDPOINT
select * from DAI_OPERATOR
select * from DAI_CAMPAIGN_ITEM_METADATA_T
select * from DAI_PROGRAMMER
select * from DAI_OPERATOR
select * from DAI_PROVIDER
select * from DAI_PROVIDER_NETWORK

select owner, table_name, column_name
from dba_tab_cols
where column_name like '%SERVICE%'
  and owner like '%DAI%'

select owner, table_name, column_name

select table_name, column_name, column_id
from user_tab_cols
where column_name like '%SERVICE%'

select * from DAI_VOD_ENDPOINT
select * from DAI_VOD_ENDPOINT_REGISTRATION

select table_name, column_name, column_id
from user_tab_cols
where column_name like '%SERVICE%'

select distinct playdata_service_group
from SCTE_PSN

select * from DAI_VOD_ENDPOINT

select distinct ID from DAI_VOD_ENDPOINT order by 1





SCTE_PSN.ACTUAL_TRACKING_ID			joins to SCTE_RESPONSE_PLACEMENT.TRACKING_ID

SCTE_RESPONSE_PLACEMENT.RESPONSE_MESSAGE_ID	joins to SCTE_RESPONSE.MESSAGE_ID
and
SCTE_RESPONSE_PLACEMENT.SESSION_ID		joins to SCTE_RESPONSE.SESSION_ID

SCTE_RESPONSE.REQUEST_MESSAGE_ID 		joins to SCTE_REQUEST_OPPORTUNITY.REQUEST_MESSAGE_ID
and
SCTE_RESPONSE.REQUEST_MESSAGE_ID		joins to SCTE_REQUEST.MESSAGE_ID



AGG_CAMPAIGN_DETAIL	XML_PROC_RUN_ID		 1	I need to figure out how to populate this during Kettle processing
AGG_CAMPAIGN_DETAIL	CAMPAIGN_ID		 2	ok
AGG_CAMPAIGN_DETAIL	CAMPAIGN_ITEM_ID	 3	ok
AGG_CAMPAIGN_DETAIL	MEDIA_ASSET_ID		 4	ok
AGG_CAMPAIGN_DETAIL	OPERATOR		 5	ok
AGG_CAMPAIGN_DETAIL	SERVICE_GROUP		 6	ok
AGG_CAMPAIGN_DETAIL	DATE_DIM_ID		 7	derived from query below!
AGG_CAMPAIGN_DETAIL	IS_VALID		 8	not sure what this is measuring
AGG_CAMPAIGN_DETAIL	INSERT_COUNT		 9	count of SCTE_RESPONSE_PLACEMENT.tracking_id?
AGG_CAMPAIGN_DETAIL	VIEW_COUNT		10	count of SCTE_PSN.actual_tracking_id?



select
 rpd.id, rpd.date_value, scr.client_dt_string, 
 to_date(substr(client_dt_string,1,10),'YYYY-MM-DD') cli_date
from RPT_DATE_DIM rpd, SCTE_REQUEST scr
where rpd.date_value = to_date(substr(scr.client_dt_string,1,10),'YYYY-MM-DD')
  and rpd.hour_value = substr(scr.client_dt_string, instr(scr.client_dt_string,'T',1)+1,2)
order by 1


select --unique
  DO.id, DO.COMPANY_NAME, DVE.OPERATOR_ID, dve.identity src_ident,
  rqst.identity scte_ident
from DAI_OPERATOR DO, DAI_VOD_ENDPOINT DVE, SCTE_REQUEST rqst
where DVE.OPERATOR_ID = DO.id 
  and DVE.identity    = rqst.identity
order by 1


AGG_CAMPAIGN_DETAIL.campaign_id
		   .campaign_item_id
		   .media_asset_id
	
select
 dci.campaign_id, dc.name, dc.programmer_id,
 dci.id as camp_item_id, dcma.media_asset_id
from DAI_CAMPAIGN dc, DAI_CAMPAIGN_ITEM dci, DAI_CAMPAIGN_ITEM_MEDIA_ASSET dcma
where dc.id =  dci.campaign_id
  and dci.id = dcma.campaign_item_id
  and dc.id in (10005, 10022, 10045, 10067, 10068, 10089)
order by 1, 4, 5


AGG_CAMPAIGN_DETAIL.operator

select unique DO.id, DO.COMPANY_NAME, DVE.OPERATOR_ID
from DAI_OPERATOR DO, DAI_VOD_ENDPOINT DVE
where DO.id = DVE.OPERATOR_ID
order by 1




I can retrieve Service Group from Play Data (SCTE_PSN)
select
 actual_tracking_id, actual_asset_id, actual_provider_id,
 playdata_service_group SVC_GROUP, pse_event_type,
 pse_statuscode_class STATUS_CDE, pse_event_dt_string
from SCTE_PSN
order by 1,2,3



SCTE_REQUEST.identity = DAI_VOD_ENDPOINT.identity
I can get Operator ID from DAI_VOD_ENDPOINT and Operator Name from DAI_OPERATOR
I can get SCTE_REQUEST.identity_vod_endpt_id from DAI_VOD_ENDPOINT.id







---------------------------------------------------------------------------------------
-- parse from SCTE_RESPONSE_PLACEMENT and get running total count
-- note: "AD_Title_Brief" is an outer join on metadata_field_id 5 (may be 19, or 34)?
--
select
 p.tracking_id,
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id,
 m.id media_asset_id,
 mv.value ad_title_brief,
 op.company_name mso,
 req.adm_data service_group
from SCTE_RESPONSE_PLACEMENT p,	dai_media_asset m,
     SCTE_RESPONSE resp,	SCTE_REQUEST req,
     dai_vod_endpoint endpt,	dai_operator op,
     dai_media_asset_metadata_value mv
where p.placement_id is not null
--  and p.last_etl_proc_name    = 'xmlparser'
  and p.response_message_id   = resp.message_id
  and resp.request_message_id = req.message_id
  and p.tracking_asset_id     = m.asset_idstring
  and p.tracking_provider_id  = m.provider_id  
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and m.id = mv.media_asset_id(+)
  and mv.metadata_field_id(+) = 5



---######################################################
--- debugging the above:

select tracking_asset_id from  SCTE_RESPONSE_PLACEMENT
OHLE1237000H
MRCO9012000
MQ0057000H
NNOV1007000D


select asset_idstring from dai_media_asset order by 1
VALT0000000000000001
INPK0112000003785651
INMV1211000005468078



select
 p.tracking_id,
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id,
 m.id media_asset_id
from  SCTE_RESPONSE_PLACEMENT p, dai_media_asset m
where p.tracking_asset_id = m.asset_idstring
---> 7 rows, 4 unique


select
 p.tracking_id,
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id
from SCTE_RESPONSE resp, SCTE_RESPONSE_PLACEMENT p
where p.response_message_id   = resp.message_id
---> 4 rows, both total and unique

10100-10100-f86b8121-c572-496d-95df-601c6cb564b2
10100-10100-d83d02b8-be58-4edd-8d01-e06aabd13ee2
10100-10100-eeeeb543-0c4b-4297-ac6a-25c04eea46b4
10100-10100-b1cb52a2-8725-44cc-99c3-12aaf454a841



select message_id from SCTE_REQUEST order by 1

TWC_ADM_INT2}:{31803f00-9608-48e1-a415-26e86917e1a1
TWC_ADM_INT2}:{41483d3e-a63c-4398-94e1-7cd882abeacd
TWC_ADM_INT2}:{4994c7e7-518e-4b0f-bf06-444ed7e574e8





----> this is working, as of 04/18/2012 at 16:45:
select
 p.tracking_id,
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id,
 m.id media_asset_id,
 req.adm_data service_group,
 mv.value ad_title_brief, op.company_name mso
from
  SCTE_RESPONSE resp, SCTE_RESPONSE_PLACEMENT p, SCTE_REQUEST req, DAI_MEDIA_ASSET m,
  DAI_VOD_ENDPOINT endpt, DAI_OPERATOR op, DAI_MEDIA_ASSET_METADATA_VALUE mv     
where p.response_message_id   = resp.message_id
  and resp.request_message_id = req.message_id
  and p.tracking_asset_id     = m.asset_idstring
  and p.tracking_provider_id  = m.provider_id  
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and m.id = mv.media_asset_id(+)
  and mv.metadata_field_id(+) = 5
  
  
  
----> this is working, as of 04/19/2012 at 11:07:  
select
-- SUBSTR(P.TRACKING_ID,INSTR(P.TRACKING_ID,'-',1,2)+1) TRACK_ID,
 p.tracking_id, 
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id,
 m.id media_asset_id,
 REQ.ADM_DATA SERVICE_GROUP,
 MV.value AD_TITLE_BRIEF, OP.COMPANY_NAME MSO_NAME,
 --req.client_dt_string,
 rpd.id date_dim_id
from
  SCTE_RESPONSE RESP, SCTE_RESPONSE_PLACEMENT P, SCTE_REQUEST REQ, DAI_MEDIA_ASSET M,
  DAI_VOD_ENDPOINT ENDPT, DAI_OPERATOR OP, DAI_MEDIA_ASSET_METADATA_VALUE MV,
  RPT_DATE_DIM rpd
where p.response_message_id   = resp.message_id
  and resp.request_message_id = req.message_id
  and p.tracking_asset_id     = m.asset_idstring
  and p.tracking_provider_id  = m.provider_id  
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and m.id = mv.media_asset_id(+)
  and MV.METADATA_FIELD_ID(+) = 5
  and TO_DATE(SUBSTR(REQ.CLIENT_DT_STRING,1,10),'YYYY-MM-DD') = RPD.DATE_VALUE
  and substr(req.client_dt_string,12,2) = rpd.hour_value
       
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

----> returned 7 rows on 04/19/2012!!!








select
 p.tracking_id,
 substr(p.tracking_id, 1, instr(p.tracking_id, '-', 1)-1) campaign_id,
 substr(p.tracking_id, instr(p.tracking_id, '-', 1)+1, instr(p.tracking_id, '-', 2)-1) campaign_item_id,
 m.id media_asset_id,  req.adm_data service_group,

 
 
from SCTE_RESPONSE_PLACEMENT p,	dai_media_asset m,
     SCTE_RESPONSE resp,	SCTE_REQUEST req,
----->     
     DAI_VOD_ENDPOINT endpt,
     DAI_OPERATOR op,
     DAI_MEDIA_ASSET_METADATA_VALUE mv     
----->     
where p.placement_id is not null
--  and p.last_etl_proc_name    = 'xmlparser'
  and p.response_message_id   = resp.message_id
  and resp.request_message_id = req.message_id
  and p.tracking_asset_id     = m.asset_idstring
  and p.tracking_provider_id  = m.provider_id  
  and endpt.id = req.identity_vod_endpt_id
  and op.id = endpt.operator_id
  and m.id = mv.media_asset_id(+)
  and mv.metadata_field_id(+) = 5




/*
    04-10-1012 Peer Review Notes:
    
----- Pentaho Admin Console (Job Sche3duling).

ToDo:
	Process multiple input files
	renme and move completed files
	define Command Line Kettle processing, including the above functionality
	
	Release Notes (a.k.a. Read ME)
	
	modify / update Joe's Jave class coding
	
*/	




Catalina
Rapier

Jira Story #2051
Jira Task #2051
