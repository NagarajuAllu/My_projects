/***

  This procedure is to setup the UDA Parent Order Number for all the WO related to EBU legacy orders.
  Otherwise the WOSU generated don't have the attribute crmOrderNumber.
 
  It must be executed as RMS_PROD user.
***/

set serveroutput on

DECLARE

  CURSOR c_woname IS
    SELECT distinct b.workordernumber
      FROM cwprocess@cwe_wdprod_db_link p, stc_bundleorder_header@cwe_wdprod_db_link h, stc_lineitem@cwe_wdprod_db_link b
     WHERE p.order_id = h.cworderid
       AND b.cworderid = h.cworderid
       AND b.elementtypeinordertree = 'B'
       AND h.ismigrated = 1;
       
       
  uda_inst_id val_attr_name.val_attr_inst_id%TYPE;
  wo_id       work_order_inst.wo_name%TYPE;
  
  count_uda   NUMBER(1);
  errMsg      VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  SELECT val_attr_inst_id
    INTO uda_inst_id
    FROM val_attr_name
   WHERE attr_name = 'Parent Order Number'
     AND group_name = 'Work Order Info';

  FOR w IN c_woname LOOP
    BEGIN
      count_uda := 0;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] Processing wo '||w.workordernumber);
      
      SELECT wo_inst_id
        INTO wo_id
        FROM work_order_inst
       WHERE wo_name = w.workordernumber;
       
      SELECT COUNT(*)
        INTO count_uda
        FROM workorder_attr_settings 
       WHERE workorder_inst_id = wo_id
         AND val_attr_inst_id = uda_inst_id;
      
      IF(count_uda = 0) THEN
        INSERT INTO workorder_attr_settings (workorder_inst_id, val_attr_inst_id, attr_value)
          VALUES (wo_id, uda_inst_id, w.workordernumber);

        DBMS_OUTPUT.PUT_LINE('[INFO] Inserted UDA for '||w.workordernumber);
      ELSE 
        DBMS_OUTPUT.PUT_LINE('[WARN] UDA already exists ['||count_uda||'] for '||w.workordernumber||','||wo_id);
      END IF;
    
    EXCEPTION
      WHEN others THEN
        errMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] error while processing WO '||w.workordernumber||':'||errMsg);        
    END;
  END LOOP;
  
END;
/