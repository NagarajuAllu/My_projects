-- THIS SCRIPT HAS TO BE RUN IN CIM SCHEMA!!!!

-- Create table
create table CIM.MOPS_OPN_CONFIG
(
  order_type     VARCHAR2(100) not null,
  service_type   VARCHAR2(100) not null,
  operation_type VARCHAR2(1) not null,
  seq_num        VARCHAR2(1),
  wim_opn_type   VARCHAR2(1)
)
tablespace XCOM_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table MOPS_OPN_CONFIG
  add constraint MOPS_OPN_CONFIG_UK1 unique (ORDER_TYPE, SERVICE_TYPE)
  using index 
  tablespace XCOM_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Grant/Revoke object privileges 
grant select, insert, update, delete, references, alter, index on MOPS_OPN_CONFIG to RMS_PROD;
