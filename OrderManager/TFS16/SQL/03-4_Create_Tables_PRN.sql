prompt Creating PRN tables...

@define_variables.sql

CREATE TABLE STC_PRN(
 	PRN_ID VARCHAR2(16) NOT NULL,
 	PRN_NAME VARCHAR2(16) NOT NULL,
 	PRN_STATUS VARCHAR2(100) NOT NULL,
 	PRNR_ID VARCHAR2(16),
 	CUSTOMER_NAME VARCHAR2(100),
 	CUSTOMER_PROJECT VARCHAR2(100),
 	CUSTOMER_PROJECT_PHASE VARCHAR2(100),
 	REQUIREMENT_TYPE VARCHAR2(100),
 	QUANTITY NUMBER(2),
 	SITE_A_NAME VARCHAR2(100),
 	SITE_A_IF VARCHAR2(100),
 	SITE_A_JVC VARCHAR2(100),
 	SITE_Z_NAME VARCHAR2(100),
 	SITE_Z_IF VARCHAR2(100),
 	SITE_Z_JVC VARCHAR2(100),
 	PROTECTION_TYPE VARCHAR2(100),
 	TRAFFIC_TYPE VARCHAR2(100),
 	REQUEST_TYPE VARCHAR2(100),
 	CREATION_DATE DATE,
 	RECEIVED_DATE DATE,
 	PLAN_TYPE VARCHAR2(100),
 	ISSUE VARCHAR2(100),
 	PRN_YEAR VARCHAR2(4),
 	PRN_MONTH VARCHAR2(2),
 	BENEFICIARY_NAME VARCHAR2(30),
 	BENEFICIARY_CONTACTS VARCHAR2(150),
 	SITE_A_MPLS_DEVICE VARCHAR2(30),
 	SITE_Z_MPLS_DEVICE VARCHAR2(30),
 	PE_AGG_SLOT VARCHAR2(30),
 	PE_AGG_PORT VARCHAR2(30),
 	PE_AGG_ODF VARCHAR2(100),
 	PE_AGG_BAYLOC VARCHAR2(400),
 	PRN_PORT_SHARING VARCHAR2(16),
 	GSM_CELL_VENDOR VARCHAR2(100),
 	PLANNER VARCHAR2(30),
 	ANALYZED_BY VARCHAR2(30),
 	VLAN_ID_2G VARCHAR2(5),
 	VLAN_ID_3G VARCHAR2(5),
 	ANALYSIS_DATE DATE,
 	ANALYSIS_NOTES VARCHAR2(4000),
 	PLANNED_RFS_DATE DATE,
 	CREATED_BY VARCHAR2(64),
 	RELEASED_DATE DATE,
 	PRN_AVAILABLE NUMBER(1),
 	PROJECT VARCHAR2(100),
 	GSM_CELL_ID VARCHAR2(100),
 	TRAFFIC_DIVERSITY VARCHAR2(100),
 	TN VARCHAR2(100),
 	TN_PORT VARCHAR2(50),
 	CURRENT_USERID VARCHAR2(64),
 	BU_INITIATOR VARCHAR2(128),
 	CIRCUIT_MAPPING VARCHAR2(4000),
 	TFR_ID VARCHAR2(16),
 	CWDOCSTAMP VARCHAR2(9),
 	CWORDERCREATIONDATE DATE,
 	CWORDERID VARCHAR2(16),
 	CWPARENTID VARCHAR2(16),
 	LASTUPDATEDDATE DATE,
 	PARENTPROCID VARCHAR2(16),
 	UPDATEDBY VARCHAR2(64),
 	CANCELLED_DATE DATE,
 	CURRENT_USER_DEPARTMENT VARCHAR2(100)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE STC_PRN
ADD CONSTRAINT PK_STC_PRN PRIMARY KEY(PRN_ID)
USING INDEX
TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE STC_PRN
ADD CONSTRAINT UK_STC_PRN_NAME UNIQUE(PRN_NAME)
USING INDEX
TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE STC_PRN
ADD CONSTRAINT FK_STC_PRN_PRNR_ID FOREIGN KEY(PRNR_ID)
REFERENCES STC_PRNR (PRNR_ID);



CREATE TABLE STC_PRN_CUSTOMATTR (
	PRN_ID VARCHAR2(16) NOT NULL,
	CUSTOMATTR_ID VARCHAR2(16) NOT NULL,
	ATTRIBUTE_VALUE VARCHAR2(1000)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE STC_PRN_CUSTOMATTR
ADD CONSTRAINT PK_STC_PRN_CUSTOMATTR PRIMARY KEY(PRN_ID, CUSTOMATTR_ID)
USING INDEX
TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE STC_PRN_CUSTOMATTR
ADD CONSTRAINT FK_STC_PRN_CUSTOMATTR_PRN FOREIGN KEY(PRN_ID)
REFERENCES STC_PRN (PRN_ID);

ALTER TABLE STC_PRN_CUSTOMATTR
ADD CONSTRAINT FK_STC_PRN_CUSTOMATTR_CATTR FOREIGN KEY(CUSTOMATTR_ID)
REFERENCES STC_CUSTOMATTR (CUSTOMATTR_ID);