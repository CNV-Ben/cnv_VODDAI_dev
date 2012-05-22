create user DAI_REPORTING identified by DAI_RPTG
  default tablespace USERS
  temporary tablespace TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
GRANT CREATE VIEW TO dai_reporting_ods;
GRANT UNLIMITED TABLESPACE TO dai_reporting_ods;
GRANT CONNECT TO dai_reporting_ods;
GRANT RESOURCE TO dai_reporting_ods;
ALTER USER dai_reporting_ods DEFAULT ROLE CONNECT, RESOURCE;


create user DAI_REPORTING_ODS identified by DAI_ODS
  default tablespace USERS
  temporary tablespace TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
GRANT CREATE VIEW TO dai_reporting_ods;
GRANT UNLIMITED TABLESPACE TO dai_reporting_ods;
GRANT CONNECT TO dai_reporting_ods;
GRANT RESOURCE TO dai_reporting_ods;
ALTER USER dai_reporting_ods DEFAULT ROLE CONNECT, RESOURCE;



select
 username, user_id, account_status ACCT_STATUS, created, profile, expiry_date,
 default_tablespace DEFAULT_T_SPACE, temporary_tablespace TEMP_T_SPACE
from dba_users
where username like 'DAI%'
order by 1
   
/*
USERNAME			USER_ID		ACCT_STATUS	CREATED		PROFILE		EXPIRY_DATE		DEFAULT_T_SPACE		TEMP_T_SPACE
DAI_ODS				177			OPEN		04/03/2012	DEFAULT		09/30/2012			USERS				TEMP
DAI_REPORTING		183			OPEN		05/16/2012	DEFAULT		11/12/2012			USERS				TEMP
DAI_REPORTING_ODS	181			OPEN		05/16/2012	DEFAULT		11/12/2012			USERS				TEMP
--===============================================================================================================
DAI_RPTG			179			OPEN		04/06/2012	DEFAULT		10/22/2012			USERS				TEMP
DAI_USER			173			OPEN		04/03/2012	DEFAULT		11/06/2012			USERS				TEMP
*/



select
 owner, object_type TYPO,
 case when object_type = 'TABLE'        then '1.00'
      when object_type = 'VIEW'         then '1.10'
      when object_type = 'SYNONYM'      then '1.20'
      when object_type = 'PACKAGE'      then '2.00'
      when object_type = 'PACKAGE BODY' then '2.10'
      when object_type = 'PROCEDURE'    then '2.20'
      when object_type = 'FUNCTION'     then '2.25' 
      when object_type = 'TRIGGER'      then '2.50'
      when object_type = 'INDEX'        then '3.00'
      when object_type = 'TABLE PARTITION' then '4.00'
      when object_type = 'INDEX PARTITION' then '4.10'
      when object_type = 'DATABASE LINK'   then '5.00'
      when object_type = 'SEQUENCE'        then '6.00'
 else '99' end as obj_oda,
 object_name, created, timestamp
from DBA_OBJECTS
--where owner in ('DAI_USER')
where owner = 'DAI_REPORTING'
order by 3, 4

/*   Ten Tables:

OWNER			TYPO	OBJ_ODA		OBJECT_NAME					CREATED			TIMESTAMP
--------------  -----	-------		------------------			-----------		---------------------------
DAI_REPORTING	TABLE	1.00		CAMPAIGN					05/16/2012		2012-05-16:11:41:22
DAI_REPORTING	TABLE	1.00		CAMPAIGN_ITEM				05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		MEDIA_ASSET					05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		MEDIA_ASSET_METADATA_VALUE	05/16/2012		2012-05-16:11:51:21
DAI_REPORTING	TABLE	1.00		NETWORK						05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		OPERATOR					05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		PROGRAMMER					05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		PROVIDER					05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		PROVIDER_NETWORK			05/16/2012		2012-05-16:11:41:23
DAI_REPORTING	TABLE	1.00		VOD_ENDPOINT				05/16/2012		2012-05-16:11:41:23
 
Perfect!
*/


select
 owner, object_type TYPO,
 case when object_type = 'TABLE'        then '1.00'
      when object_type = 'VIEW'         then '1.10'
      when object_type = 'SYNONYM'      then '1.20'
      when object_type = 'PACKAGE'      then '2.00'
      when object_type = 'PACKAGE BODY' then '2.10'
      when object_type = 'PROCEDURE'    then '2.20'
      when object_type = 'FUNCTION'     then '2.25' 
      when object_type = 'TRIGGER'      then '2.50'
      when object_type = 'INDEX'        then '3.00'
      when object_type = 'TABLE PARTITION' then '4.00'
      when object_type = 'INDEX PARTITION' then '4.10'
      when object_type = 'DATABASE LINK'   then '5.00'
      when object_type = 'SEQUENCE'        then '6.00'
 else '99' end as obj_oda,
 object_name, created, timestamp
from DBA_OBJECTS
where owner = 'DAI_REPORTING_ODS'
order by 3, 4

