-- THIS ONE HAS TO BE EXECUTED AS CWH

DECLARE

  CURSOR siporder_cursor IS
    SELECT o.cworderid, o.ordernumber
      FROM cwe_downgrade.stc_bundleorder_header o, cwe_downgrade.stc_lineitem b
     WHERE NVL(o.ismigrated, 0) = 0
       AND o.cworderid = b.cworderid
       AND b.elementTypeInOrderTree = 'B'
       AND b.producttype IN (SELECT crmproducttype
                               FROM cwe_downgrade.stc_producttype_name_map
                              WHERE internalproducttype = 'Bundle SIP')
       AND (SELECT COUNT(*) 
              FROM cwe_downgrade.stc_lineitem c 
             WHERE c.cworderid = o.cworderid
               AND c.elementTypeInOrderTree = 'C') < 2
       AND o.ordernumber not like ('%_REVI_%')
       AND o.ordernumber not like ('%_CANC_%')
       AND b.provisioningflag in ('ACTIVE', 'PROVISIONING')
    ORDER BY cworderid;


  CURSOR serv_curs(orderId IN VARCHAR2) IS
    SELECT cwdocid
      FROM cwe_downgrade.stc_lineitem
     WHERE cworderid = orderId
       AND elementTypeInOrderTree = 'S'
    ORDER BY cwdocid;
       

  CURSOR nv_curs(orderId IN VARCHAR2, parentElmtId IN VARCHAR2) IS
    SELECT name, value, cwdocstamp, lastupdateddate, cwordercreationdate, updatedby, cwdocid
      FROM cwe_downgrade.stc_name_value nv
     WHERE nv.cworderid = orderId
       AND nv.parentElementId = parentElmtId
    UNION
    SELECT nv.name, nv.value, nv.cwdocstamp, nv.lastupdateddate, nv.cwordercreationdate, nv.updatedby, nv.cwdocid
      FROM cwe_downgrade.stc_name_value nv, cwe_downgrade.stc_lineitem c
     WHERE nv.cworderid = orderId
       AND nv.parentElementId = c.cwdocid
       AND c.elementTypeInOrderTree = 'C'
       AND c.cworderid = orderId
    ORDER BY cwdocid;


  migrated_total   NUMBER(10);
  migrated_success NUMBER(10);
  migrated_error   NUMBER(10);

  error_msg        VARCHAR2(100);
  orderId          VARCHAR2(16);
  orderMdType      cwmdtypes.typeid%TYPE;

  workingVersionId cwmdworkingversion.mid%TYPE;
  count_sp         NUMBER(5);
  spContainerId    NUMBER(16);

  count_nv         NUMBER(5);
  nvContainerId    NUMBER(16);
  nvChildId        NUMBER(16);
  
