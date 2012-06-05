--liquibase formatted sql

--changeset jma:002_1 dbms:oracle

-- Comments:
--    Create SCTE_RESPONSE, SCTE_RESPONSE_PLACEMENT tables for XML processing of PlacementResponse messages.
--
CREATE TABLE SCTE_RESPONSE
(MESSAGE_ID	    VARCHAR2(128 CHAR) NOT NULL ENABLE,
 REQUEST_MESSAGE_ID VARCHAR2(128 CHAR) NOT NULL ENABLE,
 VERSION	    VARCHAR2(8   CHAR) NOT NULL ENABLE,
 IDENTITY	    VARCHAR2(32  CHAR) NOT NULL ENABLE,
 STATUS_CODE_CLASS  NUMBER(3,0)        NOT NULL ENABLE,
 SESSION_ID	    VARCHAR2(128 CHAR) NOT NULL ENABLE,
 CREATED_BY	    VARCHAR2(64  CHAR) NOT NULL ENABLE,
 CREATED_DT	    TIMESTAMP(6)       NOT NULL ENABLE,
 LAST_ETL_PROC_NAME VARCHAR2(320 CHAR) NOT NULL ENABLE,
 LAST_ETL_DT        TIMESTAMP(6)       NOT NULL ENABLE,
 CONSTRAINT PK_SCTE_RESPONSE PRIMARY KEY (MESSAGE_ID)
);

CREATE TABLE SCTE_RESPONSE_PLACEMENT
(RESPONSE_MESSAGE_ID  VARCHAR2(128 CHAR) NOT NULL ENABLE,
 SESSION_ID	      VARCHAR2(128 CHAR) NOT NULL ENABLE,
 DECISION_ID	      VARCHAR2(64  CHAR) NOT NULL ENABLE,
 OPPORTUNITY_ID	      VARCHAR2(64  CHAR) NOT NULL ENABLE,
 PLACEMENT_ID	      VARCHAR2(64  CHAR),
 PLACEMENT_ACTION     VARCHAR2(16  CHAR),
 PLACEMENT_POS	      NUMBER(3,0),
 TRACKING_ID	      VARCHAR2(64  CHAR),
 TRACKING_ASSET_ID    VARCHAR2(32  CHAR),
 TRACKING_PROVIDER_ID VARCHAR2(64  CHAR),
 CREATED_BY           VARCHAR2(64  CHAR) NOT NULL ENABLE,
 CREATED_DT           TIMESTAMP(6)       NOT NULL ENABLE,
 LAST_ETL_PROC_NAME   VARCHAR2(320 CHAR) NOT NULL ENABLE,
 LAST_ETL_DT	      TIMESTAMP(6)       NOT NULL ENABLE,
 CONSTRAINT uq_scte_resp_placement UNIQUE (RESPONSE_MESSAGE_ID, DECISION_ID)
);




