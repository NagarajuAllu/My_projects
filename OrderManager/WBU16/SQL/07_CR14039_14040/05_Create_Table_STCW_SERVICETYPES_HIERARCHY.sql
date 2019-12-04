@define_variables.sql

DROP TABLE STCW_SERVICETYPES_HIERARCHY;
CREATE TABLE STCW_SERVICETYPES_HIERARCHY(
	CWDOCID VARCHAR2(16) NOT NULL,
	PARENT_SERVICETYPE VARCHAR2(25) NOT NULL,
	CHILD_SERVICETYPE VARCHAR2(25) NOT NULL,
	CONSTRAINT PK_STCW_SERVICETYPES_HIERARCHY PRIMARY KEY(CWDOCID) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_SERVICETYPES_HIERARCHY ON STCW_SERVICETYPES_HIERARCHY(CWDOCID) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;
