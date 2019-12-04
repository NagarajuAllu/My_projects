TRUNCATE TABLE stcw_info_all_services;
TRUNCATE TABLE stcw_info_old_services;


SET SERVEROUTPUT ON


DECLARE
  CURSOR all_service_data IS
    SELECT l.lineitemidentifier,
           l.cwdocid,
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
       AND l.cworderid IN (SELECT x.cworderid
                             FROM stcw_lineitem x
                            WHERE x.provisioningflag IN ('ACTIVE', 'PROVISIONING'))
       AND l.serviceNumber IS NOT NULL
       AND l.workOrderNumber IS NOT NULL
       AND l.workOrderNumber NOT IN ('ITP2', '1-6591583', 'TEST-782', 'CRM5249351', 'C029-TEST#1', 'C029-TEST1#1', 'C029-TEST2#1', 'TESTTEST');


   errorMsg          VARCHAR2(1000);
   statusInGI        VARCHAR2(25);
   giServiceNumber   VARCHAR2(255);
   nextPathInstId    NUMBER(10);

BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  FOR pli IN all_service_data LOOP
    BEGIN

      BEGIN
        statusInGI := NULL;

        giServiceNumber := pli.servicenumber;


        IF(pli.lineitemtype = 'Bundle' OR pli.servicenumber IS NULL OR pli.workordernumber IS NULL) THEN
          statusInGI := NULL;
        ELSE
          IF(pli.provisioningbu = 'W') THEN
            BEGIN
              SELECT DISTINCT status
                INTO statusInGI
                FROM (
                      SELECT r.status
                        FROM resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
                       WHERE r.name = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND r.resource_inst_id = w.element_inst_id
                      UNION
                      SELECT r.status
                        FROM resource_inst@rms_prod_db_link r, del_work_order_inst@rms_prod_db_link w
                       WHERE r.name = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND r.resource_inst_id = w.element_inst_id
                     );
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT DISTINCT status
                    INTO statusInGI
                    FROM (
                          SELECT r.status
                            FROM del_resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
                           WHERE r.name = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND r.resource_inst_id = w.element_inst_id
                          UNION
                          SELECT r.status
                            FROM del_resource_inst@rms_prod_db_link r, del_work_order_inst@rms_prod_db_link w
                           WHERE r.name = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND r.resource_inst_id = w.element_inst_id
                         );
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
              SELECT DISTINCT status
                INTO statusInGI
                FROM (
                      SELECT p.status
                        FROM circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
                       WHERE p.circ_path_hum_id = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND p.circ_path_inst_id = w.element_inst_id
                      UNION
                      SELECT p.status
                        FROM circ_path_inst@rms_prod_db_link p, del_work_order_inst@rms_prod_db_link w
                       WHERE p.circ_path_hum_id = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND p.circ_path_inst_id = w.element_inst_id
                     );
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT DISTINCT status, next_path_inst_id
                    INTO statusInGI, nextPathInstId
                    FROM (
                          SELECT p.status, p.next_path_inst_id
                            FROM del_circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
                           WHERE p.circ_path_hum_id = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND p.circ_path_inst_id = w.element_inst_id
                           UNION
                          SELECT p.status, p.next_path_inst_id
                            FROM del_circ_path_inst@rms_prod_db_link p, del_work_order_inst@rms_prod_db_link w
                           WHERE p.circ_path_hum_id = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND p.circ_path_inst_id = w.element_inst_id
                         );


                  WHILE(nextPathInstId IS NOT NULL) LOOP
                    -- found revision
                    BEGIN
