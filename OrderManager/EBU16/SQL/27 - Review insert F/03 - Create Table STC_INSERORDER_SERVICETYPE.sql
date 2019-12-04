/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_INSERTORDER_SERVICETYPE;

create table STC_INSERTORDER_SERVICETYPE (
  SERVICETYPE varchar2(30) not null,
  DESCRIPTION varchar2(200),
  ADDITIONAL_INFO varchar2(4000)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_INSERTORDER_SERVICETYPE
  add constraint PK_STC_INSERTORDER_SERVICETYPE primary key (SERVICETYPE)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

