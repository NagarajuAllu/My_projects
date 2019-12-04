@define_variables.sql

DROP TABLE stcw_vpnorder_to_migrate;
CREATE TABLE stcw_vpnorder_to_migrate (
  ordernumber            VARCHAR2(50),
  ordertype              VARCHAR2(1),
  orderstatus            VARCHAR2(100),
  lineitemidentifier     VARCHAR2(255),
  producttype            VARCHAR2(255),
  servicetype            VARCHAR2(25),
  receivedservicetype    VARCHAR2(25),
  servicenumber          VARCHAR2(255),
  lineitemstatus         VARCHAR2(25),
  is_bundle              NUMBER(1),
  elementtypeinordertree VARCHAR2(1),
  provisioningflag       VARCHAR2(12),
  provisioningflag_order VARCHAR2(12),
  count_process_running  NUMBER(5),
  cworderid              VARCHAR2(16),
  lineitemdocid          VARCHAR2(16),
  result_process         NUMBER(1)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_vpnorder_to_migrate
  ADD CONSTRAINT pk_stcw_vpnorder_to_migrate PRIMARY KEY (ordernumber, lineitemidentifier)
  USING INDEX 
  (CREATE UNIQUE INDEX pk_stcw_vpnorder_to_migrate ON stcw_vpnorder_to_migrate(ordernumber, lineitemidentifier) TABLESPACE &DEFAULT_TABLESPACE_INDEX);

