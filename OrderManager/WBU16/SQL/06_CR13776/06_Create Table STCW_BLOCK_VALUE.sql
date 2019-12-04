@define_variables.sql

DROP TABLE stcw_block_value;
CREATE TABLE stcw_block_value(
	cwdocid VARCHAR2(16) NOT NULL,
	parentdocid VARCHAR2(16) NOT NULL,
	cworderid VARCHAR2(16) NOT NULL,
	blockvalue VARCHAR2(4000)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_block_value
  ADD CONSTRAINT pk_stcw_block_value PRIMARY KEY (cwdocid)
  USING INDEX 
  (CREATE UNIQUE INDEX pk_stcw_block_value ON stcw_block_value(cwdocid) TABLESPACE &DEFAULT_TABLESPACE_INDEX);
