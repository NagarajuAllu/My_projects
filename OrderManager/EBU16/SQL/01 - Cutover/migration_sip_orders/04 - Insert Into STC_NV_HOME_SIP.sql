truncate table STC_NV_HOME_SIP;

insert into STC_NV_HOME_SIP
  select nv.CWDOCID,
         nv.NAME,
         nv.VALUE,
         nv.CWORDERID,
         sp.CWDOCID
    from cwh.STC_NAME_VALUE nv, cwh.STC_SERVICE_PARAMETERS_HOME sp, cwh.STC_ORDER_MESSAGE_HOME o
   where o.CCTTYPE = 'SIP'
     and o.PARENTORDERNUMBER is not null
     and o.CWORDERID not in (select CWORDERID from SIP_ORDERS_EXCLUDED_FROM_MIGR)
     and o.ORDERNUMBER not like '%OLD'
     and o.CWORDERID = nv.CWORDERID
     and o.CWORDERID = sp.CWORDERID;


insert into STC_NV_HOME_SIP
  select nv.CWDOCID,
         nv.NAME,
         nv.VALUE,
         nv.CWORDERID,
         sp.CWDOCID
    from cwh.STC_NAME_VALUE_ARCHIVE nv, cwh.STC_SERV_PARAMS_HOME_ARCHIVE sp, cwh.STC_ORDER_MESSAGE_HOME_ARCHIVE o
   where o.CCTTYPE = 'SIP'
     and o.PARENTORDERNUMBER is not null
     and o.ORDERNUMBER not like '%OLD'
     and o.CWORDERID = nv.CWORDERID
     and o.CWORDERID = sp.CWORDERID;

commit;
