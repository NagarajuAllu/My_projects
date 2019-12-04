/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STCW_INTERNAL_NAME_MAPPING;
create table STCW_INTERNAL_NAME_MAPPING (
  OBJECTNAME varchar2(10) not null,
  EXTERNALNAME varchar2(50) not null,
  INTERNALNAME varchar2(50)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STCW_INTERNAL_NAME_MAPPING
  add constraint PK_STCW_INTERNAL_NAME_MAPPING primary key (OBJECTNAME, EXTERNALNAME)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

  
insert into STCW_INTERNAL_NAME_MAPPING(OBJECTNAME, EXTERNALNAME, INTERNALNAME) values ('WORKORDER', 'actualCompl', 'ACTUAL_COMPL');
commit;
