-- new configuration table to store the values of the NVPair in case they belong to the set serviceType
define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

CREATE TABLE STC_NVPAIR_SERVTYPE_PICKLIST(
	SERVICETYPE VARCHAR2(25) NOT NULL,
	NVPAIR_NAME VARCHAR2(100) NOT NULL,
	VALUE VARCHAR2(4000) NOT NULL,
	CONSTRAINT PK_STC_NVPAIR_SERVTYPE_PICKLIS PRIMARY KEY(SERVICETYPE,NVPAIR_NAME,VALUE) USING INDEX
	(CREATE UNIQUE INDEX PK_STC_NVPAIR_SERVTYPE_PICKLIS ON STC_NVPAIR_SERVTYPE_PICKLIST(SERVICETYPE,NVPAIR_NAME,VALUE) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

-- add configuration to serviceType behavior to indicate if the content of NVPair 'Existing Circuit' is a circuit that has to be disconnected
ALTER TABLE STC_SERVICETYPE_BEHAVIORCONFIG ADD DISCONNECT_4_NVP_EXISTCIRCUIT NUMBER(1) DEFAULT 0;

-- add reference to Order# that requested the disconnect of this order
ALTER TABLE STC_BUNDLEORDER_HEADER ADD PRIMARYORDERNUMBER VARCHAR2(50);
ALTER TABLE STC_DEL_BUNDLEORDER_HEADER ADD PRIMARYORDERNUMBER VARCHAR2(50);

-- add boolean flag to indicate if the 
ALTER TABLE STC_LINEITEM ADD DISCONNECTORDERLINKED NUMBER(1) DEFAULT 0;
ALTER TABLE STC_DEL_LINEITEM ADD DISCONNECTORDERLINKED NUMBER(1);