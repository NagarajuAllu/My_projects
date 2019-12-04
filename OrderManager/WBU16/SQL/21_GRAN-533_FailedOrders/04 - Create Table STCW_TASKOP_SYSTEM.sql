/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_taskop_system;

-- Create table
CREATE TABLE stcw_taskop_system (
  task_operation  VARCHAR2(20) not null, 
  system          VARCHAR2(20) not null)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_taskop_system
  ADD CONSTRAINT pk_stcw_taskop_system PRIMARY KEY (task_operation)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

