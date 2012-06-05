--liquibase formatted sql

--changeset jma:001_1 dbms:oracle

-- Comments:
--    Create SCTE_REQUEST and SCTE_REQUEST_OPPORTUNITY tables for XML processing of PlacementRequest messages.
--
CREATE TABLE SCTE_REQUEST
(MESSAGE_ID		   VARCHAR2(128 CHAR) NOT NULL ENABLE,
 VERSION		   VARCHAR2(8   CHAR) NOT NULL ENABLE,
 IDENTITY		   VARCHAR2(32  CHAR) NOT NULL ENABLE,
 IDENTITY_VOD_ENDPT_ID	   NUMBER(5,0),
 ADM_DATA		   VARCHAR2(64  CHAR) NOT NULL ENABLE,
 ADM_DATA_VOD_ENDPT_ID	   NUMBER(5,0),
 TERMINAL_ADDR	           VARCHAR2(128 CHAR) NOT NULL ENABLE,
 TARGET_CODE		   VARCHAR2(64  CHAR) NOT NULL ENABLE,
 SESSION_ID		   VARCHAR2(128 CHAR) NOT NULL ENABLE,
 SERVICE_ID		   VARCHAR2(32  CHAR),
 CONTENT_PROVIDER_ID	   VARCHAR2(64  CHAR),
 ENTERTAINMENT_PROVIDER_ID VARCHAR2(64  CHAR) NOT NULL ENABLE,
 ENTERTAINMENT_ASSET_ID	   VARCHAR2(64  CHAR) NOT NULL ENABLE,
 ENTERTAINMENT_DURATION	   VARCHAR2(32  CHAR) NOT NULL ENABLE,
 CLIENT_DT_STRING	   VARCHAR2(32  CHAR) NOT NULL ENABLE,
 LOCAL_TIMESTAMP           TIMESTAMP with TIME ZONE,		
 CREATED_BY     	   VARCHAR2(64  CHAR),
 CREATED_DT     	   TIMESTAMP(6) DEFAULT systimestamp NOT NULL ENABLE,
 LAST_ETL_PROC_NAME        VARCHAR2(255 CHAR) NOT NULL ENABLE,
 LAST_ETL_DT     	   TIMESTAMP(6) DEFAULT systimestamp NOT NULL ENABLE,
 CONSTRAINT PK_SCTE_REQUEST PRIMARY KEY (MESSAGE_ID)
);

CREATE TABLE SCTE_REQUEST_OPPORTUNITY
(REQUEST_MESSAGE_ID		VARCHAR2(128 CHAR) NOT NULL ENABLE,
 OPPORTUNITY_ID			VARCHAR2(96  CHAR) NOT NULL ENABLE,
 SERVICE_REG_REF		VARCHAR2(96  CHAR) NOT NULL ENABLE,
 OPPORTUNITY_TYPE		VARCHAR2(16  CHAR) NOT NULL ENABLE,
 OPPORTUNITY_NUMBER		NUMBER(3,0),
 OPPORTUNITY_DURATION		VARCHAR2(32  CHAR) NOT NULL ENABLE,
 OPPORTUNITY_PLACEMENT_COUNT	NUMBER(3,0),
 CREATED_BY     		VARCHAR2(64  CHAR) NOT NULL ENABLE,
 CREATED_DT     		TIMESTAMP(6)       NOT NULL ENABLE,
 LAST_ETL_PROC_NAME     	VARCHAR2(255 CHAR) NOT NULL ENABLE,
 LAST_ETL_DT     		TIMESTAMP(6)       NOT NULL ENABLE,
 CONSTRAINT uq_scte_req_opp UNIQUE (REQUEST_MESSAGE_ID, OPPORTUNITY_ID)
);