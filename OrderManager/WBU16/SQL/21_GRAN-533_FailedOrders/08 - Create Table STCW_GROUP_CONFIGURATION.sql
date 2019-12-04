/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE STCW_GROUP_CONFIGURATION;

-- Create table
CREATE TABLE stcw_group_configuration (
  cwdocid           VARCHAR2(16) not null,
  groupName         VARCHAR2(128) not null,
  taskOperation     VARCHAR2(20) not null,
  taskStatusCode    CHAR(1) not null,
  region            VARCHAR2(40),
  orderType         CHAR(1),
  reasonCode        VARCHAR2(100),
  reasonCodeNot     VARCHAR2(100),
  reasonDescr       VARCHAR2(2000),
  reasonDescrNot    VARCHAR2(2000))
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_group_configuration
  ADD CONSTRAINT pk_stcw_group_configuration PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

