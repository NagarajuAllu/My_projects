@define_variables.sql

DROP TABLE stcw_blockparams_configuration;
CREATE TABLE stcw_blockparams_configuration (
  cwdocid VARCHAR2(16) NOT NULL,
  ordertype VARCHAR2(1),
  servicetype VARCHAR2(25),
  blockparametername VARCHAR2(100),
  ismandatory NUMBER(1)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_blockparams_configuration
  ADD CONSTRAINT pk_stcw_blockparams_conf PRIMARY KEY (cwdocid)
  USING INDEX
  (CREATE UNIQUE INDEX pk_stcw_blockparams_conf ON stcw_blockparams_configuration(cwdocid) TABLESPACE &DEFAULT_TABLESPACE_INDEX);

