-- THIS ONE HAS TO BE EXECUTED AS CWE

set serveroutput on

DECLARE

  CURSOR legacyorders_curs IS
    SELECT o.cworderid, o.ordernumber
      FROM cwe_downgrade.stc_bundleorder_header o, cwe_downgrade.stc_lineitem l
     WHERE NVL(o.ismigrated, 0) = 0
       AND o.cworderid = l.cworderid
       AND l.producttype NOT IN (SELECT crmproducttype
                                   FROM cwe_downgrade.stc_producttype_name_map)
       AND (SELECT COUNT(*) 
              FROM cwe_downgrade.stc_lineitem l2 
             WHERE l2.cworderid = o.cworderid) < 2
       AND o.ordernumber not like ('%_REVI_%')
       AND o.ordernumber not like ('%_CANC_%')
       AND l.provisioningflag in ('ACTIVE', 'PROVISIONING')
    ORDER BY cworderid;

  CURSOR nv_curs(orderId IN VARCHAR2) IS
    SELECT name, value, cwdocstamp, lastupdateddate, cwordercreationdate, updatedby
      FROM cwe_downgrade.stc_name_value
     WHERE cworderid = orderId
    ORDER BY cwdocid;


  migrated_total   NUMBER(10);
  migrated_success NUMBER(10);
  migrated_error   NUMBER(10);

  error_msg        VARCHAR2(100);
  orderId          VARCHAR2(16);
  orderMdType      cwmdtypes.typeid%TYPE;

  workingVersionId cwmdworkingversion.mid%TYPE;
  count_nv         NUMBER(5);
  nvParentId       VARCHAR2(16);
  nvChildId        VARCHAR2(16);
  
BEGIN

DBMS_OUTPUT.ENABLE(NULL);

  migrated_total := 0;
  migrated_success := 0;
  migrated_error := 0;



  SELECT typeid
    INTO orderMdType
    FROM cwmdtypes
   WHERE typename = 'ds_ws:default_orderSTC';


  SELECT MAX(mid)
    INTO workingVersionId
    FROM cwmdworkingversion;


  FOR cur IN legacyorders_curs LOOP
    BEGIN

      migrated_total := migrated_total + 1;

     INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, LPAD(migrated_total, 5, ' ')||' - Processing order '||cur.ordernumber);
