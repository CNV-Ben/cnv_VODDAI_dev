C:\Users\benaycrigg\workspaces\dai_etl\test\data\scte_XMLs\placement-requests.g.2012-03-16.xml

C:\Users\benaycrigg\workspaces\dai_etl\test\data\scte_XMLs\placement-responses.g.2012-03-16.xml

C:\Users\benaycrigg\workspaces\dai_etl\test\data\scte_XMLs\placement-status-notifications.g.2012-04-26.xml


C:\Users\benaycrigg\workspaces\dai_etl\test\data\BEN_plcmt_rqst_test1.xml


















tar -cvfj *.ads0[1,2]01.log* request-response-ADS.tar.bz2

tar cvfj request-response-ADS.tar.bz2 *.ads0[1,2]01.log*

cat /dev/null > scte_psn_errros_120515.log


for x in ls -1 scte*120515.log
 do
  cat /dev/null > $x
 done




 ===================================================
 dai_user.campaign
 dai_user.campaign_item
 dai_user.media_asset
 dai_user.MEDIA_ASSET_METADATA_VALUE
 dai_user.NETWORK
 dai_user.OPERATOR
 dai_user.PROGRAMMER
 dai_user.PROVIDER
 dai_user.PROVIDER_NETWORK
 dai_user.VOD_ENDPOINT
 
 
 'CAMPAIGN', 'CAMPAIGN_ITEM', 'MEDIA_ASSET', 'MEDIA_ASSET_METADATA_VALUE',
 'NETWORK', 'OPERATOR', 'PROGRAMMER', 'PROVIDER', 'PROVIDER_NETWORK',
 'VOD_ENDPOINT'