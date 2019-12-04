@define_variables.sql

DROP TABLE stcw_block_name_value;
CREATE TABLE stcw_block_name_value(
	name VARCHAR2(100),
	cwdocstamp VARCHAR2(9),
	cwdocid VARCHAR2(16) NOT NULL,
	lastupdateddate DATE,
	cwordercreationdate DATE,
	cworderid VARCHAR2(16),
	cwparentid VARCHAR2(16),
	updatedby VARCHAR2(64),
	parentelementid VARCHAR2(16)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_block_name_value
  ADD CONSTRAINT pk_stcw_block_name_value PRIMARY KEY (cwdocid)
  USING INDEX 
  (CREATE UNIQUE INDEX pk_stcw_block_name_value ON stcw_block_name_value(cwdocid) TABLESPACE &DEFAULT_TABLESPACE_INDEX);

CREATE INDEX stcw_block_namevalue_parentid ON stcw_block_name_value (parentelementid)
TABLESPACE &DEFAULT_TABLESPACE_INDEX;

CREATE INDEX stcw_block_namevalue_cworderid on stcw_block_name_value (cworderid)
TABLESPACE &DEFAULT_TABLESPACE_INDEX;