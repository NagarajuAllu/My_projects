create or replace view full_cwmessagelog_view as 
  select msgid, operation, creation_time, send_time, receive_time, user_data1, user_data2,
         utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1))||
         utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 2001)) snt_msg,
         utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
         utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg
    from cwmessagelog 
  union
  select msgid, operation, creation_time, send_time, receive_time, user_data1, user_data2,
         utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1))||
         utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 2001)) snt_msg,
         utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
         utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg
    from cwmessagelog_archive;
