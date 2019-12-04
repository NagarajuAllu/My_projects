/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


alter table STCW_SKIP_NVPAIR add SERVICETYPE varchar2(25);

update STCW_SKIP_NVPAIR set SERVICETYPE = '*';
commit;

alter table STCW_SKIP_NVPAIR modify SERVICETYPE not null;

alter table STCW_SKIP_NVPAIR
  drop constraint PK_STCW_SKIP_NVPAIR cascade;

alter table STCW_SKIP_NVPAIR
  add constraint PK_STCW_SKIP_NVPAIR primary key (NAME, SERVICETYPE)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;