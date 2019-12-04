set serveroutput on


-- real procedure
declare
  cursor vpn_records is
    select * 
      from stcw_vpn_migration
     where processResult = 0;

  count_active number(1);
  count_provisioning number(1);
  foundError number(1);
  processResultSingleRow number(1);
  countPathInGI number(1);
  foundWorkOrderNumber stcw_lineitem.workordernumber%type;
  giServiceType stcw_lineitem.servicetype%type;
  
begin

  dbms_output.enable(NULL);
  
  foundError := 0;
  
  for r in vpn_records loop
    begin
      processResultSingleRow := 0;
      giServiceType          := r.newServiceType;
      
      select count(*)
        into count_provisioning
        from stcw_lineitem
       where serviceNumber = r.origServiceNumber
         and provisioningflag = 'PROVISIONING';

      if(count_provisioning > 0) then
        foundError := 1;
        processResultSingleRow := 2; -- there is a provisioning flow in progress ... migration not supported
      end if;
      
      if(processResultSingleRow = 0) then
        select count(*)
          into count_active
          from stcw_lineitem
         where serviceNumber = r.origServiceNumber
           and provisioningflag = 'ACTIVE';
      
        if(count_active = 0) then
          foundError := 1;
          processResultSingleRow := 3; -- there isn't any active order ... migration not supported
        end if;
      end if;
        
      if(processResultSingleRow = 0) then
        select workOrderNumber 
          into foundWorkOrderNumber
          from stcw_lineitem
         where serviceNumber = r.origServiceNumber
           and provisioningflag = 'ACTIVE';
                
        if(foundWorkOrderNumber <> r.origWONumber) then
          foundError := 1;
          processResultSingleRow := 4; -- wo number is different ... migration not supported
        end if;
      end if;
        
      if(processResultSingleRow = 0) then
        select count(*)
          into countPathInGI
          from circ_path_inst@rms_prod_db_link
         where circ_path_hum_id = r.newserviceNumber;
        
       if(countPathInGI = 0) then
         foundError := 1;
          processResultSingleRow := 5; -- path not found in granite ... migration not supported
        end if;
      end if;
         
      if(processResultSingleRow = 0) then
        begin
          select gi_serviceType
            into giServiceType
            from stcw_servicetype_name_map
           where com_serviceType = r.newServiceType;
        exception
          when others then
            NULL;
        end;
              
        update stcw_lineitem
           set productType = r.newServiceType,
               serviceType = giServiceType,
               receivedServiceType = r.newServiceType,
               serviceNumber = r.newServiceNumber,
               locationACCLICode = nvl(r.siteACLLI, locationACCLICode),
               locationACity = nvl(r.siteACity, locationACity),
               locationAPlateId = nvl(r.siteAPlateId, locationAPlateId),
               locationBCCLICode = nvl(r.siteZCLLI, locationBCCLICode),
               locationBCity = nvl(r.siteZCity, locationBCity),
               locationBPlateId = nvl(r.siteZPlateId, locationBPlateId),
               provisioningBU = 'E'
         where serviceNumber = r.origServiceNumber
           and provisioningflag = 'ACTIVE';
        
        processResultSingleRow := 1;
      end if;
               

      update stcw_vpn_migration
         set processResult = processResultSingleRow
       where origServiceNumber = r.origServiceNumber;

    end;
  end loop;
  
  if(foundError <> 0) then
    dbms_output.put_line ('There was at least one error while processing the result set! Please check the processResult!');
  end if;
end;
/
