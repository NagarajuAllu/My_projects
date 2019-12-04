/***

  This procedure is to setup the UDA Parent Order Number for all the WO related to WBU legacy orders.
  Otherwise the WOSU generated don't have the attribute crmOrderNumber.
 
  It must be executed as RMS_PROD user.
***/


create table  wbu_som_parentordernumber_uda as 
    SELECT distinct b.workordernumber
      FROM cwprocess@cww_eoc16_link p, stcw_bundleorder_header@cww_eoc16_link h, stcw_lineitem@cww_eoc16_link b
     WHERE p.order_id = h.cworderid
       AND b.cworderid = h.cworderid
       AND b.elementtypeinordertree = 'B'
       AND h.ismigrated = 1;



set serveroutput on

DECLARE

  CURSOR c_woname IS
    SELECT distinct workordernumber
      FROM wbu_som_parentordernumber_uda;
       
       
  uda_inst_id   val_attr_name.val_attr_inst_id%TYPE;
  wo_id         work_order_inst.wo_name%TYPE;
  element_id    work_order_inst.element_inst_id%TYPE;
  element_type  resource_definition_inst.name%TYPE;
  
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
      
--      DBMS_OUTPUT.PUT_LINE('[INFO] Processing wo '||w.workordernumber);
      
      SELECT w.wo_inst_id, w.element_inst_id
        INTO wo_id, element_id
        FROM work_order_inst w
       WHERE wo_name = w.workordernumber;
       
      BEGIN
        SELECT d.name
          INTO element_type
          FROM resource_inst r, resource_definition_inst d
         WHERE r.resource_inst_id = element_id
           and d.definition_inst_id = r.definition_inst_id;
      EXCEPTION
        WHEN no_data_found THEN
          -- errMsg := substr(sqlerrm, 1, 1000);
          -- DBMS_OUTPUT.PUT_LINE('[ERR] error while trying to get element_type for <'||w.workordernumber||','||element_id||'>:'||errMsg);        
          element_type := NULL;
      END;
      
      SELECT COUNT(*)
        INTO count_uda
        FROM workorder_attr_settings 
       WHERE workorder_inst_id = wo_id
         AND val_attr_inst_id = uda_inst_id;
      
      IF(count_uda = 0) THEN
        INSERT INTO workorder_attr_settings (workorder_inst_id, val_attr_inst_id, attr_value)
          VALUES (wo_id, uda_inst_id, w.workordernumber);

        DBMS_OUTPUT.PUT_LINE('[INFO] Inserted UDA for <'||w.workordernumber ||','||wo_id||'> ; ElementType = '||element_type);
      ELSE 
        DBMS_OUTPUT.PUT_LINE('[WARN] UDA already exists ['||count_uda||'] for <'||w.workordernumber||','||wo_id||'> ; ElementType = '||element_type);
      END IF;
    
    EXCEPTION
      WHEN others THEN
        errMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] error while processing WO '||w.workordernumber||':'||errMsg);        
    END;
  END LOOP;
  
END;
/