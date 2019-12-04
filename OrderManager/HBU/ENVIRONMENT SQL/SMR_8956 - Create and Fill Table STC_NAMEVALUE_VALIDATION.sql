define DEFAULT_TABLESPACE_TABLE = CWH;
define DEFAULT_TABLESPACE_INDEX = CWH_NDX;

create table STC_NAMEVALUE_VALIDATION (
  CWDOCID VARCHAR2(16) NOT NULL,
  NAME VARCHAR2(100) NOT NULL,
  VALUE VARCHAR2(4000) NOT NULL)
tablespace &DEFAULT_TABLESPACE_TABLE;


alter table STC_NAMEVALUE_VALIDATION 
add constraint PK_STC_NAMEVALUE_VALID primary key (CWDOCID)
using index 
tablespace &DEFAULT_TABLESPACE_INDEX;

alter table STC_NAMEVALUE_VALIDATION 
add constraint UK_STC_NV_VALID_VALUE unique (NAME, VALUE)
using index
tablespace &DEFAULT_TABLESPACE_INDEX;

insert into STC_NAMEVALUE_VALIDATION VALUES ('1', 'ONTRequired', 'Yes');
insert into STC_NAMEVALUE_VALIDATION VALUES ('2', 'ONTRequired', 'No');
commit;