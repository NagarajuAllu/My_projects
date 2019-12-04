alter table STCW_COM_TO_GRANITE_DATA modify COM_ELEMENT varchar2(6);

alter table STCW_COM_TO_GRANITE_DATA
  drop constraint CIM_CHK;
alter table STCW_COM_TO_GRANITE_DATA
  add constraint CIM_CHK
  check (CIM IN ('W', 'E', 'H'));
  
alter table STCW_COM_TO_GRANITE_DATA
  drop constraint COM_ELEMENT_CHK;
alter table STCW_COM_TO_GRANITE_DATA
  add constraint COM_ELEMENT_CHK
  check (COM_ELEMENT IN ('OH', 'LI', 'NV', 'NV_PLI'));

alter table STCW_COM_TO_GRANITE_DATA
  drop constraint GI_ELEMENT_CHK;
alter table STCW_COM_TO_GRANITE_DATA
  add constraint GI_ELEMENT_CHK
  check (GI_ELEMENT IN ('OH', 'LI', 'NV'));
  
alter table STCW_COM_TO_GRANITE_DATA add COM_SERVICETYPE varchar2(25);
