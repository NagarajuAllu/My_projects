truncate table STC_SP_HOME_SIP;

insert into STC_SP_HOME_SIP
  select s.CWDOCID,
         s.CREATIONDATE,
         s.SERVICENUMBER,
         nvl(s.TOBECANCELLED, 0) TOBECANCELLED,
         s.OLDPLATEID,
         s.PLATEID,
         s.UNITNUMBER,
         s.SERVICEDATE,
         s.SERVICEDESCRIPTION,
         s.ORDERROWITEMID,
         s.OLDSERVICENUMBER,
         s.SERVICETYPE,
         s.CWORDERID
    from cwh.STC_SERVICE_PARAMETERS_HOME s, cwh.STC_ORDER_MESSAGE_HOME o
   where o.CCTTYPE = 'SIP'
     and o.PARENTORDERNUMBER is not null
     and o.CWORDERID not in (select CWORDERID from SIP_ORDERS_EXCLUDED_FROM_MIGR)
     and o.ORDERNUMBER not like '%OLD'
     and o.CWORDERID = s.CWORDERID;


insert into STC_SP_HOME_SIP
  select s.CWDOCID,
         s.CREATIONDATE,
         s.SERVICENUMBER,
         nvl(s.TOBECANCELLED, 0) TOBECANCELLED,
         s.OLDPLATEID,
         s.PLATEID,
         s.UNITNUMBER,
         s.SERVICEDATE,
         s.SERVICEDESCRIPTION,
         s.ORDERROWITEMID,
         s.OLDSERVICENUMBER,
         s.SERVICETYPE,
         s.CWORDERID
    from cwh.STC_SERV_PARAMS_HOME_ARCHIVE s, cwh.STC_ORDER_MESSAGE_HOME_ARCHIVE o
   where o.CCTTYPE = 'SIP'
     and o.PARENTORDERNUMBER is not null
     and o.ORDERNUMBER not like '%OLD'
     and o.CWORDERID = s.CWORDERID;

commit;
