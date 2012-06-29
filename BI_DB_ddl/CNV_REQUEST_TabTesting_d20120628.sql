CREATE OR REPLACE TRIGGER CNV_REQUEST_TRG
before insert on SCTE_REQUEST
--after insert on SCTE_REQUEST
for each row

declare
	v_error_msg 	varchar2(4000);

begin
  insert into CNV_REQUEST
   (MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID, CLIENT_DT_DATE)
  values
  (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id,:new.CLIENT_DT_DATE);

EXCEPTION
when OTHERS then V_ERROR_MSG := SQLERRM;

  insert into CNV_REQUEST_ERR
   (MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID, CLIENT_DT_DATE, error_message)
  values
   (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id,:new.CLIENT_DT_DATE, v_error_msg);

end CNV_REQUEST_TRG;
=========================================================================================================================================























																										Nullable?	Scale
The RQST_TIMESTAMP field in CNV_REQUEST has data type:	RQST_TIMESTAMP	TIMESTAMP(6) WITH TIME ZONE			Y		  6






============================================================================================================================
create table ben_test as
 select TO_TIMESTAMP_TZ('2011-08-26T19:09:09-09:09','YYYY-MM-DD"T"HH24:MI:SSxFFTZH:TZM') test_dt from dual

returns:

column_name	Type							Size	Primary Key	Foreign Key	Nullable?	Scale
TEST_DT		TIMESTAMP(9) WITH TIME ZONE											Y		  9



create table ben_time_test2 as
select unique client_dt_string from SCTE_REQUEST

describe BEN_TIME_TEST2

CLIENT_DT_STRING	VARCHAR2	32			Y	 (no Scale)



WITH datestuff AS
 (SELECT xmltype('2011-05-23T12:01:51.217+02:00') xmlcol 
  FROM dual)
SELECT to_timestamp_tz(xt#66cc66;">.datum#66cc66;">,#ff0000;">'YYYY-MM-DD"T"HH24:MI:SS.FF9tzh:tzm'#66cc66;">) 
       #993333; font-weight: bold;">AS #ff0000;">"TO_TIMESTAMP_TZ"
#993333; font-weight: bold;">FROM   datestuff 
#66cc66;">,      xmltable#66cc66;">(#ff0000;">'*'
                passing xmlcol
                #993333; font-weight: bold;">COLUMNS
                  datum varchar2#66cc66;">(#cc66cc;">35#66cc66;">) PATH #ff0000;">'/date'
                #66cc66;">) xt;








