/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


CREATE TABLE stcw_nvpair_dependencies (
  cwdocid VARCHAR2(16) NOT NULL,
  orderType VARCHAR2(1) NOT NULL,
  serviceType VARCHAR2(25) NOT NULL,
  source_nvPair VARCHAR2(100) NOT NULL,
  source_nvPair_value VARCHAR2(4000) NOT NULL,
  depend_nvPair VARCHAR2(100) NOT NULL)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_nvpair_dependencies
  ADD CONSTRAINT pk_stcw_nvpair_dependencies PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE stcw_nvpair_dependencies
  ADD CONSTRAINT uk_stcw_nvpair_dependencies UNIQUE (orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;
  
