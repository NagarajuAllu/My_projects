/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_DATA_AUDIT;

create table STC_DATA_AUDIT (
  cworderid      VARCHAR2(16) not null,
  cwdocid        VARCHAR2(16) not null,
  when           DATE default sysdate,
  object         VARCHAR2(100) not null,
  fieldname      VARCHAR2(100) not null,
  oldvalue       VARCHAR2(200),
  newvalue       VARCHAR2(200),
  username       VARCHAR2(100),
  sourceusername VARCHAR2(2000),
  sourcehostname VARCHAR2(2000)
)
tablespace &DEFAULT_TABLESPACE_TABLE;

