/***

define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

drop table STC_ORDER_MONITORING;
create table STC_ORDER_MONITORING (
  cworderid          VARCHAR2(16) not null,
  action_performed   CHAR(1),
  when               DATE default sysdate,
  ordernumber        VARCHAR2(50),
  orderstatus        VARCHAR2(50),
  pre_orderstatus    VARCHAR2(50),
  lineitemidentifier VARCHAR2(255),
  lineitemstatus     VARCHAR2(50),
  pre_lineitemstatus VARCHAR2(50),
  provisioningflag   VARCHAR2(12),
  pre_provisionflag  VARCHAR2(12),
  username           VARCHAR2(100),
  source_username    VARCHAR2(2000),
  source_hostname    VARCHAR2(2000))
tablespace &DEFAULT_TABLESPACE_TABLE;


DROP TRIGGER STC_BO_INSERT_TRIGGER;
CREATE OR REPLACE TRIGGER STC_BO_INSERT_TRIGGER AFTER
    INSERT ON STC_BUNDLEORDER_HEADER
    FOR EACH ROW
    BEGIN
      INSERT INTO STC_ORDER_MONITORING (cworderid, action_performed, when,
                                        ordernumber, orderstatus, pre_orderstatus, 
                                        lineitemidentifier, lineitemstatus, pre_lineitemstatus, provisioningflag, pre_provisionflag,
                                        username, source_username, source_hostname)
      VALUES (:NEW.CWORDERID, 'I',  sysdate,
              :NEW.ORDERNUMBER, :NEW.ORDERSTATUS, :OLD.ORDERSTATUS, 
              null, null, null, null, null,
              user, SYS_CONTEXT('USERENV','OS_USER'), SYS_CONTEXT('USERENV','HOST'));
    END;
/


DROP TRIGGER STC_BO_UPDATE_TRIGGER;
CREATE OR REPLACE TRIGGER STC_BO_UPDATE_TRIGGER AFTER
    UPDATE
    OF ORDERSTATUS ON STC_BUNDLEORDER_HEADER
    FOR EACH ROW
    BEGIN
      INSERT INTO STC_ORDER_MONITORING (cworderid, action_performed, when,
                                        ordernumber, orderstatus, pre_orderstatus, 
                                        lineitemidentifier, lineitemstatus, pre_lineitemstatus, provisioningflag, pre_provisionflag,
                                        username, source_username, source_hostname)
      VALUES (:OLD.CWORDERID, 'U', sysdate,
              :OLD.ORDERNUMBER, :NEW.ORDERSTATUS, :OLD.ORDERSTATUS, 
              null, null, null, null, null,
              user, SYS_CONTEXT('USERENV','OS_USER'), SYS_CONTEXT('USERENV','HOST'));
    END;
/


DROP TRIGGER STC_LI_INSERT_TRIGGER;
CREATE OR REPLACE TRIGGER STC_LI_INSERT_TRIGGER AFTER
    INSERT ON STC_LINEITEM
    FOR EACH ROW
    BEGIN
      INSERT INTO STC_ORDER_MONITORING (cworderid, action_performed, when,
                                        ordernumber, orderstatus, pre_orderstatus, 
                                        lineitemidentifier, lineitemstatus, pre_lineitemstatus, provisioningflag, pre_provisionflag,
                                        username, source_username, source_hostname)
      VALUES (:NEW.CWORDERID, 'I', sysdate,
              (select ORDERNUMBER from stc_bundleorder_header where cworderid = :OLD.CWORDERID), (select ORDERSTATUS from stc_bundleorder_header where cworderid = :OLD.CWORDERID), null, 
              :NEW.LINEITEMIDENTIFIER, :NEW.LINEITEMSTATUS, :OLD.LINEITEMSTATUS, :NEW.PROVISIONINGFLAG, :OLD.PROVISIONINGFLAG,
              user, SYS_CONTEXT('USERENV','OS_USER'), SYS_CONTEXT('USERENV','HOST'));
    END;
/


DROP TRIGGER STC_LI_UPDATE_TRIGGER;
CREATE OR REPLACE TRIGGER STC_LI_UPDATE_TRIGGER AFTER
    UPDATE
    OF LINEITEMSTATUS, PROVISIONINGFLAG ON STC_LINEITEM
    FOR EACH ROW
    BEGIN
      INSERT INTO STC_ORDER_MONITORING (cworderid, action_performed, when,
                                        ordernumber, orderstatus, pre_orderstatus, 
                                        lineitemidentifier, lineitemstatus, pre_lineitemstatus, provisioningflag, pre_provisionflag,
                                        username, source_username, source_hostname)
      VALUES (:OLD.CWORDERID, 'U', sysdate,
              (select ORDERNUMBER from stc_bundleorder_header where cworderid = :OLD.CWORDERID), (select ORDERSTATUS from stc_bundleorder_header where cworderid = :OLD.CWORDERID), null, 
              :NEW.LINEITEMIDENTIFIER, :NEW.LINEITEMSTATUS, :OLD.LINEITEMSTATUS, :NEW.PROVISIONINGFLAG, :OLD.PROVISIONINGFLAG,
              user, SYS_CONTEXT('USERENV','OS_USER'), SYS_CONTEXT('USERENV','HOST'));
    END;
/
