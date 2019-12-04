TRUNCATE TABLE stcw_info_all_services;


SET SERVEROUTPUT ON


DECLARE
  CURSOR all_service_data IS
    SELECT l.cwdocid,
           l.servicenumber,
           l.workordernumber,
           l.lineitemstatus,
           l.reservationnumber,
           l.servicetype,
           l.producttype,
           l.provisioningflag,
           l.completiondate serv_compl_date,
           l.lineitemtype,
           l.provisioningbu,
           o.ordernumber,
           o.ordertype,
           o.completiondate ord_compl_date,
           o.ismigrated
      FROM stcw_lineitem l,
           stcw_bundleorder_header o
     WHERE l.cworderid = o.cworderid
       AND l.cworderid IN (SELECT cworderid
                             FROM stcw_lineitem
                            WHERE l.provisioningflag IN ('ACTIVE', 'PROVISIONING'))
       AND l.elementtypeinordertree = 'B';

   
   errorMsg          VARCHAR2(1000);
   statusInGI        VARCHAR2(25);
   giServiceNumber   VARCHAR2(255);

BEGIN
  
  DBMS_OUTPUT.ENABLE(NULL);

  FOR pli IN all_service_data LOOP
    BEGIN

      BEGIN
        statusInGI := NULL;

        giServiceNumber := pli.servicenumber;
                        
        
        IF(pli.lineitemtype = 'Bundle' OR pli.servicenumber IS NULL OR pli.workordernumber IS NULL OR pli.ordertype = 'F') THEN
          statusInGI := NULL;
        ELSE
          IF(pli.provisioningbu = 'W') THEN
            BEGIN
              SELECT r.status
                INTO statusInGI
                FROM resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
               WHERE r.name = giServiceNumber
                 AND w.wo_name = pli.workordernumber
                 AND r.resource_inst_id = w.element_inst_id;
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT r.status
                    INTO statusInGI
                    FROM del_resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
                   WHERE r.name = giServiceNumber
                     AND w.wo_name = pli.workordernumber
                     AND r.resource_inst_id = w.element_inst_id;
                EXCEPTION
                  WHEN no_data_found THEN
                    statusInGI := '-2';
                  WHEN others THEN
                    statusInGI := '-3';
                END;
              WHEN others THEN
                statusInGI := '-1';
            END;
          ELSE
            BEGIN
              SELECT p.status
                INTO statusInGI
                FROM circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
               WHERE p.circ_path_hum_id = giServiceNumber
                 AND w.wo_name = pli.workordernumber
                 AND p.circ_path_inst_id = w.element_inst_id;
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT p.status
                    INTO statusInGI
                    FROM del_circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
                   WHERE p.circ_path_hum_id = giServiceNumber
                     AND w.wo_name = pli.workordernumber
                     AND p.circ_path_inst_id = w.element_inst_id;
                EXCEPTION
                  WHEN no_data_found THEN
                    statusInGI := '-5';
                  WHEN others THEN
                    statusInGI := '-6';
                END;
              WHEN others THEN
                statusInGI := '-4';
            END;             
          END IF;    
        END IF;
      END;
      
      IF(statusInGI = '-2' AND pli.workordernumber like 'I-CRE%') THEN
        statusInGI := 'ACTIVE';
      END IF;
      
      IF(statusInGI = '-5') THEN
        BEGIN
          SELECT p.status
            INTO statusInGI
            FROM circ_path_inst@rms_prod_db_link p
           WHERE p.circ_path_hum_id = giServiceNumber;
        EXCEPTION
          WHEN no_data_found THEN
            BEGIN
              SELECT p.status
                INTO statusInGI
                FROM del_circ_path_inst@rms_prod_db_link p
               WHERE p.circ_path_hum_id = giServiceNumber;
            EXCEPTION
              WHEN no_data_found THEN
                statusInGI := '-15';
              WHEN others THEN
                statusInGI := '-16';
            END;
          WHEN others THEN
            statusInGI := '-14';
        END;             
      END IF;
      
      INSERT INTO stcw_info_all_services (service_number,
                                          wo_number,
                                          wo_status,
                                          service_status_eoc,
                                          service_status_gi,
                                          system_designation,
                                          ni_number,
                                          reservation_number,
                                          service_type,
                                          product_type,
                                          --provisioning_flag,
                                          serv_completion_date,
                                          lineitemtype,
                                          ordernumber,
                                          ordertype,
                                          ord_completion_date,
                                          is_migrated
                                         )
      VALUES (pli.servicenumber,
              pli.workordernumber,
              (SELECT DISTINCT status_name
                 FROM val_task_status@rms_prod_db_link v, work_order_inst@rms_prod_db_link w
                WHERE v.stat_code = w.status
                  AND w.wo_name = pli.workordernumber),
              pli.lineitemstatus,
              statusInGI,
              null, -- system designation
              null, -- ni number
              pli.reservationnumber,
              pli.servicetype,
              pli.producttype,
--              pli.provisioningflag,
              pli.serv_compl_date,
              pli.lineitemtype,
              pli.ordernumber,
              pli.ordertype,
              pli.ord_compl_date,
              pli.ismigrated);
             
    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('Error in processing pli (docid: '||pli.cwdocid||','||pli.workordernumber||'): '||errorMsg);
    END;
  END LOOP;
END;
/