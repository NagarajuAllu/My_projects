/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

create table STC_DATA_VALIDATION_FAILED (
  id number(10) not null,
  WHEN date not null,
  ERROR_CODE varchar2(3) not null,
  ERROR_DESCR varchar2(2000))
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_DATA_VALIDATION_FAILED
  add constraint PK_STC_DATA_VALIDATION_FAILED primary key (ID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

create index STC_DVF_WHEN on STC_DATA_VALIDATION_FAILED (WHEN)
  tablespace &DEFAULT_TABLESPACE_INDEX;