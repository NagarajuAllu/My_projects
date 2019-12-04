-- THIS ONE HAS TO BE EXECUTED AS CWE

set serveroutput on

DECLARE

  CURSOR migratedorders IS
    SELECT o.cwdocid
      FROM cworderinstance o, cwmdtypes t
     WHERE o.metadatatype = t.typeid
       AND t.typename = 'ds_ws.bundleOrderSTC';

  CURSOR newprocesses IS
    SELECT p.process_id
      FROM cwprocess p, cwmdtypes t
     WHERE p.process_metadatype = t.typeid
       AND t.typename in ('processSTC.mainSTCProvisiongProcess', 'processSTC.mainSTCOrchestrationProcess');

  counter  NUMBER(9);       
  err_msg  VARCHAR2(1000);

BEGIN

DBMS_OUTPUT.ENABLE(NULL);

  counter := 0;
  
  FOR c_order IN migratedorders LOOP
    BEGIN

      BEGIN
        counter := counter + 1;
        
        DELETE FROM stc_name_value WHERE cworderid = c_order.cwdocid;
        DELETE FROM cworderinstance WHERE cwdocid = c_order.cwdocid;
  
        DELETE FROM cwpactivity WHERE process_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
    
        DELETE FROM cwpDynamicParticipant WHERE process_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
    
        DELETE FROM cwpparticipant WHERE consumer_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
    
        DELETE FROM cwpparticipant WHERE sender_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
    
        DELETE FROM cwpworklist WHERE sender_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
  
        DELETE FROM cwpactivityarc WHERE process_id IN (
          SELECT process_id FROM cwprocess WHERE order_id = c_order.cwdocid);
  
        DELETE FROM cwprocess WHERE order_id = c_order.cwdocid;
        
        INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, 'Deleted order '||c_order.cwdocid);
DBMS_OUTPUT.PUT_LINE('Deleted order '||c_order.cwdocid);
  
      EXCEPTION
        WHEN others THEN
          err_msg := substr(sqlerrm, 1, 1000);
          INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  >>>> Unexpected error while deleting order '||c_order.cwdocid||':'||err_msg);
DBMS_OUTPUT.PUT_LINE('  >>>> Unexpected error while deleting order '||c_order.cwdocid||':'||err_msg);
      END;  
    
      IF(MOD(counter, 100) = 0) THEN
        COMMIT;
      END IF;
      
    END;
  END LOOP;
  
  COMMIT;


  FOR c_process IN newprocesses LOOP
    BEGIN

      BEGIN
        counter := counter + 1;
        
        DELETE FROM cwpactivity WHERE process_id = c_process.process_id;
    
        DELETE FROM cwpDynamicParticipant WHERE process_id = c_process.process_id;
    
        DELETE FROM cwpparticipant WHERE consumer_id = c_process.process_id;
    
        DELETE FROM cwpparticipant WHERE sender_id = c_process.process_id;
    
        DELETE FROM cwpworklist WHERE sender_id = c_process.process_id;
  
        DELETE FROM cwpactivityarc WHERE process_id = c_process.process_id;
  
        DELETE FROM cwprocess WHERE process_id = c_process.process_id;
        
        INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, 'Deleted orphan process '||c_process.process_id);
DBMS_OUTPUT.PUT_LINE('Deleted orphan process '||c_process.process_id);
  
      EXCEPTION
        WHEN others THEN
          err_msg := substr(sqlerrm, 1, 1000);
          INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  >>>> Unexpected error while deleting orphan process '||c_process.process_id||':'||err_msg);
DBMS_OUTPUT.PUT_LINE('  >>>> Unexpected error while deleting orphan process '||c_process.process_id||':'||err_msg);
      END;  
    
      IF(MOD(counter, 100) = 0) THEN
        COMMIT;
      END IF;
      
    END;
  END LOOP;

  COMMIT;
  
END;
/