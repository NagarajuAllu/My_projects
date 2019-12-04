truncate table STC_HOME_SIP_FROMCRM;

insert into STC_HOME_SIP_FROMCRM (cwDocId, PARENT_ORDER_NUMBER, OPERATION, REC_ORDER_STATUS, CREATION_TIME) 
select rownum, 
       nvl(orderNumber_userData1, recOrderNumber) orderNumber,
       operation,
       recOrderStatus,
       creation_time
  from (
select user_data1 orderNumber_userData1,
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderNumber>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '</OrderNumber>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderNumber>'))) recOrderNumber,
       operation, 
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderStatus>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '</OrderStatus>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderStatus>'))) recOrderStatus,
       creation_time
  from cwh.cwmessagelog m
 where operation in ('ifExpediter_ws:ifExpedtier_HOME/operation_SubmitOrder', 'ifExpediter_ws:ifExpedtier_HOME/operation_UpdateOrder')
   and user_data1 in (select parentordernumber from STC_OM_HOME_SIP)
   and upper(nvl(substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
                        instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<Status>') + 8, 
                        instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</Status>') - ( 8 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<Status>'))), 
                 'ERROR')) = 'SUCCESS'
union
select user_data1 orderNumber_userData1,
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderNumber>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '</OrderNumber>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderNumber>'))) recOrderNumber,
       operation, 
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderStatus>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '</OrderStatus>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1)), '<OrderStatus>'))) recOrderStatus,
       creation_time
  from cwh.cwmessagelog_archive
 where operation in ('ifExpediter_ws:ifExpedtier_HOME/operation_SubmitOrderHome', 'ifExpediter_ws:ifExpedtier_HOME/operation_UpdateOrder')
   and user_data1 in (select parentordernumber from STC_OM_HOME_SIP)
   and upper(nvl(substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
                        instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<Status>') + 8, 
                        instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</Status>') - ( 8 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<Status>'))), 
                 'ERROR')) = 'SUCCESS'
)
;

commit;
