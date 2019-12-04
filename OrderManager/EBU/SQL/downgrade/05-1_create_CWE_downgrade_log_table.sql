-- THIS ONE HAS TO BE EXECUTED AS CWE

create sequence STC_DOWNGRADE_LOG_SEQ 
minvalue 1
maxvalue 999999999
start with 1
increment by 1
nocache;

create table STC_DOWNGRADE_LOG (
  log_id NUMBER(9) NOT NULL,
  log_date DATE DEFAULT SYSDATE NOT NULL,
  log_message VARCHAR2(4000)
);  