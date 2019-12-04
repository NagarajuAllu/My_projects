/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_operation_lte;
CREATE TABLE stcw_operation_lte (
  cwdocid VARCHAR2(16) NOT NULL,
  step NUMBER(1) NOT NULL,
  orderType VARCHAR2(1) NOT NULL,
  isSubmit NUMBER(1),
  changeRequestType VARCHAR2(255),
  interfaceName VARCHAR2(255) NOT NULL,
  operationName VARCHAR2(255) NOT NULL,
  outputDocName VARCHAR2(255) NOT NULL,
  retryCount NUMBER(1) DEFAULT 3)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_operation_lte
  ADD CONSTRAINT pk_stcw_operation_lte PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE stcw_operation_lte
  ADD CONSTRAINT uk_stcw_operation_lte UNIQUE (step, orderType, isSubmit, changeRequestType)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;
  
