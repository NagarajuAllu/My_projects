/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_INTERNAL_NAME_MAPPING;
create table STC_INTERNAL_NAME_MAPPING (
  OBJECTNAME varchar2(10) not null,
  EXTERNALNAME varchar2(50) not null,
  INTERNALNAME varchar2(50)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_INTERNAL_NAME_MAPPING
  add constraint PK_STC_INTERNAL_NAME_MAPPING primary key (OBJECTNAME, EXTERNALNAME)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

  
insert into STC_INTERNAL_NAME_MAPPING(OBJECTNAME, EXTERNALNAME, INTERNALNAME) values ('WORKORDER', 'actualCompl', 'ACTUAL_COMPL');
commit;
