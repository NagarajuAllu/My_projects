alter table STC_BUNDLEORDER_HEADER add internalOrder VARCHAR2(1) DEFAULT 'N';
update STC_BUNDLEORDER_HEADER set internalOrder = 'N' where internalOrder is null;

insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_InsertOrder', '[STC] Insert Order');
insert into CWROLE (ROLEID, ROLE_NAME, CALENDAR) select 'InsertOrderGroup', 'Group to insert new orders', CALENDAR from CWCALENDARS;
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_InsertOrder', 'InsertOrderGroup');
commit;


define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;


create table STC_FINDERNVPAIR_4_GUI_CONFIG(
	FINDERLABEL varchar2(100) not null,
	QUERYSQL varchar2(4000) not null,
	DBLOGICALCONNECTION varchar2(100) not null,
	constraint PK_STC_FINDERNVPAIR_4_GUI_CFG primary key(FINDERLABEL) using index
	(create unique index PK_STC_FINDERNVPAIR_4_GUI_CFG on STC_FINDERNVPAIR_4_GUI_CONFIG(FINDERLABEL) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

alter table STC_FINDERNVPAIR_4_GUI_CONFIG
  add constraint DBLOGICALCONNECTION_CK
  check (DBLOGICALCONNECTION IN ('ORDER','REPORT_XNG','XNG PRODUCTION [USER:STC_TARGET2]','CIME'));
  

create table STC_NVPAIR_4_GUI_CONFIG(
	NAME varchar2(100) not null,
	MANDATORY number(1) not null,
	MANDATORY_ON varchar2(100),
	MANDATORY_ON_VALUE varchar2(4000),
	VALUE_TYPE varchar2(6) not null,
	VALUES_FOR_LOV varchar2(4000),
	FINDER_NAME varchar2(100),
	constraint PK_STC_NVPAIR_4_GUI_CONFIG primary key(NAME) using index
	(create unique index PK_STC_NVPAIR_4_GUI_CONFIG on STC_NVPAIR_4_GUI_CONFIG(NAME) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

alter table STC_NVPAIR_4_GUI_CONFIG
  add constraint FK_NVPAIR_4_GUI_CONFIG foreign key (FINDER_NAME)
  references STC_FINDERNVPAIR_4_GUI_CONFIG (FINDERLABEL) on delete cascade;


create table STC_INSERTORDER_HEADER(
	CWDOCID varchar2(16) not null,
	CUSTOMER_ID varchar2(50) not null,
	CIRCUITTYPE varchar2(30) not null,
	SERVICEDATE date not null,
	CIRCUITBW varchar2(30) not null,
	SITEA_INST_ID varchar2(20) not null,
	SITEZ_INST_ID varchar2(20) not null,
	PROJECT_ID varchar2(50) not null,
	REASONCODE varchar2(10),
	GENERATEDORDERNUMBER varchar2(50),
	constraint PK_STC_INSERTORDER_HEADER primary key(CWDOCID) using index
	(create unique index PK_STC_INSERTORDER_HEADER on STC_INSERTORDER_HEADER(CWDOCID) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;


create table STC_INSERTORDER_NVPAIR(
	CWDOCID varchar2(16) not null,
	NAME varchar2(100) not null,
	VALUE varchar2(4000) not null,
	HEADER_ID varchar2(16) not null,
	constraint PK_STC_INSERTORDER_NVPAIR primary key(CWDOCID) using index
	(create unique index PK_STC_INSERTORDER_NVPAIR on STC_INSERTORDER_NVPAIR(CWDOCID) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

alter table STC_INSERTORDER_NVPAIR
  add constraint FK_HEADER_ID foreign key (HEADER_ID)
  references STC_INSERTORDER_HEADER (CWDOCID) on delete cascade;


create table STC_INSERTORDER_IFTYPE_CFG(
	INTERFACETYPE varchar2(25) not null,
	constraint PK_STC_INSERTORDER_IFTYPE_CFG primary key(INTERFACETYPE) using index
	(create unique index PK_STC_INSERTORDER_IFTYPE_CFG on STC_INSERTORDER_IFTYPE_CFG(INTERFACETYPE) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;


create table STC_INSERTORDER_REASONCODE_CFG(
	CWDOCID varchar2(16) not null,
	REASONCODE varchar2(256) not null,
	constraint PK_STC_INSERTORDER_RCODE_CFG primary key(CWDOCID) using index
	(create unique index PK_STC_INSERTORDER_RCODE_CFG on STC_INSERTORDER_REASONCODE_CFG(CWDOCID) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;


create sequence SEQ_ORDERNUMBER4GUI_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;


create sequence STC_ICMSSONUMBER4GUI_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

