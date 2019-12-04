@define_variables.sql

DROP TABLE STCW_ORDER_UNDER_MGMT;
CREATE TABLE STCW_ORDER_UNDER_MGMT(
	ORDERNUMBER VARCHAR2(50) NOT NULL,
	CONSTRAINT PK_STCW_ORDER_UNDER_MGMT PRIMARY KEY(ORDERNUMBER) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_ORDER_UNDER_MGMT ON STCW_ORDER_UNDER_MGMT(ORDERNUMBER) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;