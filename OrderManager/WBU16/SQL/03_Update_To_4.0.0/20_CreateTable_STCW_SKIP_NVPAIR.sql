@define_variables.sql

DROP TABLE STCW_SKIP_NVPAIR;
CREATE TABLE STCW_SKIP_NVPAIR(
	NAME VARCHAR2(100) NOT NULL,
	CONSTRAINT PK_STCW_SKIP_NVPAIR PRIMARY KEY(NAME) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_SKIP_NVPAIR ON STCW_SKIP_NVPAIR(NAME) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;