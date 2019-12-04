set serveroutput on

declare

  cursor c_enterprise_bu_missing is   
    select o.ordernumber, di.domain_name
      from stc_order_message o, rms_prod.work_order_inst woi, path_domain_map@rms_prod_db_link pdm, domain_inst@rms_prod_db_link di
     where o.businessunit is null
       and o.ordernumber = woi.wo_name
       and woi.element_inst_id = pdm.circ_path_inst_id
       and pdm.domain_inst_id = di.domain_inst_id;

  cursor c_circNumber_missing is   
    select o.ordernumber, woi.element_name
      from stc_order_message o, rms_prod.work_order_inst woi
     where o.circuitnumber is null
       and o.ordernumber = woi.wo_name;

  cursor c_creationdate_missing is   
    select o.ordernumber, i.creationdate
      from stc_order_message o, cworderinstance i
     where o.creationdate is null
       and o.cworderid = i.cwdocid;

  cursor c_ordercreationdate_missing is   
    select o.ordernumber, i.creationdate
      from stc_order_message o, cworderinstance i
     where o.cwordercreationdate is null
       and o.cworderid = i.cwdocid;

  cursor c_icmssonumber_missing(uda_inst_id in varchar2) is   
    select o.ordernumber, was.attr_value
      from stc_order_message o, rms_prod.work_order_inst woi, workorder_attr_settings@rms_prod_db_link was
     where o.icmssonumber is null 
       and o.ordernumber = woi.wo_name 
       and woi.wo_inst_id = was.workorder_inst_id
       and was.val_attr_inst_id = uda_inst_id;

  cursor c_fictbillnumber_missing(uda_inst_id in varchar2) is   
    select o.ordernumber, cpas.attr_value
      from stc_order_message o, rms_prod.work_order_inst woi, circ_path_attr_settings@rms_prod_db_link cpas
     where o.fictbillingnumber is null 
       and o.ordernumber = woi.wo_name 
       and woi.element_inst_id = cpas.circ_path_inst_id
       and cpas.val_attr_inst_id = uda_inst_id;


  uda_inst_id NUMBER(10);
  
begin
dbms_output.enable(null);
  
  for miss_bu in c_enterprise_bu_missing loop
    if(miss_bu.domain_name = 'ebu__domain') then
      update stc_order_message set businessunit = 'Enterprise' where ordernumber = miss_bu.ordernumber;
    end if;
  end loop;
dbms_output.put_line('BusinessUnit fixed');

  
  for miss_circuitnumber in c_circNumber_missing loop
    update stc_order_message set circuitnumber = miss_circuitnumber.element_name where ordernumber = miss_circuitnumber.ordernumber;
  end loop;  
dbms_output.put_line('CircuitNumber fixed');


  for miss_creationdate in c_creationdate_missing loop
    update stc_order_message set creationdate = miss_creationdate.creationdate  where ordernumber = miss_creationdate.ordernumber;
  end loop;  
dbms_output.put_line('CreationDate fixed');


  for miss_ordercreationdate in c_ordercreationdate_missing loop
    update stc_order_message set cwordercreationdate = miss_ordercreationdate.creationdate  where ordernumber = miss_ordercreationdate.ordernumber;
  end loop;  
dbms_output.put_line('CWOrderCreationDate fixed');


  select val_attr_inst_id
    into uda_inst_id
    from val_attr_name@rms_prod_db_link van
   where van.attr_name = 'ICMS S/O Number'
     and van.group_name = 'Work Order Info';

  for miss_icmssonumber in c_icmssonumber_missing(uda_inst_id) loop
    update stc_order_message set icmssonumber = miss_icmssonumber.attr_value  where ordernumber = miss_icmssonumber.ordernumber;
  end loop;  
dbms_output.put_line('ICMS_SO_NUMBER fixed');


  select val_attr_inst_id
    into uda_inst_id
    from val_attr_name@rms_prod_db_link van
   where van.attr_name = 'Fict. Billing Number'
     and van.group_name = 'Customer Details';

  for miss_fictbillingnumber in c_fictbillnumber_missing(uda_inst_id) loop
    update stc_order_message set fictbillingnumber = miss_fictbillingnumber.attr_value  where ordernumber = miss_fictbillingnumber.ordernumber;
  end loop;  
dbms_output.put_line('Fict. Billing Number fixed');


end;
/
