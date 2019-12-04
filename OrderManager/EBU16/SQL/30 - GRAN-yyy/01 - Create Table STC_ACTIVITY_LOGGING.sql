/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_ACTIVITY_LOGGING;

create table STC_ACTIVITY_LOGGING (
  CWDOCID varchar2(16) not null,
  ACTIVITY varchar2(200) not null,
  WHEN date default sysdate,
  USER_ID varchar2(64) not null,
  ORDER_NUMBER varchar(50) not null
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_ACTIVITY_LOGGING
  add constraint PK_STC_ACTIVITY_LOGGING primary key (CWDOCID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

