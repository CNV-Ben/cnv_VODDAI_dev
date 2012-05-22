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
--   dbms_output.put_line ('dai.'||x.table_name);
   execute immediate 'select count(1) REC_CNT from dai.'||X.TABLE_NAME;
  END LOOP;
end;
/



select sysdate from dual
select distinct OWNER from all_tables