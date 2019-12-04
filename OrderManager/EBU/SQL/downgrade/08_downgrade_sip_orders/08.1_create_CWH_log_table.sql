-- THIS ONE HAS TO BE EXECUTED AS CWH

create sequence DOWNGRADE_LOG_SEQ 
minvalue 1
maxvalue 999999999
start with 1
increment by 1
nocache;

create table DOWNGRADE_LOG (
  log_id NUMBER(9),
  log_date DATE,
  log_message VARCHAR2(4000)
);  