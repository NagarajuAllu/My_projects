declare

  cursor orders_missing is 
    select name from stcw_amo_without_wo_not_in_eoc;
    
  errMsg        varchar2(1000);
  customerId    stcw_data_for_missing_orders.customeridnumber%type;
  orderType     stcw_data_for_missing_orders.ordertype%type;
  serviceDate   date;
  orderNumber   stcw_data_for_missing_orders.ordernumber%type;
  serviceType   stcw_data_for_missing_orders.servicetype%type;
  
  
  
begin

  dbms_output.enable(null);
  
  for o in orders_missing loop
    begin
      orderType   := 'I';
      orderNumber := orderType||'-CRE'||lpad(STCW_MISSING_ORDNUM.nextval, 4, '0');
      serviceType := o.name;
      if(instr(o.name, '-') > 1) then
        serviceType := substr(o.name, 0, instr(o.name, '-') -1);
      end if;
    
      begin 
        select nvl(nvl(ri.due, ri.in_service), sysdate - 1)
          into serviceDate
          from resource_inst@rms_prod_db_link ri
         where ri.name = o.name;
      exception
        when no_data_found then
          serviceDate := (sysdate - 1);
      end;

      begin
        select customer_id
          into customerId
          from resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra, val_customer@rms_prod_db_link c
         where ri.resource_inst_id = ra.resource_inst_id
           and ra.target_type_id = 6
           and c.cust_inst_id = ra.target_inst_id
           and ri.name = o.name;
      exception
        when others then
          customerId := null;
      end;
      
      insert into STCW_DATA_FOR_MISSING_ORDERS(CUSTOMERIDNUMBER, ORDERNUMBER, ORDERTYPE, ORDERSTATUS, CREATIONDATE, CREATEDBY, SERVICEDATE, BUSINESSUNIT, COMPLETIONDATE, 
                                               LINEITEMIDENTIFIER, LINEITEMSTATUS, LINEITEMTYPE, ACTION, WORKORDERNUMBER, SERVICETYPE, PRODUCTCODE, SERVICENUMBER, PROVISIONINGBU, PROCESSED)
                                        values(customerId, orderNumber, orderType, 'COMPLETED', serviceDate, 'NA', serviceDate, 'Wholesale', serviceDate, 
                                               orderNumber, 'COMPLETED', 'Root', 'A', orderNumber, serviceType, serviceType, o.name, 'W', 0); 
    
    exception
      when others then
        errMsg := substr(sqlerrm, 1, 1000);
        dbms_output.put_line('[ERR] '||o.name||': Unexpected error:'||errMsg);
    end;
  end loop;
end;
/
