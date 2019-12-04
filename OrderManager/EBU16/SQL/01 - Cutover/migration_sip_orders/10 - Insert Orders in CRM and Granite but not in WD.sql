set serveroutput on

DECLARE

  CURSOR c_orders_missing_in_wd IS
    SELECT circuitnumber
      FROM ((SELECT circuitnumber
               FROM stc_sip_crm_data, circ_path_inst@rms_prod_db_link
              WHERE circuitnumber = circ_path_hum_id
              UNION
             SELECT circ_path_hum_id circuitnumber
               FROM circ_path_inst@rms_prod_db_link
              WHERE type = 'SIP'
             )
             MINUS 
            SELECT circuitnumber
              FROM stc_om_home_sip
            );

  CURSOR c_circPaths(circuitNumber IN VARCHAR2) IS 
    SELECT cpi.circ_path_inst_id, cpi.ordered, cpi.customer_id, cpi.description, cpi.due, cpi.bandwidth, cpi.status, cpi.type, si.site_hum_id
      FROM circ_path_inst@rms_prod_db_link cpi, site_inst@rms_prod_db_link si
     WHERE cpi.circ_path_hum_id = circuitNumber
       AND cpi.z_side_site_id = si.site_inst_id;


  CURSOR c_workOrders(pathInstId IN NUMBER) IS
    SELECT woi.wo_inst_id, woi.actual_compl, vts.status_name, woi.project_id, woi.wo_name
      FROM work_order_inst@rms_prod_db_link woi, val_task_status@rms_prod_db_link vts
     WHERE woi.element_inst_id = pathInstId
       AND woi.element_type = 'P'
       AND vts.stat_code = woi.status;

  CURSOR c_resources(pathInstId IN NUMBER) IS
    SELECT ri.resource_inst_id, ri.name, ri.category
      FROM resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
     WHERE ra.target_inst_id = pathInstId
       AND ra.resource_inst_id = ri.resource_inst_id
       AND ri.category like '%SIP%'
       AND ra.target_type_id = 10;
       

  found                       CHAR(1);
  fakeCWOrderId               NUMBER(16);
  serviceDocId                NUMBER(16);
  
  accountNumber_udaInstId     NUMBER(10);
  createdBy_udaInstId         NUMBER(10);
  icmsSONumber_udaInstId      NUMBER(10);
  parentOrderNumber_udaInstId NUMBER(10);
  orderType_udaInstId         NUMBER(10);
  fictBillingNumber_udaInstId NUMBER(10);
  wires_udaInstId             NUMBER(10);
    
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

dbms_output.put_line('[INFO] Starting');

  fakeCWOrderId := 9000000000000000;

  -- gathering all the UdaInstId
  SELECT val_attr_inst_id
    INTO accountNumber_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Account Number'
     AND group_name = 'Customer Details';

  SELECT val_attr_inst_id
    INTO createdBy_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Created by'
     AND group_name = 'Service Order Details';
  
  SELECT val_attr_inst_id
    INTO icmsSONumber_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'ICMS S/O Number'
     AND group_name = 'Work Order Info';

  SELECT val_attr_inst_id
    INTO parentOrderNumber_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Parent Order Number'
     AND group_name = 'Work Order Info';

  SELECT val_attr_inst_id
    INTO orderType_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Order Type'
     AND group_name = 'Work Order Info';

  SELECT val_attr_inst_id
    INTO fictBillingNumber_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Fict. Billing Number'
     AND group_name = 'Customer Details';

  SELECT val_attr_inst_id
    INTO wires_udaInstId
    FROM val_attr_name@rms_prod_db_link
   WHERE attr_name = 'Wires'
     AND group_name = 'Circuit Details';
     
     
     
     
  -- starting!!! 
  
  FOR missingOrder IN c_orders_missing_in_wd LOOP
    BEGIN
      found := 'N';
      
