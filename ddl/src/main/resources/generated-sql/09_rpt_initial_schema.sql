-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: src/main/resources/liquibase/master-changelog.xml
-- Ran at: 4/3/12 7:06 PM
-- Against: DAI_ODS@jdbc:oracle:thin:@oraclehost:1521:xe
-- Liquibase version: 2.0.1
-- *********************************************************************

-- Create Database Lock Table
CREATE TABLE DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED NUMBER(1) NOT NULL, LOCKGRANTED TIMESTAMP, LOCKEDBY VARCHAR2(255), CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

INSERT INTO DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

-- Lock Database
-- Create Database Change Log Table
CREATE TABLE DATABASECHANGELOG (ID VARCHAR2(63) NOT NULL, AUTHOR VARCHAR2(63) NOT NULL, FILENAME VARCHAR2(200) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR2(10) NOT NULL, MD5SUM VARCHAR2(35), DESCRIPTION VARCHAR2(255), COMMENTS VARCHAR2(255), TAG VARCHAR2(255), LIQUIBASE VARCHAR2(20), CONSTRAINT PK_DATABASECHANGELOG PRIMARY KEY (ID, AUTHOR, FILENAME));

-- Changeset src/main/resources/liquibase/dai-ods-0.9/001-jma-create_scte_request.sql::001_1::jma::(Checksum: 3:8c7b73dfeabf55386cb5aee519591a72)
CREATE TABLE SCTE_REQUEST (
    MESSAGE_ID                 VARCHAR2 (128 CHAR) not null,
    VERSION                    VARCHAR2 (  8 CHAR) not null,
    IDENTITY                   VARCHAR2 (255 CHAR) not null,
    IDENTITY_VOD_ENDPT_ID      INTEGER,
    ADM_DATA                   VARCHAR2 (255 CHAR) not null,
    ADM_DATA_VOD_ENDPT_ID      INTEGER,
    TERMINAL_ADDR              VARCHAR2 (255 CHAR) not null,
    TARGET_CODE                VARCHAR2 (255 CHAR) not null,
    SESSION_ID                 VARCHAR2 (128 CHAR) not null,
    SERVICE_ID                 VARCHAR2 ( 64 CHAR),
    CONTENT_PROVIDER_ID        VARCHAR2 ( 64 CHAR),
    ENTERTAINMENT_PROVIDER_ID  VARCHAR2 ( 64 CHAR) not null,
    ENTERTAINMENT_ASSET_ID     VARCHAR2 ( 20 CHAR) not null,
    ENTERTAINMENT_DURATION     VARCHAR2 ( 64 CHAR) not null,
    CLIENT_DT_STRING           VARCHAR2 ( 64 CHAR) not null,
    LOCAL_DT                   TIMESTAMP with TIME ZONE,
    LOCAL_DATE                 DATE,
    LOCAL_HOUR                 INTEGER,
    LOCAL_OFFSET               INTEGER,
    UTC_DT                     TIMESTAMP,
    CREATED_BY                 VARCHAR2 (255 CHAR) not null,
    CREATED_DT                 TIMESTAMP           not null,
    LAST_ETL_PROC_NAME         VARCHAR2 (255 CHAR) not null,
    LAST_ETL_DT                TIMESTAMP           not null,
 CONSTRAINT PK_SCTE_REQUEST PRIMARY KEY (MESSAGE_ID)
);

CREATE TABLE SCTE_REQUEST_OPPORTUNITY (
    REQUEST_MESSAGE_ID          VARCHAR2 (128 CHAR) not null,
    OPPORTUNITY_ID              VARCHAR2 (128 CHAR) not null,
    SERVICE_REG_REF             VARCHAR2 (128 CHAR) not null,
    OPPORTUNITY_TYPE            VARCHAR2 ( 32 CHAR) not null,
    OPPORTUNITY_NUMBER          INTEGER,
    OPPORTUNITY_DURATION        VARCHAR2 ( 64 CHAR) not null,
    OPPORTUNITY_PLACEMENT_COUNT INTEGER,
    CREATED_BY                  VARCHAR2 (255 CHAR) not null,
    CREATED_DT                  TIMESTAMP           not null,
    LAST_ETL_PROC_NAME          VARCHAR2 (255 CHAR) not null,
    LAST_ETL_DT                 TIMESTAMP           not null,
 CONSTRAINT uq_scte_req_opp UNIQUE (REQUEST_MESSAGE_ID, OPPORTUNITY_ID)
);

INSERT INTO DATABASECHANGELOG (AUTHOR, COMMENTS, DATEEXECUTED, DESCRIPTION, EXECTYPE, FILENAME, ID, LIQUIBASE, MD5SUM, ORDEREXECUTED) VALUES ('jma', '', SYSTIMESTAMP, 'Custom SQL', 'EXECUTED', 'src/main/resources/liquibase/dai-ods-0.9/001-jma-create_scte_request.sql', '001_1', '2.0.1', '3:8c7b73dfeabf55386cb5aee519591a72', 1);

