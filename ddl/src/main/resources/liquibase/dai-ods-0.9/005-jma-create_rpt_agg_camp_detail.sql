--liquibase formatted sql
--changeset jma:005_1 dbms:oracle

-- Comments:
--    Create RPT_AGG_CAMPAIGN_DETAIL table.
--

CREATE TABLE RPT_AUDIT_AGG_CAMPAIGN_DETAIL
(  CAMPAIGN_ID       number(6,0)   not null,
   CAMPAIGN_ITEM_ID  number(6,0)   not null,
   MEDIA_ASSET_ID    number(6,0)   not null,
   OPERATOR          VARCHAR2(32)  not null,
   SERVICE_GROUP     VARCHAR2(16)  null,
   DATE_HOUR         DATE          not null,
   INSERT_COUNT      INTEGER       not null,
   VIEW_COUNT        INTEGER       not null,
 CONSTRAINT uq_rpt_agg_camp_dtl UNIQUE
    (CAMPAIGN_ID, CAMPAIGN_ITEM_ID, MEDIA_ASSET_ID, OPERATOR, SERVICE_GROUP, DATE_HOUR)
);

/*  Ben Aycrigg removed these Tables from this script 11-MAY-2012 as
    none of these are being used in the 0.9 VOD-DAI reporting release.
CREATE TABLE RPT_SCTE_XML_PROC_RUN
(  ID                   INTEGER            not null,
   CREATED_BY           VARCHAR2(255 CHAR) not null,
   CREATED_DT           TIMESTAMP(6)       not null,
   LAST_ETL_PROC_NAME   VARCHAR2(255 CHAR) not null,
   LAST_ETL_DT          TIMESTAMP(6)       not null,
   PRIMARY KEY   (ID)
);

CREATE TABLE RPT_SCTE_XML_PROC_RUN_FILES
(  XML_PROC_RUN_ID      INTEGER            not null,
   XML_FILENAME         VARCHAR2(255 CHAR) not null,
   CREATED_BY           VARCHAR2(255 CHAR) not null,
   CREATED_DT           TIMESTAMP(6)       not null
);

CREATE TABLE SCHED_REPORT_JOB
(  ID                   INTEGER            not null,
   START_DATE_HOUR      DATE               not null,
   END_DATE_HOUR        DATE               not null,
   RPT_TEMPLATE_ID      INTEGER            not null,
   GEN_RPT_FILENAME     VARCHAR2(255 CHAR) null,
   IS_READY             NUMBER(1,0)        not null,
   CREATED_DT           TIMESTAMP(6)       not null,
   LAST_ETL_PROC_NAME   VARCHAR2(255 CHAR) not null,
   LAST_ETL_DT          TIMESTAMP(6)       not null,
   PRIMARY KEY   (ID)
);

CREATE TABLE SCHED_REPORT_JOB_PARAM
(  SCHE_RPT_JOB_ID      NUMBER(5,0)        not null,
   PARAM_NAME           VARCHAR2(255 CHAR) not null,
   PARAM_VALUE          VARCHAR2(255 CHAR) null,
   PARAM_ORDER          NUMBER(3,0)
);

CREATE TABLE RPT_TEMPLATE_DEF
(  ID                   NUMBER(5,0)        not null,
   TEMPLATE_NAME        VARCHAR2(255)      null,
   TEMPLATE_VERSION     VARCHAR2(255)      null,
   CREATED_BY           VARCHAR2(255 CHAR) not null,
   CREATED_DT           TIMESTAMP(6)       not null
);

CREATE TABLE RPT_TEMPLATE_DEF_PARAM
(  TEMPLATE_ID           NUMBER(5,0)        not null,
   TEMPLATE_PARAM_NAME   VARCHAR2(255 CHAR) not null,
   TEMPLATE_PARAM_ORDER  NUMBER(3,0)        not null,
   CREATED_BY            VARCHAR2(255 CHAR) not null,
   CREATED_DT            TIMESTAMP(6)       not null
);
*/