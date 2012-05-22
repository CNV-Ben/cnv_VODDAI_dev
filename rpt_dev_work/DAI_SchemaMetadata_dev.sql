select
 owner, object_type, object_name, created, last_ddl_time, status
from DBA_OBJECTS
where OBJECT_NAME like 'V%END%POIN%'
order by object_type, objecT_name, owner;


select COUNT(*) ITEM_CNT
from DAI_USER.VOD_ENDPOINT;
----> 9

select COUNT(*) ITEM_CNT
from DAI_RPTG.VOD_ENDPOINT;
---> before running Transform = 0
--->  AFTER running Transform = 9
-----  success!!



select
 owner, object_type, object_name, created, last_ddl_time, status
from DBA_OBJECTS
where OWNER = 'DAI_RPTG'
order by OBJECT_NAME, OBJECT_TYPE;
----#########################################################################
----#########################################################################
----#########################################################################
select count(*) item_cnt from DAI_USER.CAMPAIGN;
select count(*) item_cnt from DAI_USER.CAMPAIGN_ITEM;
select count(*) item_cnt from DAI_USER.NETWORK;
select count(*) item_cnt from DAI_USER.OPERATOR;
select count(*) item_cnt from DAI_USER.PROGRAMMER;
select count(*) item_cnt from DAI_USER.PROVIDER;
select COUNT(*) ITEM_CNT from DAI_USER.PROVIDER_NETWORK;
--select count(*) item_cnt from DAI_USER.PROVIDER_NETWORK_SUMMARY;
select count(*) item_cnt from DAI_USER.VOD_ENDPOINT;



select count(*) item_cnt from DAI_RPTG.CAMPAIGN;
select count(*) item_cnt from DAI_RPTG.CAMPAIGN_ITEM;
select count(*) item_cnt from DAI_RPTG.NETWORK;
select count(*) item_cnt from DAI_RPTG.OPERATOR;
select count(*) item_cnt from DAI_RPTG.PROGRAMMER;
select count(*) item_cnt from DAI_RPTG.PROVIDER;
select count(*) item_cnt from DAI_RPTG.PROVIDER_NETWORK;
select count(*) item_cnt from DAI_RPTG.PROVIDER_NETWORK_SUMMARY;
select COUNT(*) ITEM_CNT from DAI_RPTG.VOD_ENDPOINT;









----#########################################################################
-- 03/27/2012:
-- First Draft preparing DAI Reporting FACT Tables in support of SCTE Reporting
-- data and requirements.
--Drop Table dai_rptg.SCTE_REQUEST

Create Table dai_rptg.SCTE_REQUEST
(
  REQUEST_ID			         varchar2(100) not null,
  REQUEST_MESSAGE_GUID		 varchar2(100) not null,
  HOUSEHOLD_GUID		       varchar2(100) not null,
  STB_GUID		 	           varchar2(100) not null,
  OPPORTUNITY_GUID		     varchar2(100) not null,
  SESSION_GUID			       varchar2(100) not null,
  VOD_ENDPOINT			       varchar2(255) null,
  REQUEST_DATE			       date null,
  REQUEST_CALENDAR_DATE_ID integer null,
  REQUEST_GMT_OFFSET		   integer null,
  PROGRAMMER_PROVIDER_ID	 varchar2(50) null,
  PROGRAMMER_ASSET_ID		   varchar2(50) null,
  TRACKING_GUID            varchar2(100) null,
  CREATED_BY			         varchar2(255) not null,
  CREATED_DATE			       date not null,
  UPDATED_BY			         varchar2(255),
  UPDATED_DATE			       date,
  constraint PK_REQUEST_ID PRIMARY KEY (request_id)
) tablespace USERS;


