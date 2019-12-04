/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_ICMSSONUMB_IN_PROCESS;

create table STC_ICMSSONUMB_IN_PROCESS (
  ICMSSALESORDERNUMBER varchar2(19) not null,
  ORDERNUMBER varchar2(50) not null
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_ICMSSONUMB_IN_PROCESS
  add constraint PK_STC_ICMSSONUMB_IN_PROCESS primary key (ICMSSALESORDERNUMBER, ORDERNUMBER)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

