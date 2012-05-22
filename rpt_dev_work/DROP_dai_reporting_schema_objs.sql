begin
for X in (select TABLE_NAME, CONSTRAINT_NAME from USER_CONSTRAINTS
          where CONSTRAINT_TYPE = 'R' and STATUS = 'ENABLED')
LOOP
 execute immediate 'alter table '||X.TABLE_NAME||' disable constraint '||X.CONSTRAINT_NAME;
end LOOP;
end;
/

---select TABLE_NAME, CONSTRAINT_NAME from USER_CONSTRAINTS where STATUS = 'ENABLED'


---select * from user_tables
drop table MEDIA_ASSET_METADATA      purge
drop table METADATA_VALUE            purge
drop table METADATA_TYPE_ELEMENT     purge
drop table METADATA_TARGET_ELEMENT   purge
drop table METADATA_TARGET           purge
drop table METADATA_ELEMENT          purge
drop table VOD_ENDPOINT_STATUS       purge
drop table PRODUCT_CATEGORY_EXCLUDED purge
drop table SERVICE_GROUP             purge
drop table REVIEW_CAMPAIGN           purge
drop table PROGRAMMER_RANKING        purge
drop table VOD_ENDPOINT              purge
drop table operator                 purge
drop table CAMPAIGN_NOTES            purge
drop table CAMPAIGN_ITEM_TIME        purge
drop table CAMPAIGN_ITEM_NET         purge
drop table CAMPAIGN_ITEM_MEDIA_ASSET purge
drop table MEDIA_ASSET               purge
drop table CAMPAIGN_ITEM_GOAL_DAILY  purge
drop table CAMPAIGN_ITEM_GOAL        purge
drop table CAMPAIGN_ITEM_BREAK_POS   purge
drop table CAMPAIGN_ITEM             purge
drop table CAMPAIGN                  purge
drop table network                  purge
drop table PROGRAMMER                purge
drop table PRODUCT_CATEGORY          purge
---------------------------------
drop table DATABASECHANGELOG         purge
drop table DATABASECHANGELOGLOCK     purge


/*
select 'drop sequence '||sequence_name||' purge;'
from user_sequences
order by sequence_name
*/

drop sequence HIBERNATE_SEQUENCE            ;
drop sequence SEQ_CAMPAIGN_ID               ;
drop sequence SEQ_CAMPAIGN_ITEM_BREAK_POS_ID;
drop sequence SEQ_CAMPAIGN_ITEM_ID          ;
drop sequence SEQ_CAMPAIGN_ITEM_MEDIA_ASSET ;
drop sequence SEQ_MEDIA_ASSET_ID            ;
drop sequence SEQ_MEDIA_ASSET_METADATA      ;
drop sequence SEQ_METADATA_ELEMENT_ID       ;
drop sequence SEQ_METADATA_TARGET_ID        ;
drop sequence SEQ_METADATA_TYPE_ELEMENT_ID  ;
drop sequence SEQ_METADATA_VALUE_ID         ;
drop sequence SEQ_NETWORK_ID                ;
drop sequence SEQ_OPERATOR_ID               ;
drop sequence SEQ_PRODUCT_CATEGORY_ID       ;
drop sequence SEQ_PROGRAMMER_ID             ;
drop sequence SEQ_PROVIDER_ID               ;
drop sequence SEQ_SERVICE_GROUP_ID          ;
drop sequence SEQ_VOD_ENDPOINT_ID           ;


--select * from user_objects
--select * from user_recyclebin
--purge recyclebin


