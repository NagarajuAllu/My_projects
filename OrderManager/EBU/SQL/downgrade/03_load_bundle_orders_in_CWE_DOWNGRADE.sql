-- THIS ONE HAS TO BE EXECUTED AS CWE_DOWNGRADE


insert into STC_BUNDLEORDER_HEADER
  select * 
    from CWE_BUNDLE.STC_BUNDLEORDER_HEADER
   where nvl(isMigrated, 0) = 0;
commit;


insert into STC_LINEITEM
  select * 
    from CWE_BUNDLE.STC_LINEITEM
   where CWORDERID in (select CWORDERID from STC_BUNDLEORDER_HEADER);
commit;


insert into STC_NAME_VALUE
  select * 
    from CWE_BUNDLE.STC_NAME_VALUE
   where CWORDERID in (select CWORDERID from STC_BUNDLEORDER_HEADER);
commit;


insert into CWORDERINSTANCE
  select *
    from CWE_BUNDLE.CWORDERINSTANCE
   where CWDOCID in (select CWORDERID from STC_BUNDLEORDER_HEADER);
commit;


insert into CWORDERITEMS
  select *
    from CWE_BUNDLE.CWORDERITEMS
   where TOPORDERID in (select CWORDERID from STC_BUNDLEORDER_HEADER);
commit;


insert into STC_PRODUCTTYPE_NAME_MAP
  select * 
    from CWE_BUNDLE.STC_PRODUCTTYPE_NAME_MAP;
commit;

