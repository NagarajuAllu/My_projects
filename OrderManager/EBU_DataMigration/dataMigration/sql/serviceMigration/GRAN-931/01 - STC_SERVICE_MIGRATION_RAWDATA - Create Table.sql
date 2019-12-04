/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


drop table STC_SERVICE_MIGRATION_RAWDATA;
create table STC_SERVICE_MIGRATION_RAWDATA (
  CUSTOMER_ID varchar2(500),
  CUSTOMER_NAME varchar2(500),
  CUSTOMER_ACCOUNT_NUMBER varchar2(500),
  CIRCUIT_NAME varchar2(500),
  ECNM_MIGRATION varchar2(500),
  FICTITIOUS_BILLING_NUMBER varchar2(500),
  MVPN_MOBILE_NUMBER varchar2(1000),
  MSISDN varchar2(1000),
  ASSET_STATUS varchar2(500),
  A_SIDE_CLLI varchar2(500),
  Z_SIDE_CLLI varchar2(500),
  CIRCUIT_CATEGORY varchar2(500),
  BANDWIDTH varchar2(500),
  MVPN_SPEED varchar2(1000),
  SIM_NUMBER varchar2(1000),
  MVPN_ACCESS_TYPE varchar2(1000),
  IMSI_NUMBER varchar2(1000),
  REGISTRATION_ID varchar2(1000),
  ASSET_CREATED varchar2(1000),
  RTN_CIRCUIT_SPEED varchar2(1000),
  ANALYZED number(1) default 0
)
tablespace &DEFAULT_TABLESPACE_TABLE;