BEGIN

  migrated_total := 0;
  migrated_success := 0;
  migrated_error := 0;



  SELECT typeid
    INTO orderMdType
    FROM cwmdtypes
   WHERE typename = 'ds_ws:default_orderSTC_HOME';


  SELECT MAX(mid)
    INTO workingVersionId
    FROM cwmdworkingversion;


  FOR o_cur IN siporder_cursor LOOP
    BEGIN

      migrated_total := migrated_total + 1;

      /*******
      
                    MANAGING PARENT ORDER!!!
      
                                                 *******/



      INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, LPAD(migrated_total, 5, ' ')||' - Processing order '||o_cur.ordernumber||' PARENT');



      SELECT CWDOCSEQ.NEXTVAL
        INTO orderId
        FROM DUAL;

      /*******         CWORDERINSTANCE           *******/
      INSERT INTO cworderinstance(cwdocid, metadatatype, state, visualkey,             
                                  creationdate,
                                  createdby,
                                  updatedby,
                                  lastupdateddate,
                                  hasattachment, metadatatype_ver,
                                  cworderstamp,
                                  cwdocstamp)
      SELECT orderId, orderMdType, 'New', 'STC Order [Default]',
             creationdate, createdby, updatedby, lastupdateddate,
             0, workingVersionId, cworderstamp, cwdocstamp
        FROM cwe_downgrade.cworderinstance
       WHERE cwdocid = o_cur.cworderid;
             


      /*******         ORDER_HEADER           *******/

      -- insert into stc_order_message
      INSERT INTO stc_order_message_home
           SELECT h.accountnumber,                                                 -- ACCOUNTNUMBER               
                  NULL,                                                            -- ALTERNATIVESOLUTION
                  c.bandwidth,                                                     -- BANDWIDTH
                  'SIP',                                                           -- CCTTYPE
                  c.serviceNumber,                                                 -- CIRCUITNUMBER
                  h.createdby,                                                     -- CREATEDBY
                  h.creationdate,                                                  -- CREATIONDATE
                  h.customerIdNumber,                                              -- CUSTOMERIDNUMBER
                  c.fictBillingNumber,                                             -- FICTBILLINGNUMBER
                  c.icmsSONumber,                                                  -- ICMSSONUMBER

                  c.oldServiceNumber,                                              -- OLDCIRCUITNUMBER
                  h.orderNumber,                                                   -- ORDERNUMBER
                  h.orderStatus,                                                   -- ORDERSTATUS
                  h.orderType,                                                     -- ORDERTYPE
                  h.priority,                                                      -- PRIORITY
                  c.projectId,                                                     -- PROJECTID
                  h.referenceTelNumber,                                            -- REFERENCETELNUMBER
                  h.remarks,                                                       -- REMARKS
                  h.serviceDate,                                                   -- SERVICEDATE
                  c.serviceDescription,                                            -- SERVICEDESCRIPTION
                  NULL,                                                            -- SERVICETYPE
                  c.wires,                                                         -- WIRES
                  h.customerName,                                                  -- CUSTOMERNAME
                  h.customerType,                                                  -- CUSTOMERTYPE
                  h.customerContact,                                               -- CUSTOMERCONTACT
                  c.tbPortNumber,                                                  -- TBPORTNUMBER
                  h.cwDocStamp,                                                    -- CWDOCSTAMP
                  TO_CHAR(orderId + 1),                                            -- CWDOCID
                  h.lastUpdatedDate,                                               -- LASTUPDATEDDATE
                  h.cwOrderCreationDate,                                           -- CWORDERCREATIONDATE
                  orderId,                                                         -- CWORDERID
                  orderId,                                                         -- CWPARENTID
                  h.updatedBy,                                                     -- UPDATEDBY
                  DECODE(c.lineItemStatus, 'Hold', 'Order Received',
                                           'Waiting for Granite Resp', 'Waiting for Granite Response',
                                           'FAILED', 'Granite Call FAILURE',
                                           'Granite Call SUCCESSFUL'),             -- INTERNALORDERSTATUS
                  c.lineItemStatus,                                                -- CIRCUITSTATUS
                  'Home',                                                          -- BUSINESSUNIT
                  h.customerIDType,                                                -- CUSTOMERIDTYPE
                  h.customerNumber,                                                -- CUSTOMERNUMBER
                  0,                                                               -- INHOLD
                  c.locationAPlateID,                                              -- COMMONPLATEID
                  NULL,                                                            -- PARENTORDERNUMBER
                  NULL,                                                            -- COMMONSERVICENUMBER
                  NULL,                                                            -- RESERVATIONNUMBER
                  NULL,                                                            -- RESERVATIONEXPIRY
                  h.completionDate,                                                -- COMPLETION_DATE
                  'IHBU',                                                          -- ORDERDOMAIN
                  NULL,                                                            -- DIALOGSIZEY
                  NULL,                                                            -- DIALOGSIZEX
                  0,                                                               -- TOBESENDING
                  NULL                                                             -- ACTIONONORDER
             FROM cwe_downgrade.stc_bundleorder_header h, cwe_downgrade.stc_lineitem c
            WHERE h.cworderid = o_cur.cworderid
              AND h.cworderid = c.cworderid
              AND c.elementTypeInOrderTree = 'C';  

      -- insert into cworderitems record for orderHeader
      INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                pos, instancekey,    
                                hasattachment, order_creation_date)
                         SELECT orderId,    orderId,  TO_CHAR(orderId + 1),  'default_orderSTC_HOME.orderMessage',
                                0,   'orderMessage', 
                                4,             cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = o_cur.cworderid;


      /*******         LOOP SU SERVICE_PARAMETER           *******/
    
      count_sp := 0;
      spContainerId := orderId + 2;
      
      FOR s_cur IN serv_curs(o_cur.cworderid) LOOP
        BEGIN 
          
          IF (count_sp = 0) THEN
            -- insert into cworderitems records for serviceParameters container
            INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                      pos, instancekey,    
                                      hasattachment, order_creation_date)
                               SELECT orderId,    orderId,  TO_CHAR(orderId + 2),  'default_orderSTC_HOME.serviceParametersList',
                                      1,   'serviceParametersList', 
                                      0,             cwordercreationdate 
                                 FROM cwe_downgrade.stc_bundleorder_header 
                                WHERE cworderid = o_cur.cworderid;
          END IF;
          
          count_sp      := count_sp + 1;
          spContainerId := spContainerId + 1;
    
          -- insert into stc_service_parameters
          INSERT INTO stc_service_parameters_home 
               SELECT creationDate,                  -- CREATIONDATE
                      serviceNumber,                 -- SERVICENUMBER
                      oldServiceNumber,              -- OLDSERVICENUMBER
                      serviceDate,                   -- SERVICEDATE
                      serviceDescription,            -- SERVICEDESCRIPTION
                      serviceType,                   -- SERVICETYPE
                      cwDocStamp,                    -- CWDOCSTAMP
                      TO_CHAR(spContainerId + 1),    -- CWDOCID
                      lastUpdatedDate,               -- LASTUPDATEDDATE
                      cwOrderCreationDate,           -- CWORDERCREATIONDATE
                      orderId,                       -- CWORDERID
                      spContainerId,                 -- CWPARENTID
                      updatedBy,                     -- UPDATEDBY
                      lineItemStatus,                -- SERVICESTATUS
                      locationAPlateID,              -- PLATEID 
                      locationAOldPlateID,           -- OLDPLATEID
                      locationAUnitNumber,           -- UNITNUMBER
                      NULL,                          -- OLDUNITNUMBER
                      -1,                            -- ORDERROWITEMID
                      1,                             -- TOBEPROCESSED
                      isCancel                       -- TOBECANCELLED
                 FROM cwe_downgrade.stc_lineitem s 
                WHERE s.cworderid = o_cur.cworderid
                  AND s.cwdocid = s_cur.cwdocid;
    
          --   container.1
          INSERT INTO cworderitems (toporderid, parentid,              itemid,         metadatatype,
                                    pos, instancekey,               
                                    hasattachment, order_creation_date)
                             SELECT orderId,    TO_CHAR(orderId + 2),  spContainerId,  'default_orderSTC_HOME.serviceParametersList',
                                    count_sp,   'serviceParametersList.'||count_sp, 
                                    0,             cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = o_cur.cworderid;
    
          --   container.1.serviceParameters
          INSERT INTO cworderitems (toporderid, parentid,       itemid,                     metadatatype,
                                    pos, instancekey,                                 
                                    hasattachment, order_creation_date)
                             SELECT orderId,    spContainerId,  TO_CHAR(spContainerId + 1), 'default_orderSTC_HOME.serviceParametersList.serviceParameters',
                                    0,   'serviceParametersList.'||count_sp||'.serviceParameters', 
                                    4,             cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = o_cur.cworderid;
    
    
    
          /*******         NAME_VALUE           *******/
          count_nv      := 0;
          nvContainerId := spContainerId;
          nvChildId     := 0;
          
          FOR nv IN nv_curs(o_cur.cworderid, s_cur.cwdocid) LOOP
            BEGIN
              IF(count_nv = 0) THEN
                -- insert into cworderitems record container for nameValue:
                INSERT INTO cworderitems (toporderid, parentid,       itemid,                     metadatatype,
                                          pos, instancekey,                              
                                          hasattachment, order_creation_date)
                                   SELECT orderId,    spContainerId,  TO_CHAR(spContainerId + 2), 'default_orderSTC_HOME.serviceParametersList.nameValueList',
                                          1,   'serviceParametersList.'||count_sp||'.nameValueList', 
                                          0,             cwordercreationdate 
                                     FROM cwe_downgrade.stc_bundleorder_header 
                                    WHERE cworderid = o_cur.cworderid;
              END IF;
              
              count_nv      := count_nv + 1;
              nvContainerId := nvContainerId + 1;
              nvChildId     := nvContainerId + count_nv*2;
              
              -- insert into stc_name_value
              INSERT INTO stc_name_value VALUES (
                nv.name,                -- NAME               
                nv.value,               -- VALUE              
                nv.cwdocstamp,          -- CWDOCSTAMP         
                TO_CHAR(nvChildId + 1), -- CWDOCID            
                nv.lastupdateddate,     -- LASTUPDATEDDATE    
                nv.cwordercreationdate, -- CWORDERCREATIONDATE
                orderId,                -- CWORDERID          
                nvChildId,              -- CWPARENTID         
                nv.updatedby            -- UPDATEDBY          
              );
    
    
              --   container.1
              INSERT INTO cworderitems (toporderid, parentid,                    itemid,         metadatatype,
                                        pos, instancekey,                                                     
                                        hasattachment, order_creation_date)
                                 SELECT orderId,    TO_CHAR(spContainerId + 2),  nvChildId,  'default_orderSTC_HOME.serviceParametersList.nameValueList',
                                        count_nv,   'serviceParametersList.'||count_sp||'.nameValueList.'||count_nv, 
                                        0,             cwordercreationdate 
                                   FROM cwe_downgrade.stc_bundleorder_header 
                                  WHERE cworderid = o_cur.cworderid;
        
              --   container.1.serviceParameters
              INSERT INTO cworderitems (toporderid, parentid,    itemid,                  metadatatype,
                                        pos, instancekey,                                                      
                                        hasattachment, order_creation_date)
                                 SELECT orderId,    nvChildId,   TO_CHAR(nvChildId + 1),  'default_orderSTC_HOME.serviceParametersList.nameValueList.nameValue',
                                        0,   'serviceParametersList.'||count_sp||'.nameValueList.'||count_nv||'.nameValue', 
                                        4,             cwordercreationdate 
                                   FROM cwe_downgrade.stc_bundleorder_header 
                                  WHERE cworderid = o_cur.cworderid;
            END;
          END LOOP;


          spContainerId := nvChildId + 1;
          
        END;
      END LOOP;


      /*******
      
                    MANAGING CHILD ORDER!!!
      
                                                 *******/


      INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, LPAD(migrated_total, 5, ' ')||' - Processing order '||o_cur.ordernumber||' CHILD');



      SELECT CWDOCSEQ.NEXTVAL
        INTO orderId
        FROM DUAL;

      /*******         CWORDERINSTANCE           *******/
      INSERT INTO cworderinstance(cwdocid, metadatatype, state, visualkey,             
                                  creationdate,
                                  createdby,
                                  updatedby,
                                  lastupdateddate,
                                  hasattachment, metadatatype_ver,
                                  cworderstamp,
                                  cwdocstamp)
      SELECT orderId, orderMdType, 'New', 'STC Order [Default]',
             creationdate, createdby, updatedby, lastupdateddate,
             0, workingVersionId, cworderstamp, cwdocstamp
        FROM cwe_downgrade.cworderinstance
       WHERE cwdocid = o_cur.cworderid;
             


      /*******         ORDER_HEADER           *******/

      -- insert into stc_order_message
      INSERT INTO stc_order_message_home
           SELECT h.accountnumber,                                                 -- ACCOUNTNUMBER               
                  NULL,                                                            -- ALTERNATIVESOLUTION
                  c.bandwidth,                                                     -- BANDWIDTH
                  'SIP',                                                           -- CCTTYPE
                  c.serviceNumber,                                                 -- CIRCUITNUMBER
                  h.createdby,                                                     -- CREATEDBY
                  h.creationdate,                                                  -- CREATIONDATE
                  h.customerIdNumber,                                              -- CUSTOMERIDNUMBER
                  c.fictBillingNumber,                                             -- FICTBILLINGNUMBER
                  c.icmsSONumber,                                                  -- ICMSSONUMBER

                  c.oldServiceNumber,                                              -- OLDCIRCUITNUMBER
                  c.workOrderNumber,                                               -- ORDERNUMBER
                  c.lineItemStatus,                                                -- ORDERSTATUS
                  h.orderType,                                                     -- ORDERTYPE
                  h.priority,                                                      -- PRIORITY
                  c.projectId,                                                     -- PROJECTID
                  h.referenceTelNumber,                                            -- REFERENCETELNUMBER
                  h.remarks,                                                       -- REMARKS
                  h.serviceDate,                                                   -- SERVICEDATE
                  c.serviceDescription,                                            -- SERVICEDESCRIPTION
                  NULL,                                                            -- SERVICETYPE
                  c.wires,                                                         -- WIRES
                  h.customerName,                                                  -- CUSTOMERNAME
                  h.customerType,                                                  -- CUSTOMERTYPE
                  h.customerContact,                                               -- CUSTOMERCONTACT
                  c.tbPortNumber,                                                  -- TBPORTNUMBER
                  h.cwDocStamp,                                                    -- CWDOCSTAMP
                  TO_CHAR(orderId + 1),                                            -- CWDOCID
                  h.lastUpdatedDate,                                               -- LASTUPDATEDDATE
                  h.cwOrderCreationDate,                                           -- CWORDERCREATIONDATE
                  orderId,                                                         -- CWORDERID
                  orderId,                                                         -- CWPARENTID
                  h.updatedBy,                                                     -- UPDATEDBY
                  DECODE(c.lineItemStatus, 'Hold', 'Order Received',
                                           'Waiting for Granite Resp', 'Waiting for Granite Response',
                                           'FAILED', 'Granite Call FAILURE',
                                           'Granite Call SUCCESSFUL'),             -- INTERNALORDERSTATUS
                  c.lineItemStatus,                                                -- CIRCUITSTATUS
                  'Home',                                                          -- BUSINESSUNIT
                  h.customerIDType,                                                -- CUSTOMERIDTYPE
                  h.customerNumber,                                                -- CUSTOMERNUMBER
                  0,                                                               -- INHOLD
                  c.locationAPlateID,                                              -- COMMONPLATEID
                  h.orderNumber,                                                   -- PARENTORDERNUMBER
                  NULL,                                                            -- COMMONSERVICENUMBER
                  NULL,                                                            -- RESERVATIONNUMBER
                  NULL,                                                            -- RESERVATIONEXPIRY
                  h.completionDate,                                                -- COMPLETION_DATE
                  'IHBU',                                                          -- ORDERDOMAIN
                  NULL,                                                            -- DIALOGSIZEY
                  NULL,                                                            -- DIALOGSIZEX
                  0,                                                               -- TOBESENDING
                  NULL                                                             -- ACTIONONORDER
             FROM cwe_downgrade.stc_bundleorder_header h, cwe_downgrade.stc_lineitem c
            WHERE h.cworderid = o_cur.cworderid
              AND h.cworderid = c.cworderid
              AND c.elementTypeInOrderTree = 'C';  

      -- insert into cworderitems record for orderHeader
      INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                pos, instancekey,    
                                hasattachment, order_creation_date)
                         SELECT orderId,    orderId,  TO_CHAR(orderId + 1),  'default_orderSTC_HOME.orderMessage',
                                0,   'orderMessage', 
                                4,             cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = o_cur.cworderid;


      /*******         LOOP SU SERVICE_PARAMETER           *******/
    
      count_sp := 0;
      spContainerId := orderId + 2;
      
      FOR s_cur IN serv_curs(o_cur.cworderid) LOOP
        BEGIN 
          
          IF (count_sp = 0) THEN
            -- insert into cworderitems records for serviceParameters container
            INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                      pos, instancekey,    
                                      hasattachment, order_creation_date)
                               SELECT orderId,    orderId,  TO_CHAR(orderId + 2),  'default_orderSTC_HOME.serviceParametersList',
                                      1,   'serviceParametersList', 
                                      0,             cwordercreationdate 
                                 FROM cwe_downgrade.stc_bundleorder_header 
                                WHERE cworderid = o_cur.cworderid;
          END IF;
          
          count_sp      := count_sp + 1;
          spContainerId := spContainerId + 1;
    
          -- insert into stc_service_parameters
          INSERT INTO stc_service_parameters_home 
               SELECT creationDate,                  -- CREATIONDATE
                      serviceNumber,                 -- SERVICENUMBER
                      oldServiceNumber,              -- OLDSERVICENUMBER
                      serviceDate,                   -- SERVICEDATE
                      serviceDescription,            -- SERVICEDESCRIPTION
                      serviceType,                   -- SERVICETYPE
                      cwDocStamp,                    -- CWDOCSTAMP
                      TO_CHAR(spContainerId + 1),    -- CWDOCID
                      lastUpdatedDate,               -- LASTUPDATEDDATE
                      cwOrderCreationDate,           -- CWORDERCREATIONDATE
                      orderId,                       -- CWORDERID
                      spContainerId,                 -- CWPARENTID
                      updatedBy,                     -- UPDATEDBY
                      lineItemStatus,                -- SERVICESTATUS
                      locationAPlateID,              -- PLATEID 
                      locationAOldPlateID,           -- OLDPLATEID
                      locationAUnitNumber,           -- UNITNUMBER
                      NULL,                          -- OLDUNITNUMBER
                      -1,                            -- ORDERROWITEMID
                      1,                             -- TOBEPROCESSED
                      isCancel                       -- TOBECANCELLED
                 FROM cwe_downgrade.stc_lineitem s 
                WHERE s.cworderid = o_cur.cworderid
                  AND s.cwdocid = s_cur.cwdocid;
    
          --   container.1
          INSERT INTO cworderitems (toporderid, parentid,              itemid,         metadatatype,
                                    pos, instancekey,               
                                    hasattachment, order_creation_date)
                             SELECT orderId,    TO_CHAR(orderId + 2),  spContainerId,  'default_orderSTC_HOME.serviceParametersList',
                                    1,   'serviceParametersList.'||count_sp, 
                                    0,             cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = o_cur.cworderid;
    
          --   container.1.serviceParameters
          INSERT INTO cworderitems (toporderid, parentid,       itemid,                     metadatatype,
                                    pos, instancekey,                                 
                                    hasattachment, order_creation_date)
                             SELECT orderId,    spContainerId,  TO_CHAR(spContainerId + 1), 'default_orderSTC_HOME.serviceParametersList.serviceParameters',
                                    0,   'serviceParametersList.'||count_sp||'.serviceParameters', 
                                    4,             cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = o_cur.cworderid;
    
    
    
          /*******         NAME_VALUE           *******/
          count_nv      := 0;
          nvContainerId := spContainerId;
          nvChildId     := 0;
          
          FOR nv IN nv_curs(o_cur.cworderid, s_cur.cwdocid) LOOP
            BEGIN
              IF(count_nv = 0) THEN
                -- insert into cworderitems record container for nameValue:
                INSERT INTO cworderitems (toporderid, parentid,       itemid,                     metadatatype,
                                          pos, instancekey,                              
                                          hasattachment, order_creation_date)
                                   SELECT orderId,    spContainerId,  TO_CHAR(spContainerId + 2), 'default_orderSTC_HOME.serviceParametersList.nameValueList',
                                          1,   'serviceParametersList.'||count_sp||'.nameValueList', 
                                          0,             cwordercreationdate 
                                     FROM cwe_downgrade.stc_bundleorder_header 
                                    WHERE cworderid = o_cur.cworderid;
              END IF;
              
              count_nv      := count_nv + 1;
              nvContainerId := nvContainerId + 1;
              nvChildId     := nvContainerId + count_nv*2;
              
              -- insert into stc_name_value
              INSERT INTO stc_name_value VALUES (
                nv.name,                -- NAME               
                nv.value,               -- VALUE              
                nv.cwdocstamp,          -- CWDOCSTAMP         
                TO_CHAR(nvChildId + 1), -- CWDOCID            
                nv.lastupdateddate,     -- LASTUPDATEDDATE    
                nv.cwordercreationdate, -- CWORDERCREATIONDATE
                orderId,                -- CWORDERID          
                nvChildId,              -- CWPARENTID         
                nv.updatedby            -- UPDATEDBY          
              );
    
    
              --   container.1
              INSERT INTO cworderitems (toporderid, parentid,                    itemid,         metadatatype,
                                        pos, instancekey,                                                     
                                        hasattachment, order_creation_date)
                                 SELECT orderId,    TO_CHAR(spContainerId + 2),  nvChildId,  'default_orderSTC_HOME.serviceParametersList.nameValueList',
                                        1,   'serviceParametersList.'||count_sp||'.nameValueList.'||count_nv, 
                                        0,             cwordercreationdate 
                                   FROM cwe_downgrade.stc_bundleorder_header 
                                  WHERE cworderid = o_cur.cworderid;
        
              --   container.1.serviceParameters
              INSERT INTO cworderitems (toporderid, parentid,    itemid,                  metadatatype,
                                        pos, instancekey,                                                      
                                        hasattachment, order_creation_date)
                                 SELECT orderId,    nvChildId,   TO_CHAR(nvChildId + 1),  'default_orderSTC_HOME.serviceParametersList.nameValueList.nameValue',
                                        0,   'serviceParametersList.'||count_sp||'.nameValueList.'||count_nv||'.nameValue', 
                                        4,             cwordercreationdate 
                                   FROM cwe_downgrade.stc_bundleorder_header 
                                  WHERE cworderid = o_cur.cworderid;
            END;
          END LOOP;


          spContainerId := nvChildId + 1;
          
        END;
      END LOOP;


      migrated_success := migrated_success + 1;

    EXCEPTION
      WHEN others THEN
        error_msg := SUBSTR(sqlerrm, 1, 100);
INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, '  >>>> Error while processing order ['||o_cur.ordernumber||']: '||error_msg);
        migrated_error := migrated_error + 1;
    END;
  END LOOP;

INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, 'Migration completed');                       
INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, '  Total:  '||LPAD(migrated_total, 5, ' '));  
INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, '  Success:'||LPAD(migrated_success, 5, ' '));
INSERT INTO downgrade_log VALUES (downgrade_log_seq.NEXTVAL, SYSDATE, '  Error:  '||LPAD(migrated_error, 5, ' '));  


DBMS_OUTPUT.PUT_LINE('Migration completed');
DBMS_OUTPUT.PUT_LINE('  Total:  '||LPAD(migrated_total, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Success:'||LPAD(migrated_success, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Error:  '||LPAD(migrated_error, 5, ' '));


END;
/
