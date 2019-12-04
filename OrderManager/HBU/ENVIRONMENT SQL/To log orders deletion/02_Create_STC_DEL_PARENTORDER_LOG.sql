create table STC_DEL_PARENTORDER_STRUCT_LOG (
log_number number(10),
when_occurred date default sysdate,
parent_order_number varchar2(50),
msg varchar2(2000));


create sequence STC_DEL_PARENTORDER_STRUCT_SEQ 
minvalue 1
maxvalue 99999999999999
start with 1
increment by 1
nocache;