-- Changeset src/main/resources/liquibase/dai-ods-0.9/002-jma-create_scte_response.sql::002_1::jma::(Checksum: 3:3300271b91d42401c8d847b2335ae101)
CREATE TABLE SCTE_RESPONSE
  ( MESSAGE_ID          VARCHAR2 (128 CHAR) not null,
    REQUEST_MESSAGE_ID  VARCHAR2 (128 CHAR) not null,
    VERSION             VARCHAR2 (  8 CHAR) not null,
    IDENTITY            VARCHAR2 (255 CHAR) not null,
    STATUS_CODE_CLASS   INTEGER             not null,
    SESSION_ID          VARCHAR2 (128 CHAR) not null,
    CREATED_BY          VARCHAR2 (255 CHAR) not null,
    CREATED_DT          TIMESTAMP           not null,
    LAST_ETL_PROC_NAME  VARCHAR2 (255 CHAR) not null,
    LAST_ETL_DT         TIMESTAMP           not null,
 CONSTRAINT PK_SCTE_RESPONSE PRIMARY KEY (MESSAGE_ID)
);

CREATE TABLE SCTE_RESPONSE_PLACEMENT
  ( RESPONSE_MESSAGE_ID   VARCHAR2 (128 CHAR) not null,
    SESSION_ID            VARCHAR2 (128 CHAR) not null,
    DECISION_ID           VARCHAR2 (128 CHAR) not null,
    OPPORTUNITY_ID        VARCHAR2 (128 CHAR) not null,
    PLACEMENT_ID          VARCHAR2 (128 CHAR) null,
    PLACEMENT_ACTION      VARCHAR2 ( 32 CHAR) null,
    PLACEMENT_POS         INTEGER             null,
    TRACKING_ID           VARCHAR2 (128 CHAR) null,
    TRACKING_ASSET_ID     VARCHAR2 (128 CHAR) null,
    TRACKING_PROVIDER_ID  VARCHAR2 ( 64 CHAR) null,
    CREATED_BY            VARCHAR2 (255 CHAR) not null,
    CREATED_DT            TIMESTAMP           not null,
    LAST_ETL_PROC_NAME    VARCHAR2 (255 CHAR) not null,
    LAST_ETL_DT           TIMESTAMP           not null,
  CONSTRAINT uq_scte_resp_placement UNIQUE (RESPONSE_MESSAGE_ID, DECISION_ID)
);

INSERT INTO DATABASECHANGELOG (AUTHOR, COMMENTS, DATEEXECUTED, DESCRIPTION, EXECTYPE, FILENAME, ID, LIQUIBASE, MD5SUM, ORDEREXECUTED) VALUES ('jma', '', SYSTIMESTAMP, 'Custom SQL', 'EXECUTED', 'src/main/resources/liquibase/dai-ods-0.9/002-jma-create_scte_response.sql', '002_1', '2.0.1', '3:3300271b91d42401c8d847b2335ae101', 2);

-- Changeset src/main/resources/liquibase/dai-ods-0.9/003-jma-create_scte_psn.sql::003_1::jma::(Checksum: 3:9d86e3c6f69193df3f0fa6061c99cba8)
CREATE TABLE SCTE_PSN
  ( MESSAGE_ID             VARCHAR2 (128 CHAR) not null,
    VERSION                VARCHAR2 (  8 CHAR) not null,
    PLAYDATA_IDENTITY      VARCHAR2 (255 CHAR) not null,
    PLAYDATA_SESSION_ID    VARCHAR2 (128 CHAR) not null,
    PLAYDATA_SERVICE_GROUP VARCHAR2 (128 CHAR) null,
    PSE_EVENT_TYPE         VARCHAR2 (128 CHAR) not null,
    PSE_STATUSCODE_CLASS   INTEGER             null,
    PSE_EVENT_DT_STRING    VARCHAR2 (128 CHAR) not null,
    PSE_EVENT_LOCAL_DT     TIMESTAMP with TIME ZONE,
    PSE_EVENT_LOCAL_DATE   DATE,
    PSE_EVENT_LOCAL_HOUR   INTEGER,
    PSE_EVENT_LOCAL_OFFSET INTEGER,
    PSE_EVENT_UTC_DT       TIMESTAMP,
    SPOT_NPT_SCALE         NUMBER,
    SPOT_NPT_VALUE         NUMBER,
    ACTUAL_TRACKING_ID     VARCHAR2 (128 CHAR) null,
    ACTUAL_ASSET_ID        VARCHAR2 (128 CHAR) null,
    ACTUAL_PROVIDER_ID     VARCHAR2 ( 64 CHAR) null,
    OPPORTUNITY_ID         VARCHAR2 (128 CHAR) null,
    CREATED_BY             VARCHAR2 (255 CHAR) not null,
    CREATED_DT             TIMESTAMP           not null,
    LAST_ETL_PROC_NAME     VARCHAR2 (255 CHAR) not null,
    LAST_ETL_DT            TIMESTAMP           not null
);

INSERT INTO DATABASECHANGELOG (AUTHOR, COMMENTS, DATEEXECUTED, DESCRIPTION, EXECTYPE, FILENAME, ID, LIQUIBASE, MD5SUM, ORDEREXECUTED) VALUES ('jma', '', SYSTIMESTAMP, 'Custom SQL', 'EXECUTED', 'src/main/resources/liquibase/dai-ods-0.9/003-jma-create_scte_psn.sql', '003_1', '2.0.1', '3:9d86e3c6f69193df3f0fa6061c99cba8', 3);

