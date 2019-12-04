define REPORT_TABLESPACE_TABLE=xcom_data;
define REPORT_TABLESPACE_INDEX=xcom_indx;

create sequence STC_SIU_HBU_MSG_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
order;

drop table STC_SIU_HBU_MSG;
create table STC_SIU_HBU_MSG (
  msgId number(10) not null,
  ccliCode VARCHAR2(100),
  city VARCHAR2(100),
  cityCode VARCHAR2(3100),
  country VARCHAR2(100),
  district VARCHAR2(100),
  districtCode VARCHAR2(3100),
  exchangeCode  VARCHAR2(3100),
  region VARCHAR2(100),
  siteID VARCHAR2(100),
  siteName VARCHAR2(100),
  siteType VARCHAR2(100),
  status VARCHAR2(100),
	constraint PK_STC_SIU_HBU_MSG PRIMARY KEY(msgId) USING INDEX
	(CREATE UNIQUE INDEX PK_STC_SIU_HBU_MSG ON STC_SIU_HBU_MSG(msgId) TABLESPACE &REPORT_TABLESPACE_INDEX)
)
TABLESPACE &REPORT_TABLESPACE_TABLE;

grant insert on STC_SIU_HBU_MSG to rms_prod;
grant select on STC_SIU_HBU_MSG_SEQ to rms_prod;
