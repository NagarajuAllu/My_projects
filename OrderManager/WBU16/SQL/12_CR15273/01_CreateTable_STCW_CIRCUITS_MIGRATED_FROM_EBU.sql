create table STCW_CIRCUITS_MIGRATED_FRM_EBU (
  record_num       NUMBER(4),
  circuit_name     VARCHAR2(255),
  circuit_status   VARCHAR2(100),
  wbu_account      VARCHAR2(100),
  service_id       VARCHAR2(255),
  wbu_order_number VARCHAR2(50)
)
tablespace CWW;


alter table STCW_CIRCUITS_MIGRATED_FRM_EBU
  add constraint PK_STCW_CIRCUITS_MIGRATED primary key (RECORD_NUM)
  using index 
  tablespace CWW_NDX;