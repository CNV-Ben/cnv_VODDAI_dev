--------------------------------------------------------
--  DDL for SCTE Placement Requests TMP Tables
--------------------------------------------------------
Drop Table SCTE_RQST_TMP purge;

  create table "DAI_ODS"."SCTE_RQST_TMP" 
 ("MESSAGE_ID" VARCHAR2(128 CHAR), 
	"VERSION" VARCHAR2(8 CHAR), 
	"IDENTITY" VARCHAR2(255 CHAR), 
	"IDENTITY_VOD_ENDPT_ID" NUMBER(*,0), 
	"ADM_DATA" VARCHAR2(255 CHAR), 
	"ADM_DATA_VOD_ENDPT_ID" NUMBER(*,0), 
	"TERMINAL_ADDR" VARCHAR2(255 CHAR), 
	"TARGET_CODE" VARCHAR2(255 CHAR), 
	"SESSION_ID" VARCHAR2(128 CHAR), 
	"SERVICE_ID" VARCHAR2(64 CHAR), 
	"CONTENT_PROVIDER_ID" VARCHAR2(64 CHAR), 
	"ENTERTAINMENT_PROVIDER_ID" VARCHAR2(64 CHAR), 
	"ENTERTAINMENT_ASSET_ID" VARCHAR2(20 CHAR), 
	"ENTERTAINMENT_DURATION" VARCHAR2(64 CHAR), 
	"CLIENT_DT_STRING" VARCHAR2(64 CHAR), 
	"LOCAL_DT" TIMESTAMP (6) WITH TIME ZONE, 
	"LOCAL_DATE" DATE, 
	"LOCAL_HOUR" NUMBER(*,0), 
	"LOCAL_OFFSET" NUMBER(*,0), 
	"UTC_DT" TIMESTAMP (6), 
	"CREATED_BY" VARCHAR2(255 CHAR), 
	"CREATED_DT" TIMESTAMP (6), 
	"LAST_ETL_PROC_NAME" VARCHAR2(255 CHAR), 
	"LAST_ETL_DT" timestamp (6)
   );
   
Drop Table SCTE_RQST_OPPTY_TMP purge;   
   
  create table "DAI_ODS"."SCTE_RQST_OPPTY_TMP" 
 ("REQUEST_MESSAGE_ID" VARCHAR2(128 CHAR), 
	"OPPORTUNITY_ID" VARCHAR2(128 CHAR), 
	"SERVICE_REG_REF" VARCHAR2(128 CHAR), 
	"OPPORTUNITY_TYPE" VARCHAR2(32 CHAR), 
	"OPPORTUNITY_NUMBER" NUMBER(*,0), 
	"OPPORTUNITY_DURATION" VARCHAR2(64 CHAR), 
	"OPPORTUNITY_PLACEMENT_COUNT" NUMBER(*,0), 
	"CREATED_BY" VARCHAR2(255 CHAR), 
	"CREATED_DT" TIMESTAMP (6), 
	"LAST_ETL_PROC_NAME" VARCHAR2(255 CHAR), 
	"LAST_ETL_DT" timestamp (6)
   );