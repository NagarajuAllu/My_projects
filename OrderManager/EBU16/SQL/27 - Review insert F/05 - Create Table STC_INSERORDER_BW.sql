/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_INSERTORDER_BW;

create table STC_INSERTORDER_BW (
  BW_NAME varchar2(30) not null,
  SERVICETYPE varchar2(30),
  DESCRIPTION varchar2(200)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_INSERTORDER_BW
  add constraint PK_STC_INSERTORDER_BW primary key (BW_NAME)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

