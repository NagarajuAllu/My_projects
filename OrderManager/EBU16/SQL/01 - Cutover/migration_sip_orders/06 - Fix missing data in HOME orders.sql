set serveroutput on

declare

  cursor c_circNumber_missing is   
    select distinct o.ordernumber, nvl(c.circ_path_hum_id, dc.circ_path_hum_id) circuit_number
      from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
     where o.circuitnumber is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = c.circ_path_inst_id (+)
       and w.element_inst_id = dc.circ_path_inst_id (+)
    union
    select distinct o.ordernumber, nvl(c.circ_path_hum_id, dc.circ_path_hum_id) circuit_number
      from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
     where o.circuitnumber is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = c.circ_path_inst_id (+)
       and w.element_inst_id = dc.circ_path_inst_id (+)
    ;

  cursor c_orderstatus_missing is   
    select distinct o.ordernumber, vts.status_name order_status
      from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.val_task_status@rms_prod_db_link vts
     where o.orderstatus is null
       and vts.stat_code = w.status
       and o.ordernumber = w.wo_name
    union
    select distinct o.ordernumber, vts.status_name order_status
      from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.val_task_status@rms_prod_db_link vts
     where o.orderstatus is null
       and vts.stat_code = w.status
       and o.ordernumber = w.wo_name;

  cursor c_circuitstatus_missing is   
    select distinct o.ordernumber, nvl(c.status, dc.status) circuit_status
      from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
     where o.circuitstatus is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = c.circ_path_inst_id (+)
       and w.element_inst_id = dc.circ_path_inst_id (+)
    union
    select distinct o.ordernumber, nvl(c.status, dc.status) circuit_status
      from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.circ_path_inst@rms_prod_db_link c, rms_prod.del_circ_path_inst@rms_prod_db_link dc
     where o.circuitstatus is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = c.circ_path_inst_id (+)
       and w.element_inst_id = dc.circ_path_inst_id (+)
    ;

  cursor c_icmssonumber_missing(uda_inst_id in varchar2) is   
    select distinct o.ordernumber, was.attr_value 
      from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.workorder_attr_settings@rms_prod_db_link was
     where o.icmssonumber is null
       and o.ordernumber = w.wo_name
       and was.val_attr_inst_id = uda_inst_id
       and w.wo_inst_id = was.workorder_inst_id
    union
    select distinct o.ordernumber, was.attr_value 
      from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.workorder_attr_settings@rms_prod_db_link was
     where o.icmssonumber is null
       and o.ordernumber = w.wo_name
       and was.val_attr_inst_id = uda_inst_id
       and w.wo_inst_id = was.workorder_inst_id
    ;

  cursor c_fictbillnumber_missing(uda_inst_id in varchar2)  is   
    select distinct o.ordernumber, cpas.attr_value
      from stc_om_home_sip o, rms_prod.work_order_inst@rms_prod_db_link w, rms_prod.circ_path_attr_settings@rms_prod_db_link cpas
     where o.fictbillingnumber is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = cpas.circ_path_inst_id
       and cpas.val_attr_inst_id = uda_inst_id
    union
    select distinct o.ordernumber, cpas.attr_value
      from stc_om_home_sip o, rms_prod.del_work_order_inst@rms_prod_db_link w, rms_prod.circ_path_attr_settings@rms_prod_db_link cpas
     where o.fictbillingnumber is null
       and o.ordernumber = w.wo_name
       and w.element_inst_id = cpas.circ_path_inst_id
       and cpas.val_attr_inst_id = uda_inst_id
    ;

  uda_inst_id NUMBER(10);
  
begin
dbms_output.enable(null);
    
  for miss_circuitnumber in c_circNumber_missing loop
    update stc_om_home_sip set circuitnumber = miss_circuitnumber.circuit_number where ordernumber = miss_circuitnumber.ordernumber;
  end loop;  
dbms_output.put_line('CircuitNumber fixed');


  for miss_orderstatus in c_orderstatus_missing loop
    update stc_om_home_sip set orderstatus = miss_orderstatus.order_status  where ordernumber = miss_orderstatus.ordernumber;
  end loop;  
dbms_output.put_line('OrderStatus fixed');


  for miss_circuitstatus in c_circuitstatus_missing loop
    update stc_om_home_sip set circuitstatus = miss_circuitstatus.circuit_status  where ordernumber = miss_circuitstatus.ordernumber;
  end loop;  
dbms_output.put_line('CircuitStatus fixed');


  select val_attr_inst_id
    into uda_inst_id
    from rms_prod.val_attr_name@rms_prod_db_link van
   where van.attr_name = 'ICMS S/O Number'
     and van.group_name = 'Work Order Info';

  for miss_icmssonumber in c_icmssonumber_missing(uda_inst_id) loop
    update stc_om_home_sip set icmssonumber = miss_icmssonumber.attr_value  where ordernumber = miss_icmssonumber.ordernumber;
  end loop;  
dbms_output.put_line('ICMS_SO_NUMBER fixed');


  select val_attr_inst_id
    into uda_inst_id
    from rms_prod.val_attr_name@rms_prod_db_link van
   where van.attr_name = 'Fict. Billing Number'
     and van.group_name = 'Customer Details';

  for miss_fictbillingnumber in c_fictbillnumber_missing(uda_inst_id) loop
    update stc_om_home_sip set fictbillingnumber = miss_fictbillingnumber.attr_value  where ordernumber = miss_fictbillingnumber.ordernumber;
  end loop;  
dbms_output.put_line('Fict. Billing Number fixed');


end;
/
