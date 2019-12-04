DECLARE

  CURSOR c_fix_path_name IS
    SELECT p.circ_path_hum_id, l.cwdocid
      FROM stc_lineitem l, work_order_inst@rms_prod_db_link w, circ_path_inst@rms_prod_db_link p
     WHERE l.provisioningflag in ('PROVISIONING', 'ACTIVE')
       AND l.workordernumber = w.wo_name
       AND p.circ_path_inst_id = w.element_inst_id
       AND p.circ_path_hum_id <> l.lineitemidentifier;

BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceNumberCursor IN c_fix_path_name LOOP
    BEGIN
      update stc_lineitem 
         set servicenumber = serviceNumberCursor.circ_path_hum_id,
             lineitemidentifier = serviceNumberCursor.circ_path_hum_id 
       where cwdocid = serviceNumberCursor.cwdocid;

dbms_output.put_line('[INFO] Updated lineItem['||serviceNumberCursor.cwdocid||']; new pathName = '||serviceNumberCursor.circ_path_hum_id);
    END;
  
  END LOOP;
END;
/

