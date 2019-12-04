/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_ORDER_FOR_CRMB2B;
create table STC_ORDER_FOR_CRMB2B (
  ORDERNUMBER varchar2(50) not null
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_ORDER_FOR_CRMB2B
  add constraint PK_STC_ORDER_FOR_CRMB2B primary key (ORDERNUMBER)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