dbms_output.put_line('[INFO] Process serviceNumber ['||missingOrder.circuitnumber||']');
      
      -- gather info from the path
      FOR circPath IN c_circPaths(missingOrder.circuitNumber) LOOP
        BEGIN

          -- gather info from the WO
          FOR workOrder IN c_workOrders(circPath.circ_path_inst_id) LOOP 
            BEGIN
    
              fakeCWOrderId := fakeCWOrderId + 100;
    
    
              INSERT INTO stc_om_home_sip(cwdocid, accountnumber, completion_date, createdby, creationdate, customeridnumber, customername,
                                          customernumber, icmssonumber, parentordernumber, orderstatus, ordertype, cwordercreationdate, 
                                          remarks, servicedate, fictbillingnumber, circuitnumber, bandwidth, circuitstatus, commonplateid,
                                          projectid, wires, ordernumber, cworderid, ccttype, isinarchive, migratedtobundle)
              VALUES(TO_CHAR(fakeCWOrderId + 1),                                          -- cwdocid
                     (SELECT cpas.attr_value
                        FROM circ_path_attr_settings@rms_prod_db_link cpas
                       WHERE cpas.circ_path_inst_id = circPath.circ_path_inst_id
                         AND cpas.val_attr_inst_id = accountNumber_udaInstId),            -- accountnumber
                     workOrder.actual_compl,                                              -- completion_date
                     (SELECT cpas.attr_value
                        FROM circ_path_attr_settings@rms_prod_db_link cpas
                       WHERE cpas.circ_path_inst_id = circPath.circ_path_inst_id
                         AND cpas.val_attr_inst_id = createdBy_udaInstId),                -- createdby
                     circPath.ordered,                                                    -- creationdate
                     circPath.customer_id,                                                -- customeridnumber
                     (SELECT customer_name
                        FROM val_customer@rms_prod_db_link v
                       WHERE v.customer_id = circPath.customer_id),                       -- customername
                     circPath.customer_id,                                                -- customernumber
                     (SELECT was.attr_value
                        FROM workorder_attr_settings@rms_prod_db_link was
                       WHERE was.workorder_inst_id = workOrder.wo_inst_id
                         AND was.val_attr_inst_id = icmsSONumber_udaInstId),              -- icmssonumber
                     NVL(
                         (SELECT was.attr_value
                            FROM workorder_attr_settings@rms_prod_db_link was
                           WHERE was.workorder_inst_id = workOrder.wo_inst_id
                             AND was.val_attr_inst_id = parentOrderNumber_udaInstId),
                         workOrder.wo_name),                                              -- parentordernumber
                     workOrder.status_name,                                               -- orderstatus
                     NVL(
                         (SELECT was.attr_value
                            FROM workorder_attr_settings@rms_prod_db_link was
                           WHERE was.workorder_inst_id = workOrder.wo_inst_id
                             AND was.val_attr_inst_id = orderType_udaInstId),
                         SUBSTR(workOrder.wo_name, 1, 1)),                                -- ordertype
                     circPath.ordered,                                                    -- cwordercreationdate
                     circPath.description,                                                -- remarks
                     circPath.due,                                                        -- servicedate
                     (SELECT cpas.attr_value
                        FROM circ_path_attr_settings@rms_prod_db_link cpas
                       WHERE cpas.circ_path_inst_id = circPath.circ_path_inst_id
                         AND cpas.val_attr_inst_id = fictBillingNumber_udaInstId),        -- fictbillingnumber 
                     missingOrder.circuitnumber,                                          -- circuitnumber
                     circPath.bandwidth,                                                  -- bandwidth
                     circPath.status,                                                     -- circuitstatus
                     circPath.site_hum_id,                                                -- commonplateid
                     workOrder.project_id,                                                -- projectid
                     (SELECT cpas.attr_value
                        FROM circ_path_attr_settings@rms_prod_db_link cpas
                       WHERE cpas.circ_path_inst_id = circPath.circ_path_inst_id
                         AND cpas.val_attr_inst_id = wires_udaInstId),                    -- wires
                     workOrder.wo_name,                                                   -- ordernumber
                     TO_CHAR(fakeCWOrderId),                                              -- cworderid
                     circPath.type,                                                       -- ccttype
                     0,                                                                   -- isinarchive
                     0                                                                    -- migratedtobundle
                    ); 
                 
    
              serviceDocId  := fakeCWOrderId + 1;
              
              FOR resourceCursor IN c_resources(circPath.circ_path_inst_id) LOOP
                BEGIN
                  serviceDocId  := serviceDocId + 1;
              
                  INSERT INTO stc_sp_home_sip(cwdocid, creationdate, servicenumber, plateid, servicedate, servicedescription,
                                              orderrowitemid, servicetype, cworderid)
                  VALUES(TO_CHAR(serviceDocId),                                            -- cwdocid
                         circPath.ordered,                                                 -- creationdate
                         resourceCursor.name,                                              -- servicenumber,
                         circPath.site_hum_id,                                             -- plateid
                         circPath.due,                                                     -- servicedate, 
                         (SELECT ras.attr_value
                            FROM resource_attr_settings@rms_prod_db_link ras, val_attr_name@rms_prod_db_link van
                           WHERE ras.resource_inst_id = resourceCursor.resource_inst_id
                             AND ras.val_attr_inst_id = van.val_attr_inst_id
                             AND van.attr_name = 'Service Description'),                   -- servicedescription,
                         -1,                                                               -- orderrowitemid
                         resourceCursor.category,                                          -- servicetype
                         TO_CHAR(fakeCWOrderId)                                            -- cworderid
                        );
    
                END;
              END LOOP;
                 
            END;
          END LOOP;
        
        END;
      END LOOP;
      
    END;
  END LOOP;

END;
/

