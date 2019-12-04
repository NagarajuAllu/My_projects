/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_ERROR_FOR_LOCK;

create table STC_ERROR_FOR_LOCK (
  CWDOCID varchar2(16) not null,
  ERROR_DESCR varchar2(500) not null
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_ERROR_FOR_LOCK
  add constraint PK_STC_ERROR_FOR_LOCK primary key (CWDOCID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

