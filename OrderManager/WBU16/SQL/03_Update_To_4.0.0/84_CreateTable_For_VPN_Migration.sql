@define_variables.sql

drop table STCW_VPN_MIGRATION;
create table STCW_VPN_MIGRATION (
  origServiceNumber VARCHAR2(255) not null,
  origWONumber VARCHAR2(20) not null,
  newServiceType VARCHAR2(25) not null,
  newServiceNumber VARCHAR2(255) not null,
  circuitStatus VARCHAR2(25),
  vpnName VARCHAR2(100),
  parentLineItemServiceNumber VARCHAR2(255),
  siteACLLI VARCHAR2(50),
  siteACity VARCHAR2(60),
  siteAPlateId VARCHAR2(50),
  siteZCLLI VARCHAR2(50),
  siteZCity VARCHAR2(60),
  siteZPlateId VARCHAR2(50),
  processResult number(1) default 0)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

alter table STCW_VPN_MIGRATION
  add constraint PK_STCW_VPN_MIGRATION primary key (ORIGSERVICENUMBER)
  using index 
  (CREATE UNIQUE INDEX PK_STCW_VPN_MIGRATION ON STCW_VPN_MIGRATION(ORIGSERVICENUMBER) TABLESPACE &DEFAULT_TABLESPACE_INDEX);
