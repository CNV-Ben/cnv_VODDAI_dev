select sysdate from dual

select TABLE_NAME
from ALL_TABLES
where OWNER = 'DAI'
  and TABLE_NAME in
   ('CAMPAIGN', 'CAMPAIGN_ITEM', 'MEDIA_ASSET', 'MEDIA_ASSET_METADATA_VALUE',
    'NETWORK', 'OPERATOR', 'PROGRAMMER', 'PROVIDER', 'PROVIDER_NETWORK',
    'VOD_ENDPOINT')


create or replace synonym CAMPAIGN for DAI.CAMPAIGN
create or replace synonym CAMPAIGN_ITEM for DAI.CAMPAIGN_ITEM
create or replace synonym MEDIA_ASSET for DAI.MEDIA_ASSET
create or replace synonym MEDIA_ASSET_METADATA_VALUE for DAI.MEDIA_ASSET_METADATA_VALUE
create or replace synonym network for DAI.network
create or replace synonym operator for DAI.operator
create or replace synonym PROGRAMMER for DAI.PROGRAMMER
create or replace synonym PROVIDER for DAI.PROVIDER
create or replace synonym PROVIDER_NETWORK for DAI.PROVIDER_NETWORK
create or replace synonym VOD_ENDPOINT for dai.VOD_ENDPOINT


set serveroutput on

begin 
 for X in (select TABLE_NAME
           from ALL_TABLES
           where OWNER = 'DAI'
             and TABLE_NAME in
               ('CAMPAIGN', 'CAMPAIGN_ITEM', 'MEDIA_ASSET', 'MEDIA_ASSET_METADATA_VALUE',
                'NETWORK', 'OPERATOR', 'PROGRAMMER', 'PROVIDER', 'PROVIDER_NETWORK',
                'VOD_ENDPOINT')
           )
  LOOP
   --DBMS_OUTPUT.PUT_LINE (X.TABLE_NAME);
   execute immediate 'select count(1) REC_CNT from dai.'||X.TABLE_NAME;
  END LOOP;
end;
/



