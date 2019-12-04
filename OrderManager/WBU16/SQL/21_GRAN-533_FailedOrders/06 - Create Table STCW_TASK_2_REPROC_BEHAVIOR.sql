/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_task_2_reproc_behavior;

-- Create table
CREATE TABLE stcw_task_2_reproc_behavior (
  cwdocid                  VARCHAR2(16) not null,
  task_operation           VARCHAR2(20) not null, 
  status_code              CHAR(1) not null,
  exist_dependent          NUMBER(1),
  already_completed_taskOp VARCHAR2(20),
  support_resend           NUMBER(1),
  support_resend_winfo     NUMBER(1),
  support_complete         NUMBER(1),
  require_ont              NUMBER(1),
  additional_info_doc      VARCHAR2(256)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_task_2_reproc_behavior
  ADD CONSTRAINT pk_stcw_task_2_reproc_behavior PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

