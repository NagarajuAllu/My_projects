create sequence STC_BULK_JOBID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;


define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

alter table STC_INSERTORDER_HEADER modify CUSTOMER_ID null;
alter table STC_INSERTORDER_HEADER modify CIRCUITTYPE null;
alter table STC_INSERTORDER_HEADER modify SERVICEDATE null;
alter table STC_INSERTORDER_HEADER modify CIRCUITBW null;
alter table STC_INSERTORDER_HEADER modify SITEA_INST_ID null;
alter table STC_INSERTORDER_HEADER modify SITEZ_INST_ID null;
alter table STC_INSERTORDER_HEADER modify PROJECT_ID null;
alter table STC_INSERTORDER_HEADER add JOBID number(10);
alter table STC_INSERTORDER_HEADER add ROWNUMBER number(3);
alter table STC_INSERTORDER_HEADER add GI_RESPONSE varchar2(100);
alter table STC_INSERTORDER_HEADER add GI_FAILURE_MSG varchar2(2000);


create table STC_INSERTORDER_MAPBULK_CFG(
	POSITION number(3) not null,
	COLUMNNAME varchar2(250) not null,
	constraint PK_STC_INSERTORDER_MAPBULK_CFG primary key(POSITION) using index
	(create unique index PK_STC_INSERTORDER_MAPBULK_CFG on STC_INSERTORDER_MAPBULK_CFG(POSITION) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;


create table STC_INSERTORDER_BULKHEADER_CFG (
  HEADER varchar2(4000) not null
)
tablespace &DEFAULT_TABLESPACE_TABLE;


create table STC_INSERTORDER_ERRORBULK (
  CWDOCID          varchar2(16) not null,
  JOBID            number(10) not null,
  ROWNUMBER        number(3) not null,
  ERRORDESCRIPTION varchar2(4000),
  constraint PK_STC_INSERTORDER_ERRORBULK primary key(CWDOCID) using index
	(create unique index PK_STC_INSERTORDER_ERRORBULK on STC_INSERTORDER_ERRORBULK(CWDOCID) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

create index INSERTORDER_ERRORBULK_JOBID on STC_INSERTORDER_ERRORBULK(JOBID);


create table STC_INSERTORDER_JOBID_DONE (
  JOBID            number(10) not null,
  PROCESSID        number(16),
  constraint PK_STC_INSERTORDER_JOBID_DONE primary key(JOBID) using index
	(create unique index PK_STC_INSERTORDER_JOBID_DONE on STC_INSERTORDER_JOBID_DONE(JOBID) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;
