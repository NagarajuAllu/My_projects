alter table STCW_LINEITEM
  drop constraint LINEITEM_PROV_BU_CHK;
alter table STCW_LINEITEM
  add constraint LINEITEM_PROV_BU_CHK
  check (PROVISIONINGBU IN ('E', 'W', 'H', 'M'));
  
alter table STCW_LINEITEM modify workordertype varchar2(5);
  
alter table STCW_LINEITEM add isPONRReviseSet number(1) default 0;
alter table STCW_LINEITEM add isPONRCancelSet number(1) default 0;
alter table STCW_LINEITEM add previousActiveDocId varchar2(16);
alter table STCW_LINEITEM add previousWONumber varchar2(20);

