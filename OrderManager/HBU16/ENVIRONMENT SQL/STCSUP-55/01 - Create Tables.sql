create sequence CLEANUP_COMPLETED_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;


define DEFAULT_TABLESPACE_TABLE = CWH;
define DEFAULT_TABLESPACE_INDEX = CWH_NDX;

create table STC_CLEANUP_COMPLETED_LOG (
  SEQUENCE number(10) not null, 
  ORDERNUMBER varchar2(50) not null, 
  MESSAGE varchar2(300),
  constraint PK_STC_CLEANUP_COMPLETED_LOG primary key(SEQUENCE) using index
	(create unique index PK_STC_CLEANUP_COMPLETED_LOG on STC_CLEANUP_COMPLETED_LOG(SEQUENCE) tablespace &DEFAULT_TABLESPACE_INDEX)
)
tablespace &DEFAULT_TABLESPACE_TABLE;
