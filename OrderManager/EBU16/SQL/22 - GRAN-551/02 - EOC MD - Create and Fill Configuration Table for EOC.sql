/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_SKIP_WOSU;
create table STC_SKIP_WOSU (
  CWDOCID              varchar2(16) not null,
  IS_FLAT              number(1) default 0,
  SERVICETYPE          varchar2(25) not null,
  NV_PAIR_NAME         varchar2(100),
  NV_PAIR_VALUE        varchar2(4000)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

-- Create/Recreate primary, unique and foreign key constraints 
alter table STC_SKIP_WOSU
  add constraint PK_STC_SKIP_WOSU primary key (CWDOCID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;

insert into STC_SKIP_WOSU(CWDOCID, IS_FLAT, SERVICETYPE, NV_PAIR_NAME, NV_PAIR_VALUE) values (1, 1, 'DSLSKY', 'GRAN-551_X', 'Y');
commit;