comment on column dai_rptg.SCTE_REQUEST.REQUEST_ID is 'Generated value to keep the Request table unique.';
comment on column dai_rptg.SCTE_REQUEST.REQUEST_MESSAGE_GUID is 'MSO generated value linking the Opportunity and the Target.  This value is taken from the PlacementRequest messageId in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.HOUSEHOLD_GUID is 'MSO value assigned to a specific Household.  This value is taken from the PlacementRequest TargetCode key in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.STB_GUID is 'MSO value assigned to a specific STB.  This value is taken from the PlacementRequest TerminalAddress type in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.OPPORTUNITY_GUID is 'MSO generated value used as a hook into a placement opportunity on their system.  This value is taken from the PlacementRequest PlacementOpportunity id in the Request payload.  There can be multiple OPPORUNITY_GUID per REQUEST_MESSAGE_GUID.';
comment on column dai_rptg.SCTE_REQUEST.SESSION_GUID is 'Value passed in with the Request Message.  This value is taken from the PlacementRequest SystemContext Session in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.VOD_ENDPOINT is 'Value in the Request Payload Identity.  Maps to the Operator table which provides the MSO name.';
comment on column dai_rptg.SCTE_REQUEST.REQUEST_DATE is 'Date passed in with the Request Message.  This value is taken from the date portion of the PlacementRequest Client CurrentDateTime in the Request payload.';
comment on column DAI_RPTG.SCTE_REQUEST.REQUEST_CALENDAR_DATE_ID is 'FK from the DIM_CALENDAR table.  This key allows access to calendar attributes like Broadcast Month and Broadcast Week.';
--comment on column dai_rptg.SCTE_REQUEST.REQUEST_TIME is 'Time passed in with the Request Message.  This value is taken from the time portion of the PlacementRequest Client CurrentDateTime in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.REQUEST_GMT_OFFSET is 'GMT Offset passed in with the Request Message.  This value is taken from the timezone portion of the PlacementRequest Client CurrentDateTime in the Request payload.';
comment on column dai_rptg.SCTE_REQUEST.PROGRAMMER_PROVIDER_ID is 'Value specific to a Programmer used to retrieve reference data.  Part of the Entertainment tag in the Request Message.';
comment on column dai_rptg.SCTE_REQUEST.PROGRAMMER_ASSET_ID is 'Value specific to a Programmer?s Assets used to retrieve reference data about the Asset.  Part of the Entertainment tag in the Request Message.';
comment on column DAI_RPTG.SCTE_REQUEST.TRACKING_GUID is 'FK from the DAI_RESPONSE table.  Links the Response Placement to the Request details.   There is a one-to-one relationship between a Placement and a Tracking value.';
commit


Create Table dai_rptg.SCTE_RESPONSE
(
  RESPONSE_MESSAGE_GUID	 varchar2(100) not null,
  REQUEST_MESSAGE_GUID	 varchar2(100) not null,
  OPPORTUNITY_GUID	     varchar2(100) not null,
  DECISION_GUID		       varchar2(100) not null,
  PLACEMENT_GUID	       varchar2(100) not null,
  OPPORTUNITY_TYPE	     varchar2(50) null,
  OPPORTUNITY_NUMBER	   INTEGER null,
  OPPORTUNITY_EXPECTED	 integer null,
  PLACEMENT_ACTION	     varchar2(50) null,
  PLACEMENT_POSITION	   INTEGER null,
  PLANNED_AD_PROVIDER_ID varchar2(50) null,
  PLANNED_AD_ASSET_ID	   varchar2(50) null,
  TRACKING_GUID		       varchar2(100) null,
  CAMPAIGN_ID 		       integer null,
---  PROCESSED		 number(1,0) null default 0,
  CREATED_BY		         varchar2(255) not null,
  CREATED_DATE		       date not null,
  UPDATED_BY	           varchar2(255),
  UPDATED_DATE           date,
  constraint PK_RESPONSE_MULTI Primary Key (RESPONSE_MESSAGE_GUID,REQUEST_MESSAGE_GUID,OPPORTUNITY_GUID,DECISION_GUID,PLACEMENT_GUID)
) tablespace USERS;

