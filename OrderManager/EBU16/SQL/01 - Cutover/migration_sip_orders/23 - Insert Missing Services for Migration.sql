set serveroutput on

DECLARE

  serviceDocId  stc_sp_home_sip.cwdocid%type;
  fakeCWOrderId stc_sp_home_sip.cworderid%type;
  pathName VARCHAR2(100);

  CURSOR res_data(circuitNumber IN VARCHAR2) IS 
    SELECT cpi.ordered, cpi.due, 
           si.site_hum_id,
           ri.name res_name, ri.category,
           (SELECT ras.attr_value
              FROM resource_attr_settings@rms_prod_db_link ras, val_attr_name@rms_prod_db_link van
             WHERE ras.resource_inst_id = ri.resource_inst_id
               AND ras.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Service Description') serv_descr
      FROM circ_path_inst@rms_prod_db_link cpi, site_inst@rms_prod_db_link si, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
     WHERE ra.target_inst_id = cpi.circ_path_inst_id
       AND ra.resource_inst_id = ri.resource_inst_id
--       AND ri.category like '%SIP%'
       AND ra.target_type_id = 10
       AND cpi.circ_path_hum_id = circuitNumber
       AND cpi.z_side_site_id = si.site_inst_id;

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);
  
  pathName := 'KAARKHAL-KAARKHAL SIP1';
  
  SELECT cworderid
    INTO fakeCWOrderId
    FROM stc_om_home_sip
   WHERE circuitnumber = pathName;
  
  serviceDocId  := fakeCWOrderId + 1;
  
  FOR p IN res_data(pathName) LOOP
    BEGIN 
      serviceDocId := serviceDocId + 1;
      
      INSERT INTO stc_sp_home_sip(cwdocid, creationdate, servicenumber, plateid, servicedate, servicedescription,
                                 orderrowitemid, servicetype, cworderid)
      VALUES(TO_CHAR(serviceDocId),        -- cwdocid
             p.ordered,                    -- creationdate
             p.res_name,                   -- servicenumber,
             p.site_hum_id,                -- plateid
             p.due,                        -- servicedate, 
             p.serv_descr,                 -- servicedescription,
             -1,                           -- orderrowitemid
             p.category,                   -- servicetype
             TO_CHAR(fakeCWOrderId)        -- cworderid
            );

      DBMS_OUTPUT.PUT_LINE('Added service with name '||p.res_name);
    END;
  END LOOP;
END;
/  