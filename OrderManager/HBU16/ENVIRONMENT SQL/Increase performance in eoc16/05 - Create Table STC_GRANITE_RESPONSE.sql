-- Create table
create table STC_GRANITE_RESPONSE
(
  cwdocid        VARCHAR2(16) not null,
  inserted_date  DATE default SYSDATE not null,
  process_id     NUMBER(16) not null,
  granite_msg    LONG
)
tablespace CWH;

-- Create/Recreate indexes 
create index STC_PROCESS_IDX on STC_GRANITE_RESPONSE (process_id)
  tablespace CWH_NDX;
  
-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_GRANITE_RESPONSE
  add constraint PK_STC_RESPONSE_CWDOCID primary key (CWDOCID)
  using index 
  tablespace CWH_NDX;
