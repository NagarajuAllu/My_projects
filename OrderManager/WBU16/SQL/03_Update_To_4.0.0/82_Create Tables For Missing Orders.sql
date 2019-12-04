@define_variables.sql

create table STCW_AMO_WITHOUT_WO_NOT_IN_EOC as (
select NAME
  from RESOURCE_INST@rms_prod_db_link
 where CATEGORY not in ('I/N-INTERCONNECT_LINK')
   and DEFINITION_INST_ID in(1602,1360,1380,1381)
   and RESOURCE_INST_ID not in(select distinct ELEMENT_INST_ID
                                          from WORK_ORDER_INST@rms_prod_db_link
                                         where ELEMENT_TYPE = 'F'
                                           and ELEMENT_INST_ID in (select RESOURCE_INST_ID
                                                                     from RESOURCE_INST@rms_prod_db_link
                                                                    where DEFINITION_INST_ID in(1602,1360,1380,1381)))
minus
select distinct SERVICENUMBER 
  from STCW_LINEITEM);



drop table STCW_DATA_FOR_MISSING_ORDERS;
create table STCW_DATA_FOR_MISSING_ORDERS (
  CUSTOMERIDNUMBER    varchar2(50),
  ORDERNUMBER         varchar2(50),
  ORDERTYPE           char(1),
  ORDERSTATUS         varchar2(100),
  CREATIONDATE        date,
  CREATEDBY           varchar2(50),
  SERVICEDATE         date,
  BUSINESSUNIT        varchar2(20),
  COMPLETIONDATE      date,
  LINEITEMIDENTIFIER  varchar2(255),
  LINEITEMSTATUS      varchar2(25),
  LINEITEMTYPE        varchar2(10),
  ACTION              varchar2(10),
  WORKORDERNUMBER     varchar2(20),
  SERVICETYPE         varchar2(25),
  PRODUCTCODE         varchar2(25),
  BANDWIDTH           varchar2(30),
  RESERVATIONNUMBER   varchar2(255),
  LOCATIONACITY       varchar2(60),
  LOCATIONACCLICODE   varchar2(50),
  LOCATIONAACCESSTYPE varchar2(100),
  LOCATIONBCITY       varchar2(60),
  LOCATIONBCCLICODE   varchar2(50),
  LOCATIONBACCESSTYPE varchar2(100),
  SERVICENUMBER       varchar2(255),
  PROVISIONINGBU      char(1),
  PROCESSED           number(1),
	CONSTRAINT PK_STCW_DATA_FOR_MISS_ORDERS PRIMARY KEY(ORDERNUMBER) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_DATA_FOR_MISS_ORDERS ON STCW_DATA_FOR_MISSING_ORDERS(ORDERNUMBER) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;  


create sequence STCW_MISSING_ORDNUM
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
order;

