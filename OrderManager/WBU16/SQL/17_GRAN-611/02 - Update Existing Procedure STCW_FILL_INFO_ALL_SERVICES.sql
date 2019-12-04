CREATE OR REPLACE PROCEDURE STCW_FILL_INFO_ALL_SERVICES AS
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
   resourceInstId    NUMBER(10);
   pathInstId        NUMBER(10);
   aSiteInstId       NUMBER(10);
   aSiteHumId        VARCHAR2(100);
   aStateProv        VARCHAR2(40);
   aLatitude         VARCHAR2(20);
   aLongitude        VARCHAR2(20);
   zSiteInstId       NUMBER(10);
   zSiteHumId        VARCHAR2(100);
   zStateProv        VARCHAR2(40);
   zLatitude         VARCHAR2(20);
   zLongitude        VARCHAR2(20);

BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  EXECUTE IMMEDIATE ('TRUNCATE TABLE STCW_INFO_ALL_SERVICES');
  EXECUTE IMMEDIATE ('TRUNCATE TABLE STCW_INFO_ALL_SERVICES_NEW');
  EXECUTE IMMEDIATE ('TRUNCATE TABLE STCW_INFO_OLD_SERVICES');

  FOR pli IN all_service_data LOOP
    BEGIN

      BEGIN
        statusInGI := NULL;

        resourceInstId := NULL;
        pathInstId := NULL;

        aSiteInstId := NULL;
        aSiteHumId := NULL;
        aStateProv := NULL;
        aLatitude  := NULL;
        aLongitude := NULL;

        zSiteInstId := NULL;
        zSiteHumId := NULL;
        zStateProv := NULL;
        zLatitude  := NULL;
        zLongitude := NULL;

        giServiceNumber := pli.servicenumber;


        IF(pli.lineitemtype = 'Bundle' OR pli.servicenumber IS NULL OR pli.workordernumber IS NULL) THEN
          statusInGI := NULL;
        ELSE
          IF(pli.provisioningbu = 'W') THEN
            BEGIN
              SELECT DISTINCT status, resource_inst_id
                INTO statusInGI, resourceInstId
                FROM (
                      SELECT r.status, r.resource_inst_id
                        FROM resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
                       WHERE r.name = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND r.resource_inst_id = w.element_inst_id
                      UNION
                      SELECT r.status, r.resource_inst_id
                        FROM resource_inst@rms_prod_db_link r, del_work_order_inst@rms_prod_db_link w
                       WHERE r.name = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND r.resource_inst_id = w.element_inst_id
                     );
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT DISTINCT status, resource_inst_id
                    INTO statusInGI, resourceInstId
                    FROM (
                          SELECT r.status, r.resource_inst_id
                            FROM del_resource_inst@rms_prod_db_link r, work_order_inst@rms_prod_db_link w
                           WHERE r.name = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND r.resource_inst_id = w.element_inst_id
                          UNION
                          SELECT r.status, r.resource_inst_id
                            FROM del_resource_inst@rms_prod_db_link r, del_work_order_inst@rms_prod_db_link w
                           WHERE r.name = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND r.resource_inst_id = w.element_inst_id
                         );
                EXCEPTION
                  WHEN no_data_found THEN
                    statusInGI := '-2';
                    resourceInstId :=  null;
                  WHEN others THEN
                    statusInGI := '-3';
                    resourceInstId :=  null;
                END;
              WHEN others THEN
                statusInGI := '-1';
                resourceInstId :=  null;
            END;

            IF(resourceInstId IS NOT NULL) THEN
              BEGIN
                SELECT target_inst_id
                  INTO pathInstId
                  FROM resource_associations@rms_prod_db_link ra
                 WHERE ra.resource_inst_id = resourceInstId
                   AND target_type_id = 10;

                BEGIN
                  SELECT a_side_site_id, z_side_site_id
                    INTO aSiteInstId, zSiteInstId
                    FROM (
                          SELECT a_side_site_id, z_side_site_id
                            FROM circ_path_inst@rms_prod_db_link
                           WHERE circ_path_inst_id = pathInstId
                          UNION
                          SELECT a_side_site_id, z_side_site_id
                            FROM del_circ_path_inst@rms_prod_db_link
                           WHERE circ_path_inst_id = pathInstId
                         );
                EXCEPTION
                  WHEN others THEN
