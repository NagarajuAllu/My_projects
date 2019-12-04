truncate table STC_OM_HOME_SIP;

insert into STC_OM_HOME_SIP
  select CWDOCID,
         ACCOUNTNUMBER,
         COMPLETION_DATE,
         CREATEDBY,
         CREATIONDATE,
         CUSTOMERCONTACT,
         CUSTOMERIDNUMBER,
         CUSTOMERIDTYPE,
         substr(CUSTOMERNAME, 1, 60) CUSTOMERNAME,
         CUSTOMERNUMBER,
         CUSTOMERTYPE,
         ICMSSONUMBER,
         PARENTORDERNUMBER,
         ORDERSTATUS,
         ORDERTYPE,
         PRIORITY,
         CWORDERCREATIONDATE,
         REFERENCETELNUMBER,
         REMARKS,
         SERVICEDATE,
         FICTBILLINGNUMBER,
         CIRCUITNUMBER,
         BANDWIDTH,
         CIRCUITSTATUS,
         COMMONPLATEID,
         OLDCIRCUITNUMBER,
         PROJECTID,
         TBPORTNUMBER,
         WIRES  ,
         ORDERNUMBER,
         CWORDERID,
         CCTTYPE,
         0,
         0
    from cwh.STC_ORDER_MESSAGE_HOME
   where CCTTYPE = 'SIP'
     and PARENTORDERNUMBER is not null
     and CWORDERID not in (select CWORDERID from SIP_ORDERS_EXCLUDED_FROM_MIGR)
     and ORDERNUMBER not like '%OLD';

  
insert into STC_OM_HOME_SIP
  select CWDOCID,
         ACCOUNTNUMBER,
         COMPLETION_DATE,
         CREATEDBY,
         CREATIONDATE,
         CUSTOMERCONTACT,
         CUSTOMERIDNUMBER,
         CUSTOMERIDTYPE,
         substr(CUSTOMERNAME, 1, 60) customername,
         CUSTOMERNUMBER,
         CUSTOMERTYPE,
         ICMSSONUMBER,
         PARENTORDERNUMBER,
         ORDERSTATUS,
         ORDERTYPE,
         PRIORITY,
         CWORDERCREATIONDATE,
         REFERENCETELNUMBER,
         REMARKS,
         SERVICEDATE,
         FICTBILLINGNUMBER,
         CIRCUITNUMBER,
         BANDWIDTH,
         CIRCUITSTATUS,
         COMMONPLATEID,
         OLDCIRCUITNUMBER,
         PROJECTID,
         TBPORTNUMBER,
         WIRES  ,
         ORDERNUMBER,
         CWORDERID,
         CCTTYPE,
         1,
         0
    from cwh.STC_ORDER_MESSAGE_HOME_ARCHIVE
   where CCTTYPE = 'SIP'
     and PARENTORDERNUMBER is not null
     and ORDERNUMBER not like '%OLD';

commit;
