truncate table STC_ORDERS_SENT_TO_GRANITE;
insert into STC_ORDERS_SENT_TO_GRANITE (cwDocId, ORDER_NUMBER, OPERATION, SENT_ORDER_STATUS, CREATION_TIME) 
select rownum, 
       nvl(orderNumber_userData1, sentOrderNumber) orderNumber,
       operation,
       sentOrderStatus,
       creation_time
  from (
select user_data1 orderNumber_userData1,
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderNumber>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</orderNumber>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderNumber>'))) sentOrderNumber,
       operation, 
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderStatus>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</orderStatus>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderStatus>'))) sentOrderStatus,
       creation_time
  from cwmessagelog
 where operation in ('ifGranite_jms:XngServicesWR/SubmitOrder', 'ifGranite_jms:XngServicesWR/UpdateOrder')
union
select user_data1 orderNumber_userData1,
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderNumber>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</orderNumber>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderNumber>'))) sentOrderNumber,
       operation, 
       substr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderStatus>') + 13, 
              instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '</orderStatus>') - ( 13 + instr(utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1)), '<orderStatus>'))) sentOrderStatus,
       creation_time
  from cwmessagelog_archive
 where operation in ('ifGranite_jms:XngServicesWR/SubmitOrder', 'ifGranite_jms:XngServicesWR/UpdateOrder')
)
;

commit;