DBMS_OUTPUT.PUT_LINE(LPAD(migrated_total, 5, ' ')||' - Processing order '||cur.ordernumber);

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
       WHERE cwdocid = cur.cworderid;
             


      /*******         ORDER_HEADER           *******/

      -- insert into stc_order_message
      INSERT INTO stc_order_message 
           SELECT h.accountnumber,                                                 -- ACCOUNTNUMBER               
                  NULL,                                                            -- ALTERNATIVESOLUTION
                  l.bandwidth,                                                     -- BANDWIDTH
                  l.serviceType,                                                   -- CCTTYPE
                  l.lineItemIdentifier,                                            -- CIRCUITNUMBER
                  h.createdby,                                                     -- CREATEDBY
                  h.creationdate,                                                  -- CREATIONDATE
                  h.customerIdNumber,                                              -- CUSTOMERIDNUMBER
                  l.fictBillingNumber,                                             -- FICTBILLINGNUMBER
                  l.icmsSONumber,                                                  -- ICMSSONUMBER

                  l.locationAAccessCircuit,                                        -- LOCATIONAACCESSCIRCUIT
                  l.locationAAccessType,                                           -- LOCATIONAACCESSTYPE
                  l.locationACCLICode,                                             -- LOCATIONACCLICODE
                  l.locationACity,                                                 -- LOCATIONACITY
                  l.locationAContactAddress,                                       -- LOCATIONACONTACTADDRESS
                  l.locationAContactEmail,                                         -- LOCATIONACONTACTEMAIL
                  l.locationAContactName,                                          -- LOCATIONACONTACTNAME
                  l.locationAContactTel,                                           -- LOCATIONACONTACTTEL
                  l.locationAExchangeSwitchCode,                                   -- LOCATIONAEXCHANGESWITCHCODE
                  l.locationAInterface,                                            -- LOCATIONAINTERFACE
                  l.locationAJVCode,                                               -- LOCATIONAJVCODE
                  l.locationAPlateID,                                              -- LOCATIONAPLATEID
                  l.locationARemarks,                                              -- LOCATIONAREMARKS

                  l.locationBAccessCircuit,                                        -- LOCATIONBACCESSCIRCUIT
                  l.locationBAccessType,                                           -- LOCATIONBACCESSTYPE
                  l.locationBCCLICode,                                             -- LOCATIONBCCLICODE
                  l.locationBCity,                                                 -- LOCATIONBCITY
                  l.locationBContactAddress,                                       -- LOCATIONBCONTACTADDRESS
                  l.locationBContactEmail,                                         -- LOCATIONBCONTACTEMAIL
                  l.locationBContactName,                                          -- LOCATIONBCONTACTNAME
                  l.locationBContactTel,                                           -- LOCATIONBCONTACTTEL
                  l.locationBExchangeSwitchCode,                                   -- LOCATIONBEXCHANGESWITCHCODE
                  l.locationBInterface,                                            -- LOCATIONBINTERFACE
                  l.locationBJVCode,                                               -- LOCATIONBJVCODE
                  l.locationBPlateID,                                              -- LOCATIONBPLATEID
                  l.locationBRemarks,                                              -- LOCATIONBREMARKS

                  l.oldServiceNumber,                                              -- OLDCIRCUITNUMBER
                  h.orderNumber,                                                   -- ORDERNUMBER
                  l.lineItemStatus,                                                -- ORDERSTATUS
                  h.orderType,                                                     -- ORDERTYPE
                  h.priority,                                                      -- PRIORITY
                  l.projectId,                                                     -- PROJECTID
                  h.referenceTelNumber,                                            -- REFERENCETELNUMBER
                  l.remarks,                                                       -- REMARKS
                  l.serviceDate,                                                   -- SERVICEDATE
                  l.serviceDescription,                                            -- SERVICEDESCRIPTION
                  l.productType,                                                   -- SERVICETYPE
                  l.wires,                                                         -- WIRES
                  h.customerName,                                                  -- CUSTOMERNAME
                  h.customerType,                                                  -- CUSTOMERTYPE
                  h.customerContact,                                               -- CUSTOMERCONTACT
                  l.locationAPlateID,                                              -- PLATEID
                  l.locationAOldPlateID,                                           -- OLDPLATEID
                  l.tbPortNumber,                                                  -- TBPORTNUMBER
                  h.cwDocStamp,                                                    -- CWDOCSTAMP
                  TO_CHAR(orderId + 1),                                            -- CWDOCID
                  h.lastUpdatedDate,                                               -- LASTUPDATEDDATE
                  h.cwOrderCreationDate,                                           -- CWORDERCREATIONDATE
                  orderId,                                                         -- CWORDERID
                  orderId,                                                         -- CWPARENTID
                  h.updatedBy,                                                     -- UPDATEDBY
                  DECODE(l.lineItemStatus, 'Hold', 'Order Received',
                                           'Waiting for Granite Resp', 'Waiting for Granite Response',
                                           'FAILED', 'Granite Call FAILURE',
                                           'Granite Call SUCCESSFUL'),             -- INTERNALORDERSTATUS
                  l.lineItemStatus,                                                -- CIRCUITSTATUS
                  l.locationAUnitNumber,                                           -- UNITNUMBER
                  NULL,                                                            -- OLDUNITNUMBER
                  'Enterprise',                                                    -- BUSINESSUNIT
                  h.customerIDType,                                                -- CUSTOMERIDTYPE
                  h.customerNumber,                                                -- CUSTOMERNUMBER
                  NULL                                                            -- LASTWOSUMESSAGEDATE
             FROM cwe_downgrade.stc_bundleorder_header h, cwe_downgrade.stc_lineitem l
            WHERE h.cworderid = cur.cworderid
              AND h.cworderid = l.cworderid;  

      -- insert into cworderitems record for orderHeader
      INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                pos, instancekey,    hasattachment,
                                order_creation_date)
                         SELECT orderId,    orderId,  TO_CHAR(orderId + 1),  'default_orderSTC.orderMessage',
                                0,   'orderMessage', 4,
                                cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = cur.cworderid;


      /*******         SERVICE_PARAMETER           *******/


      -- insert into stc_service_parameters
      INSERT INTO stc_service_parameters 
           SELECT creationDate,                  -- CREATIONDATE
                  serviceNumber,                 -- SERVICENUMBER
                  oldServiceNumber,              -- OLDSERVICENUMBER
                  serviceDate,                   -- SERVICEDATE
                  serviceDescription,            -- SERVICEDESCRIPTION
                  serviceType,                   -- SERVICETYPE
                  cwDocStamp,                    -- CWDOCSTAMP
                  TO_CHAR(orderId + 4),          -- CWDOCID
                  lastUpdatedDate,               -- LASTUPDATEDDATE
                  cwOrderCreationDate,           -- CWORDERCREATIONDATE
                  orderId,                       -- CWORDERID
                  TO_CHAR(orderId + 3),          -- CWPARENTID
                  updatedBy,                     -- UPDATEDBY
                  lineItemStatus,                -- SERVICESTATUS
                  NULL                           -- ISVPN
             FROM cwe_downgrade.stc_lineitem  
            WHERE cworderid = cur.cworderid;

      -- insert into cworderitems records for messageParameters:
      --   container
      INSERT INTO cworderitems (toporderid, parentid, itemid,                metadatatype,
                                pos, instancekey,    hasattachment,
                                order_creation_date)
                         SELECT orderId,    orderId,  TO_CHAR(orderId + 2),  'default_orderSTC.serviceParametersList',
                                1,   'serviceParametersList', 0,
                                cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = cur.cworderid;

      --   container.1
      INSERT INTO cworderitems (toporderid, parentid,              itemid,                metadatatype,
                                pos, instancekey,               hasattachment,
                                order_creation_date)
                         SELECT orderId,    TO_CHAR(orderId + 2),  TO_CHAR(orderId + 3),  'default_orderSTC.serviceParametersList',
                                1,   'serviceParametersList.1', 0,
                                cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = cur.cworderid;

      --   container.1.serviceParameters
      INSERT INTO cworderitems (toporderid, parentid,              itemid,                metadatatype,
                                pos, instancekey,                                 hasattachment,
                                order_creation_date)
                         SELECT orderId,    TO_CHAR(orderId + 3),  TO_CHAR(orderId + 4),  'default_orderSTC.serviceParametersList.serviceParameters',
                                0,   'serviceParametersList.1.serviceParameters', 4,
                                cwordercreationdate 
                           FROM cwe_downgrade.stc_bundleorder_header 
                          WHERE cworderid = cur.cworderid;



      /*******         NAME_VALUE           *******/
      count_nv := 0;
      FOR nv IN nv_curs(cur.cworderid) LOOP
        BEGIN
          IF(count_nv = 0) THEN
            -- insert into cworderitems record container for nameValue:
            INSERT INTO cworderitems (toporderid, parentid,              itemid,                metadatatype,
                                      pos, instancekey,                             hasattachment,
                                      order_creation_date)
                               SELECT orderId,    TO_CHAR(orderId + 3),  TO_CHAR(orderId + 5),  'default_orderSTC.serviceParametersList.nameValueList',
                                      1,   'serviceParametersList.1.nameValueList', 0,
                                      cwordercreationdate 
                                 FROM cwe_downgrade.stc_bundleorder_header 
                                WHERE cworderid = cur.cworderid;
          END IF;
        
          nvParentId := TO_CHAR(orderId + 6 + count_nv*2);
          nvChildId  := TO_CHAR(orderId + 6 + count_nv*2 + 1);
          count_nv   := count_nv + 1;
          
          -- insert into stc_name_value
          INSERT INTO stc_name_value VALUES (
            nv.name,                -- NAME               
            nv.value,               -- VALUE              
            nv.cwdocstamp,          -- CWDOCSTAMP         
            nvChildId,              -- CWDOCID            
            nv.lastupdateddate,     -- LASTUPDATEDDATE    
            nv.cwordercreationdate, -- CWORDERCREATIONDATE
            orderId,                -- CWORDERID          
            nvParentId,             -- CWPARENTID         
            nv.updatedby            -- UPDATEDBY          
          );


          --   container.1
          INSERT INTO cworderitems (toporderid, parentid,              itemid,      metadatatype,
                                    pos, instancekey,                                                     hasattachment,
                                    order_creation_date)
                             SELECT orderId,    TO_CHAR(orderId + 5),  nvParentId,  'default_orderSTC.serviceParametersList.nameValueList',
                                    count_nv,   'serviceParametersList.1.nameValueList.'||count_nv, 0,
                                    cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = cur.cworderid;
    
          --   container.1.serviceParameters
          INSERT INTO cworderitems (toporderid, parentid,    itemid,     metadatatype,
                                    pos, instancekey,                                                      hasattachment,
                                    order_creation_date)
                             SELECT orderId,    nvParentId,  nvChildId,  'default_orderSTC.serviceParametersList.nameValueList.nameValue',
                                    0,   'serviceParametersList.1.nameValueList.'||count_nv||'.nameValue', 4,
                                    cwordercreationdate 
                               FROM cwe_downgrade.stc_bundleorder_header 
                              WHERE cworderid = cur.cworderid;
        END;
      END LOOP;


      migrated_success := migrated_success + 1;

    EXCEPTION
      WHEN others THEN
        error_msg := SUBSTR(sqlerrm, 1, 100);
INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  >>>> Error while processing order ['||cur.ordernumber||']: '||error_msg);
DBMS_OUTPUT.PUT_LINE('  >>>> Error while processing order ['||cur.ordernumber||']: '||error_msg);
        migrated_error := migrated_error + 1;
    END;
  END LOOP;

INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, 'Migration completed');                       
INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  Total:  '||LPAD(migrated_total, 5, ' '));  
INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  Success:'||LPAD(migrated_success, 5, ' '));
INSERT INTO stc_downgrade_log VALUES (stc_downgrade_log_seq.NEXTVAL, SYSDATE, '  Error:  '||LPAD(migrated_error, 5, ' '));  


DBMS_OUTPUT.PUT_LINE('Migration completed');
DBMS_OUTPUT.PUT_LINE('  Total:  '||LPAD(migrated_total, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Success:'||LPAD(migrated_success, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Error:  '||LPAD(migrated_error, 5, ' '));


END;
/