comment on column dai_rptg.SCTE_RESPONSE.RESPONSE_MESSAGE_GUID is 'Canoe generated value to handle the Request made by the MSO.  There is a one-to-one relationship between Request and Response.  This value is taken from the PlacementResponse messageId in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.REQUEST_MESSAGE_GUID is 'FK from the DAI_REQUEST table.  MSO generated value linking the Opportunity and the Target.  This value is taken from the PlacementResponse messageRef in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.OPPORTUNITY_GUID is 'FK from the DAI_REQUEST table.  MSO generated value used as a hook into a placement opportunity on their system.  This value is taken from the PlacementResponse placementOpportunityRef in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.DECISION_GUID is 'Canoe generated value to handle each Opportunity in the Request.  There is a one-to-one relationship between an Opportunity and a Decision and a one-to-many relationship between a Response and a Decision.  This value is taken from the PlacementResponse PlacementDecision id in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.PLACEMENT_GUID is 'Canoe generated value for each Placement made by the decision engine.  There is a one-to-many relationship between an Decision and a Placement.  This value is taken from the PlacementResponse Placement id in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.OPPORTUNITY_TYPE is 'Describes when the Opportunity should execute.  Values include Preroll and Postroll.  This value is taken from the PlacementResponse OpportunityBinding opportunityType in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.OPPORTUNITY_NUMBER is 'Describes what order the Opportunity is in when multiple Opportunities are associated with the Response.  Values include 1 and 2.  This value is taken from the PlacementResponse OpportunityBinding opportunityNumber in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.OPPORTUNITY_EXPECTED is 'Describes the number of  Opportunities generated when multiple Opportunities are associated with the Response.  Values include 1 and 2.  This value is taken from the PlacementResponse OpportunityBinding opportunitiesExpected in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.PLACEMENT_ACTION is 'Describes the type of action to perform for the Placement.  Values include Fill.  This value is taken from the PlacementResponse Placement action in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.PLACEMENT_POSITION is 'Describes what order the Placement is in when multiple Placements are associated with the Decision.  Values include 1 and 2.  This value is taken from the PlacementResponse Placement position in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.PLANNED_AD_PROVIDER_ID is 'FK from DAI Reference Data.  A code that links to the Provider.  Used in conjunction with ASSET_ID to determine Ad Id and Ad Descriptions.  Values include ads.nbc.com.  This value is taken from the PlacementResponse AssetRef providerID in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.PLANNED_AD_ASSET_ID is 'FK from DAI Reference Data.  A code that links to the Asset.  Used in conjunction with PROVIDER_ID to determine Ad Id and Ad Descriptions.  Values include AD-ID-1 and AD-ID-2.  This value is taken from the PlacementResponse AssetRef assetID in the PlacementResponse payload.';
comment on column dai_rptg.SCTE_RESPONSE.TRACKING_GUID is 'Canoe generated value for each Placement made by the decision engine.  There is a one-to-one relationship between a Placement and a Tracking value.  This value is taken from the PlacementResponse Placement Tracking in the PlacementResponse payload.  This value is used to link to the Notification payload.';
comment on column DAI_RPTG.SCTE_RESPONSE.CAMPAIGN_ID is 'Derived value from the pre-appended value in the Tracking GUID.';
--comment on column DAI_RPTG.SCTE_RESPONSE.PROCESSED is 'Flag representing if the TRACKING_GUID has been placed into the DAI_REQUEST table.';
commit;


Create Table dai_rptg.SCTE_NOTIFICATION
(
  NOTIFICATION_GUID 	    varchar2(100) not null,
  TRACKING_GUID 	        varchar2(100) not null,
  ACTUAL_AD_PROVIDER_ID   varchar2(50) null,
  ACTUAL_AD_ASSET_ID	    varchar2(50) null,
  START_EVENT_TYPE	      varchar2(20) null,
  START_EVENT_DATE	      TIMESTAMP null,
  START_CALENDAR_DATE_ID  integer null,
  START_GMT_OFFSET 	      INTEGER null,
  START_STATUS_CODE_CLASS INTEGER null,
  START_SPOT_NPT_SCALE    INTEGER null,
  START_SPOT_NPT_VALUE    integer null,
  END_EVENT_TYPE	        varchar2(20) null,
  END_EVENT_DATE	        TIMESTAMP null,
  END_CALENDAR_DATE_ID    integer null,
  END_GMT_OFFSET	        INTEGER null,
  END_STATUS_CODE_CLASS   INTEGER null,
  END_SPOT_NPT_SCALE      INTEGER null,
  END_SPOT_NPT_VALUE      integer null,
  CREATED_BY		          varchar2(255) not null,
  CREATED_DATE		        date not null,
  UPDATED_BY		          varchar2(255) null,
  UPDATED_DATE		        date null,
  constraint PK_NOTIF_MULTI primary key (NOTIFICATION_GUID,TRACKING_GUID)
  ) tablespace USERS;
  

