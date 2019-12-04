@define_variables.sql

CREATE TABLE stcw_nvpair_for_bck (
  cwdocid VARCHAR2(16) NOT NULL,
  servicetype VARCHAR2(25) NOT NULL,
  nvpair_for_bck VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_stcw_nvpair_for_bck PRIMARY KEY(cwdocid) USING INDEX
	(CREATE UNIQUE INDEX pk_stcw_nvpair_for_bck ON stcw_nvpair_for_bck(cwdocid) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;  

ALTER TABLE stcw_nvpair_for_bck
  ADD CONSTRAINT uk_stcw_nvpair_for_bck UNIQUE (servicetype);