DECLARE

  CURSOR c_fix_circuitNumber IS
    select cworderid, circuitnumber, circuit_number 
      from (
        select o.cworderid, o.circuitnumber, nvl(c.circ_path_hum_id, dc.circ_path_hum_id) circuit_number
          from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
         where o.ordernumber = w.wo_name
           and w.element_inst_id = c.circ_path_inst_id (+)
           and w.element_inst_id = dc.circ_path_inst_id (+)    
        union      
        select o.cworderid, o.circuitnumber, nvl(c.circ_path_hum_id, dc.circ_path_hum_id) circuit_number
          from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
         where o.ordernumber = w.wo_name
           and w.element_inst_id = c.circ_path_inst_id (+)
           and w.element_inst_id = dc.circ_path_inst_id (+)    
      )
     where circuitnumber <> circuit_number;



  CURSOR c_fix_orderStatus IS
    select cworderid, orderstatus, order_status
      from (
        select o.cworderid, o.orderstatus, vts.status_name order_status
          from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.val_task_status@rms_prod_db_link vts
         where vts.stat_code = w.status
           and o.ordernumber = w.wo_name
           and o.orderstatus not in ('COMPLETED', 'CANCELLED')
        union
        select o.cworderid, o.orderstatus, vts.status_name order_status
          from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.val_task_status@rms_prod_db_link vts
         where vts.stat_code = w.status
           and o.ordernumber = w.wo_name
           and o.orderstatus not in ('COMPLETED', 'CANCELLED')
      )
     where orderstatus <> order_status;



  CURSOR c_fix_circuitStatus IS
    select cworderid, circuitstatus, circuit_status
      from (
        select o.cworderid, o.circuitstatus, nvl(c.status, dc.status) circuit_status
          from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
         where o.circuitstatus is null
           and o.ordernumber = w.wo_name
           and w.element_inst_id = c.circ_path_inst_id (+)
           and w.element_inst_id = dc.circ_path_inst_id (+)
        union
        select o.cworderid, o.circuitstatus, nvl(c.status, dc.status) circuit_status
          from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
         where o.circuitstatus is null
           and o.ordernumber = w.wo_name
           and w.element_inst_id = c.circ_path_inst_id (+)
           and w.element_inst_id = dc.circ_path_inst_id (+)      
      )
     where circuitstatus <> circuit_status;

BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
dbms_output.put_line('[INFO] Starting updating circuitNumber');
  FOR circuitNumberCursor IN c_fix_circuitNumber LOOP
    BEGIN
      update stc_om_home_sip 
         set circuitnumber = circuitNumberCursor.circuit_number
       where cworderid = circuitNumberCursor.cworderid;

dbms_output.put_line('[INFO] Updated stc_om_home_sip['||circuitNumberCursor.cworderid||']; new circuitNumber = '||circuitNumberCursor.circuit_number);
    END;
  
  END LOOP;


dbms_output.put_line('[INFO] Starting updating orderStatus');
  FOR orderStatusCursor IN c_fix_orderStatus LOOP
    BEGIN
      update stc_om_home_sip 
         set orderstatus = orderStatusCursor.order_status
       where cworderid = orderStatusCursor.cworderid;

dbms_output.put_line('[INFO] Updated stc_om_home_sip['||orderStatusCursor.cworderid||']; new orderStatus = '||orderStatusCursor.order_status);
    END;
  
  END LOOP;


dbms_output.put_line('[INFO] Starting updating circuitStatus');
  FOR circuitStatusCursor IN c_fix_circuitStatus LOOP
    BEGIN
      update stc_om_home_sip 
         set circuitstatus = circuitStatusCursor.circuit_status
       where cworderid = circuitStatusCursor.cworderid;

dbms_output.put_line('[INFO] Updated stc_om_home_sip['||circuitStatusCursor.cworderid||']; new circuitStatus = '||circuitStatusCursor.circuit_status);
    END;
  
  END LOOP;

END;
/
  