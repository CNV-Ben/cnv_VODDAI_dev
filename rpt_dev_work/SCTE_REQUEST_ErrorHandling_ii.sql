C:\Users\benaycrigg\workspaces\dai_etl\test\data\placement-requests.g.2012-04-26.xml


File tab:
${ETL_DEV}/output/SCTE_REQUESTS_error_log
extension = txt

Content tab:
Append    = checked
Separator = |
Add ending line of file = "--------------EoF--------------"

Fields tab:
MESSAGE_ID
SESSION_ID
CONTENT_PROVIDER_ID
ENTERTAINMENT_ASSET_ID
ENTERTAINMENT_PROVIDER_ID
CREATED_BY
CREATED_DT
"error_descrip", which I configured in the preceding Table Ouptut step

