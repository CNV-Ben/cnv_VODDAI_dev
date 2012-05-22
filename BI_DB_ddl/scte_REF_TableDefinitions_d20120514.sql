---================================================================================================
---> https://forums.oracle.com/forums/thread.jspa?threadID=2144389
---> http://stackoverflow.com/questions/9814122/oracle-sql-inline-not-null-named-constraint
---================================================================================================
/*
   Prepared 15-MAY-2012 by Ben Aycrigg on my local oracle VM
*/   

CREATE TABLE CAMPAIGN 
   (ID				NUMBER(9,0)   constraint camp_id_nn      NOT NULL ENABLE, 
	NAME 			VARCHAR2(255) constraint camp_name_nn    NOT NULL ENABLE, 
	PROGRAMMER_ID	NUMBER(7,0)   constraint camp_prog_id_nn NOT NULL ENABLE,
	ORDER_ID 		VARCHAR2(50), 
	TYPE_CODE 		VARCHAR2(8)   constraint camp_type_cd_nn  NOT NULL,
	STATUSCODE 		VARCHAR2(8)   constraint camp_stat_cd_nn  NOT NULL,
	GOALTYPE 		VARCHAR2(8)   constraint camp_goaltype_nn NOT NULL,
	START_DATE 		TIMESTAMP (6) constraint camp_start_dt_nn NOT NULL ENABLE,
	FINAL_DATE 		TIMESTAMP (6) constraint camp_final_dt_nn NOT NULL ENABLE,
	DESCRIPTION 	VARCHAR2(255)
   );
   
   
CREATE TABLE CAMPAIGN_ITEM 
   (ID						NUMBER(9,0)  constraint camp_item_id_nn       NOT NULL ENABLE, 
	CAMPAIGN_ID				NUMBER(9.0)  constraint camp_item_camp_id_nn  NOT NULL ENABLE, 
	START_DATE				TIMESTAMP(6) constraint camp_item_start_dt_nn NOT NULL ENABLE, 
	FINAL_DATE				TIMESTAMP(6) constraint camp_item_final_dt_nn NOT NULL ENABLE, 
	ACTIVE					NUMBER(1,0)  constraint camp_item_active_nn   NOT NULL ENABLE, 
	TRICKMODE				NUMBER(1,0)  constraint camp_item_trick_nn    NOT NULL ENABLE, 
	CATEGORY_ID				NUMBER(9,0)  constraint camp_item_cat_id_nn   NOT NULL ENABLE, 
	CATEGORY_EXCLUSION		NUMBER(1,0)  constraint camp_item_cat_exc_nn  NOT NULL ENABLE, 
	CATEGORYEXCLUSIONSCOPE	VARCHAR2(8), 
	PRIORITY				NUMBER(38,0) constraint camp_item_prty_nn     NOT NULL ENABLE, 
	VALUE					NUMBER(38,0) constraint camp_item_value_nn    NOT NULL ENABLE, 
	STRATEGY				VARCHAR2(8)  constraint camp_item_strategy_nn NOT NULL ENABLE, 
	GOAL					NUMBER(38,0)
   );
   
   
CREATE TABLE MEDIA_ASSET
  (	ID 				NUMBER(9,0)  NOT NULL ENABLE, 
	ASSET_IDSTRING	VARCHAR2(20) NOT NULL ENABLE, 
	PROVIDER_ID		VARCHAR2(64) NOT NULL ENABLE, 
	TYPE			VARCHAR2(8)  NOT NULL ENABLE, 
	SEPARATION		VARCHAR2(8)  NOT NULL ENABLE, 
	DURATION		NUMBER(38,0) NOT NULL ENABLE, 
	ISCI			VARCHAR2(255), 
	AD_ID			VARCHAR2(255), 
	VIDEO_DEF		VARCHAR2(8)
   );
   
   
CREATE TABLE MEDIA_ASSET_METADATA_VALUE
  (	ID                NUMBER(38,0)  NOT NULL ENABLE, 
	MEDIA_ASSET_ID    NUMBER        NOT NULL ENABLE, 
	METADATA_FIELD_ID NUMBER        NOT NULL ENABLE, 
	VALUE             VARCHAR2(255) NOT NULL ENABLE, 
	AGENT_NAME        VARCHAR2(100) NOT NULL ENABLE, 
	AGENT_SOURCE      VARCHAR2(255) NOT NULL ENABLE
   );   
      
   

CREATE TABLE NETWORK
   (ID 				NUMBER(9,0)  constraint ntwk_id_nn      NOT NULL ENABLE, 
	PROGRAMMER_ID	NUMBER(9,0)  constraint ntwk_prog_id_nn NOT NULL ENABLE, 
	NAME			VARCHAR2(32) constraint ntwk_name_nn    NOT NULL ENABLE
   );
   

CREATE TABLE OPERATOR
   (ID				NUMBER(9,0)  constraint oper_id_nn      NOT NULL ENABLE, 
	COMPANY_NAME	VARCHAR2(64) constraint oper_co_name_nn NOT NULL ENABLE
   );
   

CREATE TABLE PROGRAMMER
   (ID			NUMBER(9,0)  constraint programmer_id_nn         NOT NULL ENABLE, 
	NAME		VARCHAR2(64) constraint programmer_name_nn       NOT NULL ENABLE, 
	SHORT_NAME	VARCHAR2(64) constraint programmer_short_name_nn NOT NULL ENABLE
   );
   
   
CREATE TABLE PROVIDER
   (ID		VARCHAR2(64) constraint provider_id_nn     NOT NULL ENABLE, 
	ACTIVE	NUMBER(1,0)  constraint provider_active_nn NOT NULL ENABLE
   );
   
   
CREATE TABLE PROVIDER_NETWORK
 (PROVIDER_ID VARCHAR2(64) constraint prov_ntwk_prov_id_nn NOT NULL ENABLE, 
  NETWORK_ID  NUMBER(9,0)  constraint prov_ntwk_ntwk_id_nn NOT NULL ENABLE
 );
  

CREATE TABLE VOD_ENDPOINT
  (	ID							NUMBER(9,0)   NOT NULL ENABLE,
	URL							VARCHAR2(255) NOT NULL ENABLE,
	IDENTITY					VARCHAR2(255) NOT NULL ENABLE,
	OPERATOR_ID					NUMBER(9,0),
	ACTIVE						NUMBER(1,0)   NOT NULL ENABLE,
	TYPE_DISCRIMINATOR			VARCHAR2(8)   NOT NULL ENABLE,
	STATUS_CHECK_TYPE			VARCHAR2(8),
	OPERATOR_CIS_ID				NUMBER(9,0),
	NAME_QUALIFIER				VARCHAR2(255),
	SERVICE_NAME				VARCHAR2(48),
	PORT_NAME					VARCHAR2(48),
	AUTH						VARCHAR2(128),
	PARENT_ADM_ID				NUMBER(9,0),
	PLACEMENT_ADSENDPOINT_ID	NUMBER(9,0),
	PSN_ADSENDPOINT_ID			NUMBER(9,0),
	DEREG_ADSENDPOINT_ID		NUMBER(9,0),
	SSN_ADSENDPOINT_ID			NUMBER(9,0),
	DEFAULT_ADSENDPOINT_ID		NUMBER(9,0),
	SCR_ADSENDPOINT_ID			NUMBER(9,0)
  );
  
  