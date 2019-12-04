/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_SERVICE_DSLSKY;
create table STC_SERVICE_DSLSKY (
  PATH_NAME varchar2(100) not null,
  CUSTOMER_NUMBER varchar2(100),
  ACCOUNT_NUMBER varchar2(100),
  ACCESS_NUMBER varchar2(100),
  SERVICE_NUMBER varchar2(100),
  SAM_CONTROL_NUMBER varchar2(100),
  CITY_CODE varchar2(10),
  DISTRICT_CODE varchar2(10),
  DESCRIPTION nvarchar2(1000),
  PLATE_ID varchar2(100),
  TYPE varchar2(100),
  SITE_A varchar2(100),
  SITE_B varchar2(100),
  FUNCTION_CODE varchar2(100),
  COMPUTED_SITE_A varchar2(100),
  COMPUTED_SITE_B varchar2(100),
  ORDER_NUMBER varchar2(50),
  MIGRATION_RESULT number(1) default 0
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_SERVICE_DSLSKY
  add constraint PK_STC_SERVICE_DSLSKY primary key (PATH_NAME)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;


create index STC_SERV_DSLSKY_CUSTNUM_IDX on STC_SERVICE_DSLSKY (CUSTOMER_NUMBER)
  tablespace &DEFAULT_TABLESPACE_INDEX;
  
create index STC_SERV_DSLSKY_ACCOUNTNO_IDX on STC_SERVICE_DSLSKY (ACCOUNT_NUMBER)
  tablespace &DEFAULT_TABLESPACE_INDEX;
  
create index STC_SERV_DSLSKY_SERVNUM_IDX on STC_SERVICE_DSLSKY (SERVICE_NUMBER)
  tablespace &DEFAULT_TABLESPACE_INDEX;

create index STC_SERV_DSLSKY_ACCNUM_IDX on STC_SERVICE_DSLSKY (ACCESS_NUMBER)
  tablespace &DEFAULT_TABLESPACE_INDEX;
  
create index STC_SERV_DSLSKY_MIGRRES_IDX on STC_SERVICE_DSLSKY (MIGRATION_RESULT)
  tablespace &DEFAULT_TABLESPACE_INDEX;