grant select on dai_reporting.CAMPAIGN                   to dai_reporting_ods;
grant select on dai_reporting.CAMPAIGN_ITEM              to dai_reporting_ods;
grant select on dai_reporting.MEDIA_ASSET                to dai_reporting_ods;
grant select on dai_reporting.MEDIA_ASSET_METADATA_VALUE to dai_reporting_ods;
grant select on dai_reporting.NETWORK                    to dai_reporting_ods;
grant select on dai_reporting.OPERATOR                   to dai_reporting_ods;
grant select on dai_reporting.PROGRAMMER                 to dai_reporting_ods;
grant select on dai_reporting.PROVIDER                   to dai_reporting_ods;
grant select on dai_reporting.PROVIDER_NETWORK           to dai_reporting_ods;
grant select on dai_reporting.VOD_ENDPOINT               to dai_reporting_ods;




/*
---=================================================================================
--- 05/16/2012
--- DAI_REPORTING_ODS needs these Tables, and I need to DROP them from DAI_ODS:
---============================================================================
SCTE_REQUEST
SCTE_REQUEST_OPPORTUNITY
SCTE_RESPONSE
SCTE_RESPONSE_PLACEMENT
SCTE_PSN
AGG_CAMPAIGN_RPTG   ----> re-named to RPT_AUDIT_AGG_CAMPAIGN_DETAIL to conform to Rick's naming convention.
*/

--- Logged in as DAI_REPORTING_ODS (dai_rptg):


CREATE TABLE dai_reporting_ods.SCTE_REQUEST
   (MESSAGE_ID				  VARCHAR2(128) NOT NULL ENABLE, 
	VERSION					  VARCHAR2(8)   NOT NULL ENABLE, 
	IDENTITY				  VARCHAR2(32)  NOT NULL ENABLE, 
	IDENTITY_VOD_ENDPT_ID	  NUMBER(5,0), 
	ADM_DATA				  VARCHAR2(64)  NOT NULL ENABLE, 
	ADM_DATA_VOD_ENDPT_ID	  NUMBER(5,0), 
	TERMINAL_ADDR			  VARCHAR2(128) NOT NULL ENABLE, 
	TARGET_CODE				  VARCHAR2(64)  NOT NULL ENABLE, 
	SESSION_ID				  VARCHAR2(128) NOT NULL ENABLE, 
	SERVICE_ID				  VARCHAR2(32), 
	CONTENT_PROVIDER_ID		  VARCHAR2(64), 
	ENTERTAINMENT_PROVIDER_ID VARCHAR2(64)  NOT NULL ENABLE, 
	ENTERTAINMENT_ASSET_ID	  VARCHAR2(64)  NOT NULL ENABLE, 
	ENTERTAINMENT_DURATION    VARCHAR2(32)  NOT NULL ENABLE, 
	CLIENT_DT_STRING		  VARCHAR2(32)  NOT NULL ENABLE, 
	CREATED_BY				  VARCHAR2(64), 
	CREATED_DT				  TIMESTAMP(6)  DEFAULT systimestamp NOT NULL ENABLE, 
	LAST_ETL_PROC_NAME		  VARCHAR2(320) NOT NULL ENABLE, 
	LAST_ETL_DT				  TIMESTAMP(6)  DEFAULT systimestamp NOT NULL ENABLE, 
	CONSTRAINT PK_SCTE_REQUEST PRIMARY KEY (MESSAGE_ID) ENABLE
   ) ;
   

CREATE TABLE dai_reporting_ods.SCTE_REQUEST_OPPORTUNITY
   (REQUEST_MESSAGE_ID			VARCHAR2(128) NOT NULL ENABLE, 
	OPPORTUNITY_ID				VARCHAR2(96)  NOT NULL ENABLE, 
	SERVICE_REG_REF				VARCHAR2(96)  NOT NULL ENABLE, 
	OPPORTUNITY_TYPE			VARCHAR2(16)  NOT NULL ENABLE, 
	OPPORTUNITY_NUMBER			NUMBER(3,0), 
	OPPORTUNITY_DURATION		VARCHAR2(32)  NOT NULL ENABLE, 
	OPPORTUNITY_PLACEMENT_COUNT	NUMBER(3,0), 
	CREATED_BY					VARCHAR2(64)  NOT NULL ENABLE, 
	CREATED_DT					TIMESTAMP(6)  NOT NULL ENABLE, 
	LAST_ETL_PROC_NAME			VARCHAR2(320) NOT NULL ENABLE, 
	LAST_ETL_DT					TIMESTAMP(6)  NOT NULL ENABLE, 
	CONSTRAINT UQ_SCTE_REQ_OPP UNIQUE (REQUEST_MESSAGE_ID, OPPORTUNITY_ID) ENABLE
   );