DBMS_OUTPUT.PUT_LINE('Found New Revision for (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||'): nextRevisionInstId is: '||nextPathInstId);

                      SELECT p.status
                        INTO statusInGI
                        FROM circ_path_inst@rms_prod_db_link p
                       WHERE p.circ_path_inst_id = nextPathInstId;

                       nextPathInstId := NULL;
                    EXCEPTION
                      WHEN no_data_found THEN
                        SELECT p.status, p.next_path_inst_id
                          INTO statusInGI, nextPathInstId
                          FROM del_circ_path_inst@rms_prod_db_link p
                         WHERE p.circ_path_inst_id = nextPathInstId;
                      WHEN others THEN
                        statusInGI     := '-6';
                        nextPathInstId := NULL;
                    END;
                  END LOOP;

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

      IF(statusInGI NOT IN ('DECOMMISSIONED', 'CANCELLED')) THEN

        IF(pli.servicetype IN ('C030', 'D024', 'D022', 'D020', 'D019', 'C031') OR  pli.producttype IN ('C030', 'D024', 'D022', 'D020', 'D019', 'C031')) THEN
          INSERT INTO stcw_info_old_services (lineitem_identifier,
                                              service_number,
                                              wo_number,
                                              wo_status,
                                              service_status_gi,
                                              service_type,
                                              product_type,
                                              serv_completion_date,
                                              lineitem_type,
                                              ordernumber,
                                              ordertype
                                              )
          VALUES (pli.lineitemidentifier,
                  pli.servicenumber,
                  pli.workordernumber,
                  (SELECT DISTINCT status_name
                     FROM val_task_status@rms_prod_db_link v, work_order_inst@rms_prod_db_link w
                    WHERE v.stat_code = w.status
                      AND w.wo_name = pli.workordernumber),
                  statusInGI,
                  pli.servicetype,
                  pli.producttype,
                  pli.serv_compl_date,
                  pli.lineItemType,
                  pli.ordernumber,
                  pli.ordertype);
        ELSE
          IF(pli.lineitemtype = 'Bundle') THEN
            DBMS_OUTPUT.PUT_LINE('Record skipped (docid: '||pli.cwdocid||','||pli.workordernumber||'): lineitemtype is: '||pli.lineitemtype);
          ELSE
            INSERT INTO stcw_info_all_services (lineitem_identifier,
                                                service_number,
                                                wo_number,
                                                wo_status,
                                                service_status_gi,
                                                service_type,
                                                product_type,
                                                serv_completion_date,
                                                lineitem_type,
                                                ordernumber,
                                                ordertype
                                              )
            VALUES (pli.lineitemidentifier,
                    pli.servicenumber,
                    pli.workordernumber,
                    (SELECT DISTINCT status_name
                       FROM val_task_status@rms_prod_db_link v, work_order_inst@rms_prod_db_link w
                      WHERE v.stat_code = w.status
                        AND w.wo_name = pli.workordernumber),
                    statusInGI,
                    pli.servicetype,
                    pli.producttype,
                    pli.serv_compl_date,
                    pli.lineItemType,
                    pli.ordernumber,
                    pli.ordertype);
          END IF;
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('Record skipped (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||'): statusInGI is: '||statusInGI);
      END IF;

    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('Error in processing pli (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||'): '||errorMsg);
    END;
  END LOOP;
END;
/


COMMIT;

-- spare records
INSERT INTO stcw_info_all_services (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype)
VALUES ('1-6654265', 'CL01-0000001-A', '1-6654265', 'COMPLETED', 'ACTIVE', 'CL01', 'CL01', to_date('26/02/2012 13:00:13', 'dd/mm/yyyy hh24:mi:ss'), 'Root', '1-6654265', 'I');

INSERT INTO stcw_info_all_services (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype)
SELECT l.lineItemIdentifier, l.serviceNumber, l.workOrderNumber, 'COMPLETED', DECODE(l.workOrderType, 'D', 'DECOMMISSIONED', 'ACTIVE'), l.serviceType, l.productType, l.completionDate, l.lineItemType, h.orderNumber, h.orderType
  FROM stcw_lineitem l, stcw_bundleorder_header h
 where l.provisioningFlag = 'ACTIVE'
   and h.cworderid = l.cworderid
   and servicenumber in ('C001-2000147-A',
                         'C001-2000143-A',
                         'C001-2000149-A',
                         'CL01-0000001-A',
                         'C004-0000001-A',
                         'C001-2000130-A',
                         'D15N-1000021-A',
                         'C001-2000134-A',
                         'C001-2000140-A',
                         'C001-2000136-A');



-- back up of the tables
DECLARE
  curdate VARCHAR2(6);
BEGIN
  SELECT TO_CHAR(sysdate, 'yymmdd')
    INTO curdate
    FROM DUAL;

  BEGIN
    EXECUTE IMMEDIATE ('DROP TABLE stcw_info_all_services_'||curdate);
  EXCEPTION
    WHEN others THEN
      NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE ('DROP TABLE stcw_info_old_services_'||curdate);
  EXCEPTION
    WHEN others THEN
      NULL;
  END;

  EXECUTE IMMEDIATE ('CREATE TABLE stcw_info_all_services_'||curdate||' AS SELECT * FROM stcw_info_all_services');
  EXECUTE IMMEDIATE ('CREATE TABLE stcw_info_old_services_'||curdate||' AS SELECT * FROM stcw_info_old_services');
END;
/