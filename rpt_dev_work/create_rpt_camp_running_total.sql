CREATE TABLE RPT_CAMPAIGN_RUNNING_TOTAL(
   CAMPAIGN_ID       INTEGER   not null,
   CAMPAIGN_ITEM_ID  INTEGER   not null,
   MEDIA_ASSET_ID    INTEGER   not null,
   INSERT_COUNT      INTEGER   not null,
   VIEW_COUNT        INTEGER   not null,
   PROGRAMMER        VARCHAR2(255) not null,
   OPERATOR          VARCHAR2(255) not null,
   SERVICE_GROUP     VARCHAR2(255) null
);

   