comment on column dai_rptg.SCTE_NOTIFICATION.NOTIFICATION_GUID is 'MSO generated value linking all the details of a Response''s Placement playouts.  This value is taken from the PlacementStatusNotification messageId in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.TRACKING_GUID is 'FK from the DAI_RESPONSE table.  Links the Response Placement to the Notification details.   There is a one-to-one relationship between a Placement and a Tracking value.  This value is taken from the PlacementStatusNotification Tracking in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.ACTUAL_AD_PROVIDER_ID is 'A code that links to the Actual Ad played Provider.  Used in conjunction with ASSET_ID to determine Ad Id and Ad Descriptions.  Values include ads.nbc.com.  This value is taken from the PlacementStatusNotification AssetRef providerID in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.ACTUAL_AD_ASSET_ID is 'A code that links to the Actual Ad Asset used.  Used in conjunction with PROVIDER_ID to determine Ad Id and Ad Descriptions.  Values include AD-ID-1 and AD-ID-2. This value is taken from the PlacementStatusNotification AssetRef assetID in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_EVENT_TYPE is 'Describes if the Placement information is for the beginning or ending of the event.  Values include startPlacement and endPlacement.  This value is taken from the PlacementStatusNotification PlacementStatusEvent type in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_EVENT_DATE is 'Describes the date and time (second granularity) of when the start EVENT_TYPE occured.  This value is taken from the PlacementStatusNotification PlacementStatusEvent time in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_CALENDAR_DATE_ID is 'Value from the DIM_CALENDAR table that describes the attributes of the start date, including broadcast week and broadcast month.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_GMT_OFFSET is 'Describes the offest from GMT of when the start EVENT_DATE occured.  It is appended to the EVENT_DATE and will be parsed from the message.  This value is taken from the PlacementStatusNotification PlacementStatusEvent time in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_STATUS_CODE_CLASS is 'Describes if the start event was successful or an error.  Values include 0 and 1.  A value of 1 indicates an error has occurred.  This value is taken from the PlacementStatusNotification PlacementStatusEvent StatusCode class in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_SPOT_NPT_SCALE is 'Describes if the start event was watched in normal or fast forward mode.  Values include 1.  A value of 1 indicates the event was viewed in normal time.  This value is taken from the PlacementStatusNotification PlacementStatusEvent SpotNPT scale in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.START_SPOT_NPT_VALUE is 'Describes what frame the start event was watched initially.  A value of 0 indicates the first frame was played.  This value is taken from the PlacementStatusNotification PlacementStatusEvent SpotNPT in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_EVENT_TYPE is 'Describes if the Placement information is for the beginning or ending of the event.  Values include startPlacement and endPlacement.  This value is taken from the PlacementStatusNotification PlacementStatusEvent type in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_EVENT_DATE is 'Describes the date and time (second granularity) of when the end EVENT_TYPE occured.  This value is taken from the PlacementStatusNotification PlacementStatusEvent time in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_CALENDAR_DATE_ID is 'Value from the DIM_CALENDAR table that describes the attributes of the end date, including broadcast week and broadcast month.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_GMT_OFFSET is 'Describes the offest from GMT of when the end EVENT_DATE occured.  It is appended to the EVENT_DATE and will be parsed from the message.  This value is taken from the PlacementStatusNotification PlacementStatusEvent time in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_STATUS_CODE_CLASS is 'Describes if the end event was successful or an error.  Values include 0 and 1.  A value of 1 indicates an error has occurred.  This value is taken from the PlacementStatusNotification PlacementStatusEvent StatusCode class in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_SPOT_NPT_SCALE is 'Describes if the end event was watched in normal or fast forward mode.  Values include 1.  A value of 1 indicates the event was viewed in normal time.  This value is taken from the PlacementStatusNotification PlacementStatusEvent SpotNPT scale in the Notification payload.';
comment on column dai_rptg.SCTE_NOTIFICATION.END_SPOT_NPT_VALUE is 'Describes what frame the end event was watched initially.  A value of 0 indicates the first frame was played.  This value is taken from the PlacementStatusNotification PlacementStatusEvent SpotNPT in the Notification payload.';
commit;


---=================================================================
set pagesize 0
set long 90000

select DBMS_METADATA.GET_DDL(OBJECT_TYPE, OBJECT_NAME, OWNER)
FROM DBA_OBJECTS WHERE OBJECT_TYPE = 'TABLE' AND OWNER = 'DAI_RPTG' and object_name like '%SCTE%';




