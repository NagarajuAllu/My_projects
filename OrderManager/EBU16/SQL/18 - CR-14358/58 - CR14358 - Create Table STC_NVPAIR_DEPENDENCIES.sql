/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;


CREATE TABLE stc_nvpair_dependencies (
  cwdocid VARCHAR2(16) NOT NULL,
  orderType VARCHAR2(25) NOT NULL,
  serviceType VARCHAR2(25) NOT NULL,
  source_nvPair VARCHAR2(100) NOT NULL,
  source_nvPair_value VARCHAR2(4000) NOT NULL,
  depend_nvPair VARCHAR2(100) NOT NULL)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stc_nvpair_dependencies
  ADD CONSTRAINT pk_stc_nvpair_dependencies PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE stc_nvpair_dependencies
  ADD CONSTRAINT uk_stc_nvpair_dependencies UNIQUE (orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;


INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('1',  'F', 'IP',   'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('2',  'F', 'DIA',  'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('3',  'F', 'MDIA', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('4',  'F', 'DIAS', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('5',  'F', 'SIP',  'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('6',  'I', 'IP',   'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('7',  'I', 'DIA',  'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('8',  'I', 'MDIA', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('9',  'I', 'DIAS', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('10', 'I', 'SIP',  'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('11', 'C', 'IP',   'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('12', 'C', 'DIA',  'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('13', 'C', 'MDIA', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('14', 'C', 'DIAS', 'MW Option', 'Yes', 'MW Option Type');
INSERT INTO stc_nvpair_dependencies(cwdocid, orderType, serviceType, source_nvPair, source_nvPair_value, depend_nvPair) VALUES ('15', 'C', 'SIP',  'MW Option', 'Yes', 'MW Option Type');

COMMIT;