CREATE TABLE dai_reporting_ods.SCTE_RESPONSE
   (MESSAGE_ID			VARCHAR2(128) NOT NULL ENABLE, 
	REQUEST_MESSAGE_ID	VARCHAR2(128) NOT NULL ENABLE, 
	VERSION				VARCHAR2(8)   NOT NULL ENABLE, 
	IDENTITY			VARCHAR2(32)  NOT NULL ENABLE, 
	STATUS_CODE_CLASS	NUMBER(3,0)   NOT NULL ENABLE, 
	SESSION_ID			VARCHAR2(128) NOT NULL ENABLE, 
	CREATED_BY			VARCHAR2(64)  NOT NULL ENABLE, 
	CREATED_DT			TIMESTAMP(6)  NOT NULL ENABLE, 
	LAST_ETL_PROC_NAME	VARCHAR2(320) NOT NULL ENABLE, 
	LAST_ETL_DT			TIMESTAMP(6)  NOT NULL ENABLE, 
	CONSTRAINT PK_SCTE_RESPONSE PRIMARY KEY (MESSAGE_ID) ENABLE
   );


CREATE TABLE dai_reporting_ods.SCTE_RESPONSE_PLACEMENT
   (RESPONSE_MESSAGE_ID  VARCHAR2(128) NOT NULL ENABLE, 
	SESSION_ID           VARCHAR2(128) NOT NULL ENABLE, 
	DECISION_ID          VARCHAR2(64)  NOT NULL ENABLE, 
	OPPORTUNITY_ID       VARCHAR2(64)  NOT NULL ENABLE, 
	PLACEMENT_ID         VARCHAR2(64), 
	PLACEMENT_ACTION     VARCHAR2(16), 
	PLACEMENT_POS        NUMBER(3,0), 
	TRACKING_ID          VARCHAR2(64), 
	TRACKING_ASSET_ID    VARCHAR2(32), 
	TRACKING_PROVIDER_ID VARCHAR2(64), 
	CREATED_BY           VARCHAR2(64)  NOT NULL ENABLE, 
	CREATED_DT           TIMESTAMP(6)  NOT NULL ENABLE, 
	LAST_ETL_PROC_NAME   VARCHAR2(320) NOT NULL ENABLE, 
	LAST_ETL_DT          TIMESTAMP(6)  NOT NULL ENABLE, 
	CONSTRAINT UQ_SCTE_RESP_PLACEMENT UNIQUE (DECISION_ID, OPPORTUNITY_ID, PLACEMENT_ID) ENABLE
   );   



CREATE TABLE dai_reporting_ods.SCTE_PSN
   (MESSAGE_ID				VARCHAR2(128) NOT NULL ENABLE, 
	VERSION					VARCHAR2(8)   NOT NULL ENABLE, 
	PLAYDATA_IDENTITY		VARCHAR2(32)  NOT NULL ENABLE, 
	PLAYDATA_SESSION_ID		VARCHAR2(128) NOT NULL ENABLE, 
	PLAYDATA_SERVICE_GROUP	VARCHAR2(16), 
	PSE_EVENT_TYPE			VARCHAR2(16)  NOT NULL ENABLE, 
	PSE_STATUSCODE_CLASS	NUMBER(3,0), 
	PSE_EVENT_DT_STRING		VARCHAR2(32)  NOT NULL ENABLE, 
	SPOT_NPT_SCALE			NUMBER(3,0), 
	SPOT_NPT_VALUE			NUMBER(3,0), 
	ACTUAL_TRACKING_ID		VARCHAR2(64), 
	ACTUAL_ASSET_ID			VARCHAR2(64), 
	ACTUAL_PROVIDER_ID		VARCHAR2(64), 
	CREATED_BY				VARCHAR2(64)  NOT NULL ENABLE, 
	CREATED_DT				TIMESTAMP(6)  NOT NULL ENABLE, 
	LAST_ETL_PROC_NAME		VARCHAR2(320) NOT NULL ENABLE, 
	LAST_ETL_DT				TIMESTAMP(6)  NOT NULL ENABLE
   );	


CREATE TABLE dai_reporting_ods.RPT_AUDIT_AGG_CAMPAIGN_DETAIL
   (CAMPAIGN_ID      NUMBER(9,0)   NOT NULL ENABLE,
	CAMPAIGN_ITEM_ID NUMBER(9,0)   NOT NULL ENABLE, 
	MEDIA_ASSET_ID   NUMBER(9,0)   NOT NULL ENABLE, 
	OPERATOR         VARCHAR2(128) NOT NULL ENABLE, 
	SERVICE_GROUP    VARCHAR2(64)  NOT NULL ENABLE, 
	DATE_HOUR        DATE, 
	INSERT_COUNT     NUMBER(9,0), 
	VIEW_COUNT       NUMBER(9,0),
    CONSTRAINT rpt_agg_camp_dtl_uq UNIQUE
      (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, MEDIA_ASSET_ID, OPERATOR, SERVICE_GROUP, DATE_HOUR) ENABLE
   );
	









