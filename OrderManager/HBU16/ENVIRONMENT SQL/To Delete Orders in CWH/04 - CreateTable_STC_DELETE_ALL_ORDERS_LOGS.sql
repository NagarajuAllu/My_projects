create table stc_delete_all_orders_log (
  when date, 
  ordernumber varchar2(50), 
  result_del varchar2(2), 
  error_msg varchar2(1000))
tablespace cwh;