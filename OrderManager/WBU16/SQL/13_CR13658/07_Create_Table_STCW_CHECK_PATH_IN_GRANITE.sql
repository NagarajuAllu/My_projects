@define_variables.sql

CREATE TABLE stcw_check_path_in_granite  (
  processid VARCHAR2(16) NOT NULL,
  servicenumber VARCHAR2(255) NOT NULL,
  primarycircuit VARCHAR2(100) NOT NULL,
  creationdate DATE default sysdate,
  result VARCHAR2(2),
	CONSTRAINT pk_stcw_check_path_in_granite PRIMARY KEY(processid) USING INDEX
	(CREATE UNIQUE INDEX pk_stcw_check_path_in_granite ON stcw_check_path_in_granite(processid) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;  

