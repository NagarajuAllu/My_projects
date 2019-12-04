/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_CUSTOMER_MIGRATION;
create table STC_CUSTOMER_MIGRATION (
  ID number(5) not null,
  CUSTOMER_REF varchar2(100) not null,
  CUSTOMER_TYPE varchar2(100),
  CUSTOMER_SUBTYPE varchar2(100),
  ID_TYPE varchar2(100),
  ID_NO varchar2(100),
  SEGMENT varchar2(100),
  ACCOUNT_NO varchar2(100),
  SERVICE_NUMBER varchar2(100),
  SERVICE_CODE varchar2(100),
  ACCESS_NUMBER varchar2(100),
  MIGRATION_RESULT number(1) default 0
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_CUSTOMER_MIGRATION
  add constraint PK_STC_CUSTOMER_MIGRATION primary key (ID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;
