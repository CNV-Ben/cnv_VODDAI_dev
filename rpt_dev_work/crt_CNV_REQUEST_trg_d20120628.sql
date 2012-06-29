CREATE OR REPLACE TRIGGER CNV_REQUEST_TRG
AFTER insert on SCTE_REQUEST
 for each row

declare
    duplicate_info EXCEPTION;
    PRAGMA EXCEPTION_INIT (duplicate_info, -00001);
	v_error_msg		varchar2(4000);

begin
insert into CNV_REQUEST
(MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID)
values
 (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id);


EXCEPTION
  when duplicate_info
  then  NULL;
--  dbms_output.PUT_LINE(SQLERRM);
  v_error_msg := SQLERRM;
    

insert into CNV_REQUEST_ERR
(MESSAGE_ID, ADM_DATA, ENTERTAINMENT_PROVIDER_ID, ENTERTAINMENT_ASSET_ID, error_message)
values
 (:new.message_id, :new.adm_data, :new.entertainment_provider_id, :new.entertainment_asset_id, v_error_msg);
 
end CNV_REQUEST_TRG;

--select * from user_triggers