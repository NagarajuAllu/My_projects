define DEFAULT_TABLESPACE_TABLE = CWH;
define DEFAULT_TABLESPACE_INDEX = CWH_NDX;


CREATE TABLE stc_nvpair_skip_wosu(
	nvpair_name	VARCHAR2(100),
	nvpair_value VARCHAR2(4000),
	CONSTRAINT pk_stc_nvpair_skip_wosu PRIMARY KEY(nvpair_name, nvpair_value) USING INDEX
	(CREATE UNIQUE INDEX pk_stc_nvpair_skip_wosu ON stc_nvpair_skip_wosu (nvpair_name, nvpair_value) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;
