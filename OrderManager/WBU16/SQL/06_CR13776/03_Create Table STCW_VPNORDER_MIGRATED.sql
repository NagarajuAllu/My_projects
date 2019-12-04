@define_variables.sql

DROP TABLE stcw_vpnorder_migrated;
CREATE TABLE stcw_vpnorder_migrated (
  ordernumber            VARCHAR2(50)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_vpnorder_migrated
  ADD CONSTRAINT pk_stcw_vpnorder_migrated PRIMARY KEY (ordernumber)
  USING INDEX 
  (CREATE UNIQUE INDEX pk_stcw_vpnorder_migrated ON stcw_vpnorder_migrated(ordernumber) TABLESPACE &DEFAULT_TABLESPACE_INDEX);