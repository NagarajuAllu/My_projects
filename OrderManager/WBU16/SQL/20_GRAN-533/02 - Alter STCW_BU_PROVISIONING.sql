alter table STCW_BU_PROVISIONING
  drop constraint CIM_BU_PROV_CHK;
alter table STCW_BU_PROVISIONING
  add constraint CIM_BU_PROV_CHK
  check (CIM IN ('E', 'W', 'H', 'M'));