DBMS_OUTPUT.PUT_LINE('Unexpected error while searching the site Ids for the path '''||pathInstId||''' for record (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||')');
                    aSiteInstId := NULL;
                    zSiteInstId := NULL;
                END;
              EXCEPTION
                WHEN no_data_found THEN
DBMS_OUTPUT.PUT_LINE('Unable to find the path linked to the resource '''||resourceInstId||''' for record (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||')');
                  pathInstId := null;
                WHEN others THEN
DBMS_OUTPUT.PUT_LINE('Unexpected error while searching the path linked to the resource '''||resourceInstId||''' for record (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||')');
                  pathInstId := null;
              END;
            END IF;

          ELSE
            BEGIN
              SELECT DISTINCT status, a_side_site_id, z_side_site_id
                INTO statusInGI, aSiteInstId, zSiteInstId
                FROM (
                      SELECT p.status, p.circ_path_inst_id, a_side_site_id, z_side_site_id
                        FROM circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
                       WHERE p.circ_path_hum_id = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND p.circ_path_inst_id = w.element_inst_id
                      UNION
                      SELECT p.status, p.circ_path_inst_id, a_side_site_id, z_side_site_id
                        FROM circ_path_inst@rms_prod_db_link p, del_work_order_inst@rms_prod_db_link w
                       WHERE p.circ_path_hum_id = giServiceNumber
                         AND w.wo_name = pli.workordernumber
                         AND p.circ_path_inst_id = w.element_inst_id
                     );
            EXCEPTION
              WHEN no_data_found THEN
                BEGIN
                  SELECT DISTINCT status, next_path_inst_id, a_side_site_id, z_side_site_id
                    INTO statusInGI, nextPathInstId, aSiteInstId, zSiteInstId
                    FROM (
                          SELECT p.status, p.circ_path_inst_id, p.next_path_inst_id, a_side_site_id, z_side_site_id
                            FROM del_circ_path_inst@rms_prod_db_link p, work_order_inst@rms_prod_db_link w
                           WHERE p.circ_path_hum_id = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND p.circ_path_inst_id = w.element_inst_id
                           UNION
                          SELECT p.status, p.circ_path_inst_id, p.next_path_inst_id, a_side_site_id, z_side_site_id
                            FROM del_circ_path_inst@rms_prod_db_link p, del_work_order_inst@rms_prod_db_link w
                           WHERE p.circ_path_hum_id = giServiceNumber
                             AND w.wo_name = pli.workordernumber
                             AND p.circ_path_inst_id = w.element_inst_id
                         );


                  WHILE(nextPathInstId IS NOT NULL) LOOP
                    -- found revision
                    BEGIN
DBMS_OUTPUT.PUT_LINE('Found New Revision for (docid: '||pli.cwdocid||','||pli.workordernumber||','||pli.serviceNumber||'): nextRevisionInstId is: '||nextPathInstId);

                      SELECT p.status, a_side_site_id, z_side_site_id
                        INTO statusInGI, aSiteInstId, zSiteInstId
                        FROM circ_path_inst@rms_prod_db_link p
                       WHERE p.circ_path_inst_id = nextPathInstId;

                       nextPathInstId := NULL;
                    EXCEPTION
                      WHEN no_data_found THEN
                        SELECT p.status, p.next_path_inst_id, a_side_site_id, z_side_site_id
                          INTO statusInGI, nextPathInstId, aSiteInstId, zSiteInstId
                          FROM del_circ_path_inst@rms_prod_db_link p
                         WHERE p.circ_path_inst_id = nextPathInstId;
                      WHEN others THEN
                        statusInGI     := '-6';
                        pathInstId     := NULL;
                        nextPathInstId := NULL;
                    END;
                  END LOOP;

                EXCEPTION
                  WHEN no_data_found THEN
                    statusInGI := '-5';
                    pathInstId := NULL;
                    aSiteInstId := NULL;
                    zSiteInstId := NULL;
                  WHEN others THEN
                    statusInGI := '-6';
                    pathInstId := NULL;
                    aSiteInstId := NULL;
                    zSiteInstId := NULL;
                END;
              WHEN others THEN
                statusInGI := '-4';
                pathInstId := NULL;
                aSiteInstId := NULL;
                zSiteInstId := NULL;
            END;
          END IF;
        END IF;
      END;

      IF(statusInGI = '-2' AND pli.workordernumber like 'I-CRE%') THEN
        IF(pli.workordernumber like 'I-CRE%O') THEN
          statusInGI := 'DECOMMISSIONED';
        ELSE 
          statusInGI := 'ACTIVE';
        END IF;
      END IF;

      IF(statusInGI = '-5') THEN
        BEGIN
          SELECT p.status, a_side_site_id, z_side_site_id
            INTO statusInGI, aSiteInstId, zSiteInstId
            FROM circ_path_inst@rms_prod_db_link p
           WHERE p.circ_path_hum_id = giServiceNumber;
        EXCEPTION
          WHEN no_data_found THEN
            BEGIN
              SELECT p.status, a_side_site_id, z_side_site_id
                INTO statusInGI, aSiteInstId, zSiteInstId
                FROM del_circ_path_inst@rms_prod_db_link p
               WHERE p.circ_path_hum_id = giServiceNumber;
            EXCEPTION
              WHEN no_data_found THEN
                statusInGI := '-15';
                pathInstId := NULL;
                aSiteInstId := NULL;
                zSiteInstId := NULL;
              WHEN others THEN
                statusInGI := '-16';
                pathInstId := NULL;
                aSiteInstId := NULL;
                zSiteInstId := NULL;
            END;
          WHEN others THEN
            statusInGI := '-14';
            pathInstId := NULL;
            aSiteInstId := NULL;
            zSiteInstId := NULL;
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

            -- GATHERING INFO FOR A SITE
            BEGIN
              IF(aSiteInstId IS NOT NULL) THEN
                SELECT site_hum_id, state_prov, latitude, longitude
                  INTO aSiteHumId, aStateProv, aLatitude, aLongitude
                  FROM (
                        SELECT site_hum_id, state_prov, latitude, longitude
                          FROM site_inst@rms_prod_db_link
                         WHERE site_inst_id = aSiteInstId
                        UNION
                        SELECT site_hum_id, state_prov, latitude, longitude
                          FROM del_site_inst@rms_prod_db_link
                         WHERE site_inst_id = aSiteInstId
                       );
              ELSE
                aSiteHumId := NULL;
                aStateProv := NULL;
                aLatitude  := NULL;
                aLongitude := NULL;
              END IF;
            EXCEPTION
              WHEN others THEN
                aSiteHumId := NULL;
                aStateProv := NULL;
                aLatitude  := NULL;
                aLongitude := NULL;
            END;

            -- GATHERING INFO FOR Z SITE
            BEGIN
              IF(zSiteInstId IS NOT NULL) THEN
                SELECT site_hum_id, state_prov, latitude, longitude
                  INTO zSiteHumId, zStateProv, zLatitude, zLongitude
                  FROM (
                        SELECT site_hum_id, state_prov, latitude, longitude
                          FROM site_inst@rms_prod_db_link
                         WHERE site_inst_id = zSiteInstId
                        UNION
                        SELECT site_hum_id, state_prov, latitude, longitude
                          FROM del_site_inst@rms_prod_db_link
                         WHERE site_inst_id = zSiteInstId
                       );
              ELSE
                zSiteHumId := NULL;
                zStateProv := NULL;
                zLatitude  := NULL;
                zLongitude := NULL;
              END IF;
            EXCEPTION
              WHEN others THEN
                zSiteHumId := NULL;
                zStateProv := NULL;
                zLatitude  := NULL;
                zLongitude := NULL;
            END;

            INSERT INTO stcw_info_all_services_new (lineitem_identifier,
                                                    service_number,
                                                    wo_number,
                                                    wo_status,
                                                    service_status_gi,
                                                    service_type,
                                                    product_type,
                                                    serv_completion_date,
                                                    lineitem_type,
                                                    ordernumber,
                                                    ordertype,
                                                    customer_site_a,
                                                    region_site_a,
                                                    latitude_site_a,
                                                    longitude_site_a,
                                                    customer_site_z,
                                                    region_site_z,
                                                    latitude_site_z,
                                                    longitude_site_z
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
                    pli.ordertype,
                    aSiteHumId,
                    aStateProv,
                    aLatitude,
                    aLongitude,
                    zSiteHumId,
                    zStateProv,
                    zLatitude,
                    zLongitude
                   );

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

  -- spare records
  INSERT INTO stcw_info_all_services (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype)
  VALUES ('1-6654265', 'CL01-0000001-A', '1-6654265', 'COMPLETED', 'ACTIVE', 'CL01', 'CL01', to_date('26/02/2012 13:00:13', 'dd/mm/yyyy hh24:mi:ss'), 'Root', '1-6654265', 'I');

  INSERT INTO stcw_info_all_services_new (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype)
  VALUES ('1-6654265', 'CL01-0000001-A', '1-6654265', 'COMPLETED', 'ACTIVE', 'CL01', 'CL01', to_date('26/02/2012 13:00:13', 'dd/mm/yyyy hh24:mi:ss'), 'Root', '1-6654265', 'I');

  INSERT INTO stcw_info_all_services (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype)
  SELECT l.lineItemIdentifier, l.serviceNumber, l.workOrderNumber, 'COMPLETED', DECODE(l.workOrderType, 'D', 'DECOMMISSIONED', 'ACTIVE'), l.serviceType, l.productType, l.completionDate, l.lineItemType, h.orderNumber, h.orderType
    FROM stcw_lineitem l, stcw_bundleorder_header h
   WHERE l.provisioningFlag = 'ACTIVE'
     AND h.cworderid = l.cworderid
     AND servicenumber in ('C001-2000147-A',
                           'C001-2000143-A',
                           'C001-2000149-A',
                           'CL01-0000001-A',
                           'C004-0000001-A',
                           'C001-2000130-A',
                           'D15N-1000021-A',
                           'C001-2000134-A',
                           'C001-2000140-A',
                           'C001-2000136-A')
     AND servicenumber not in (select distinct service_number from STCW_INFO_ALL_SERVICES);

  INSERT INTO stcw_info_all_services_new (lineitem_identifier, service_number, wo_number, wo_status, service_status_gi, service_type, product_type, serv_completion_date, lineitem_type, ordernumber, ordertype, 
                                          customer_site_a, region_site_a, latitude_site_a, longitude_site_a, customer_site_z, region_site_z, latitude_site_z, longitude_site_z)
  SELECT l.lineItemIdentifier, l.serviceNumber, l.workOrderNumber, 'COMPLETED', DECODE(l.workOrderType, 'D', 'DECOMMISSIONED', 'ACTIVE'), l.serviceType, l.productType, l.completionDate, l.lineItemType, h.orderNumber, h.orderType,
         (SELECT site_hum_id
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.a_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),
         (SELECT state_prov
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.a_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),
         (SELECT latitude
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.a_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),
         (SELECT longitude
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.a_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),
         (SELECT site_hum_id
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.z_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),
         (SELECT state_prov
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.z_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),     
         (SELECT latitude
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.z_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         ),      
         (SELECT longitude
            FROM site_inst@rms_prod_db_link si, circ_path_inst@rms_prod_db_link cpi, resource_inst@rms_prod_db_link ri, resource_associations@rms_prod_db_link ra
           WHERE si.site_inst_id = cpi.z_side_site_id
             AND cpi.circ_path_inst_id = ra.target_inst_id
             AND ra.target_type_id = 10
             AND ra.resource_inst_id = ri.resource_inst_id
             AND ri.name = servicenumber
         )
    FROM stcw_lineitem l, stcw_bundleorder_header h
   WHERE l.provisioningFlag = 'ACTIVE'
     AND h.cworderid = l.cworderid
     AND servicenumber in ('C001-2000147-A',
                           'C001-2000143-A',
                           'C001-2000149-A',
                           'CL01-0000001-A',
                           'C004-0000001-A',
                           'C001-2000130-A',
                           'D15N-1000021-A',
                           'C001-2000134-A',
                           'C001-2000140-A',
                           'C001-2000136-A')
     AND servicenumber not in (select distinct service_number from STCW_INFO_ALL_SERVICES_NEW);
          
END;

/
