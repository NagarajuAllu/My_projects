/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_fo_user_action;

-- Create table
CREATE TABLE stcw_fo_user_action (
  cwdocid VARCHAR2(16) NOT NULL,
  userid  VARCHAR2(80) NOT NULL,
  when    DATE DEFAULT SYSDATE,
  action  VARCHAR2(100) NOT NULL
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_fo_user_action
  ADD CONSTRAINT pk_stcw_fo_user_action PRIMARY KEY (cwdocid)
  USING INDEX;
  
CREATE INDEX stcw_fo_user_action_userid_idx ON stcw_fo_user_action(userid)
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;
  