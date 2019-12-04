CREATE OR REPLACE PACKAGE BODY LEGACY_ORDER_MIGRATION IS

  /***
    To log messages. It insert into the log table and print on stdout.
  ***/
  PROCEDURE log(msg IN VARCHAR2) IS
  BEGIN
    INSERT INTO stc_migration_log VALUES (stc_migration_log_seq.NEXTVAL, SYSDATE, msg);
--    DBMS_OUTPUT.PUT_LINE(msg);
  END log;



  /***
    The MAIN!
    Actions:
    1. It performs migration of all the legacy orders found with:
        - businessUnit = 'Enterprise'
        - migratedToBundle = '0'
    2. validate the new order
    3. generate the orchestration table of the new order
   ***/
  PROCEDURE migrate_all_legacy_orders IS

    CURSOR orders_to_migrate IS
      SELECT o.cwDocId, o.cwOrderId, o.orderNumber, o.orderStatus, o.orderType
        FROM stc_order_message o
       WHERE migratedtobundle = 0
         AND businessUnit = 'Enterprise';

    migrated_total          NUMBER(10);
    migrated_success        NUMBER(10);
    migrated_error          NUMBER(10);
    migrated_error_compl    NUMBER(10);

    bundleOrderId           stc_bundleorder_header.cwOrderId%TYPE;
    bundleOrderMdType       cwmdtypes.typeid%TYPE;
    workingVersionId        cwmdworkingversion.mid%TYPE;

    isValid                 CHAR(1);
    migrated_order_status   stc_bundleorder_header.orderstatus%TYPE;

    error_msg               VARCHAR2(1000);

  BEGIN

DBMS_OUTPUT.ENABLE(NULL);

    migrated_total := 0;
    migrated_success := 0;
    migrated_error := 0;
    migrated_error_compl := 0;

    SELECT typeid
      INTO bundleOrderMdType
      FROM cwmdtypes
     WHERE typename = 'ds_ws.bundleOrderSTC';


    SELECT MAX(mid)
      INTO workingVersionId
      FROM cwmdworkingversion;

    FOR legacyOrder IN orders_to_migrate LOOP
      BEGIN

        migrated_total := migrated_total + 1;

        log(LPAD(migrated_total, 5, ' ')||' - Processing order '||legacyOrder.orderNumber);

        migrate_single_legacy_order(legacyOrder.orderNumber, legacyOrder.orderStatus, legacyOrder.orderType,
                                    legacyOrder.cwOrderId, bundleOrderMdType, workingVersionId, bundleOrderId);


        UPDATE stc_order_message
           SET migratedtobundle = 1
         WHERE cwOrderId = legacyOrder.cwOrderId;

        isValid := 'N';
        validate_bundleOrder(bundleOrderId, isValid);


        SELECT orderStatus
          INTO migrated_order_status
          FROM stc_bundleorder_header
         WHERE cwOrderId = bundleOrderId;

        IF(isValid = 'Y' OR UPPER(migrated_order_status) IN ('COMPLETED', 'CANCELLED')) THEN
          generate_orchestration_table(bundleOrderId);
        END IF;


        IF(isValid = 'Y') THEN
          migrated_success := migrated_success + 1;
        ELSE
          IF(UPPER(migrated_order_status) IN ('COMPLETED', 'CANCELLED')) THEN
            migrated_error_compl := migrated_error_compl + 1;
          ELSE
            migrated_error   := migrated_error + 1;
          END IF;
        END IF;


        IF(MOD(migrated_total, 1000) = 0) THEN
          COMMIT;
        END IF;


      EXCEPTION
        WHEN others THEN
          error_msg := SUBSTR(sqlerrm, 1, 100);
          log('  >>>> Error while processing order ['||legacyOrder.orderNumber||']: '||error_msg);
          migrated_error := migrated_error + 1;
      END;
    END LOOP;


    log('Execution Completed'||chr(10)||'Statistics:'||chr(10)||
        '  Found: '||migrated_total||chr(10)||
        '  Migrated Successfully: '||migrated_success||chr(10)||
        '  Migrated With Validation Errors: '||migrated_error||chr(10)||
        '  Migrated With Validation Errors But Completed: '||migrated_error_compl);

    COMMIT;

  END migrate_all_legacy_orders;



  /***
    It performs migration of a single legacy order found.
   ***/
  PROCEDURE migrate_single_legacy_order(orderNumber IN VARCHAR2, orderStatus IN VARCHAR2, orderType IN VARCHAR2,
                                        legacyOrderId IN VARCHAR2, bundleOrderMdType IN VARCHAR2, workingVersionId IN NUMBER,
                                        bundleOrderId IN OUT VARCHAR2) IS

    woStatus                NUMBER(1);
    woCompletionDate        DATE;
    finalOrderStatus        stc_order_message.orderstatus%TYPE;

  BEGIN

    -- the internal id of the order
    SELECT cwdocseq.NEXTVAL
      INTO bundleOrderId
      FROM DUAL;

    finalOrderStatus := orderStatus;
    
    -- check if status in WD is aligned with WO status in Granite
    IF(UPPER(orderStatus) NOT IN ('COMPLETED', 'CANCELLED')) THEN
      woStatus := -1;

      BEGIN
        SELECT status
          INTO woStatus
          FROM work_order_inst@rms_prod_db_link
         WHERE wo_name = ordernumber;
      EXCEPTION
        WHEN no_data_found THEN
          woStatus := -1;
      END;

      IF(woStatus IN (7, 9)) THEN
        -- update status in WD order
        UPDATE stc_order_message
           SET orderstatus = 'COMPLETED'
         WHERE cworderid = legacyOrderId;

        finalOrderStatus := 'COMPLETED';
        
        BEGIN
          -- update status in WD services
          UPDATE stc_service_parameters
             SET servicestatus = 'COMPLETED'
           WHERE cworderid = legacyOrderId;

        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF; -- end if on woStatus
    END IF; -- end if on orderstatus

    -- gather completionDate of the WO in Granite
    BEGIN
      SELECT actual_compl
        into woCompletionDate
        FROM work_order_inst@rms_prod_db_link
         WHERE wo_name = ordernumber;
    EXCEPTION
      WHEN no_data_found THEN
        woCompletionDate := NULL;
    END;

    /*******      START create bundleOrder     *******/

    /*******         CWORDERINSTANCE           *******/
    INSERT INTO cworderinstance(cwdocid, metadatatype, state, visualkey,
                                creationdate,
                                createdby,
                                updatedby,
                                lastupdateddate,
                                hasattachment, metadatatype_ver,
                                cworderstamp,
                                cwdocstamp)
    SELECT bundleOrderId, bundleOrderMdType, 'New', 'Bundle Order STC',
           creationDate, 'migrationUser', 'migrationUser', lastUpdatedDate,
           0, workingVersionId, cworderstamp, cwdocstamp
      FROM cworderinstance
     WHERE cwdocid = legacyOrderId;


    /*******         BUNDLE_ORDER_HEADER           *******/
    create_bundleOrder_header(bundleOrderId, woCompletionDate, orderNumber, legacyOrderId);
    /*******         END BUNDLE_ORDER_HEADER           *******/

    /*******         STC_LINEITEM FOR BUNDLE                 *******/
    create_lineItem(bundleOrderId, legacyOrderId, orderNumber, finalOrderStatus, orderType, woCompletionDate);
    /*******         END STC_LINEITEM FOR BUNDLE                 *******/

  END migrate_single_legacy_order;



  /***
    Create orderHeader (STC_BUNDLEORDER_HEADER table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_bundleOrder_header(bundleOrderId IN VARCHAR2, woCompletionDate IN DATE, legacyOrderNumber IN VARCHAR2, legacyOrderId IN VARCHAR2) IS
  BEGIN
    -- insert into stc_bundleorder_header
    INSERT INTO stc_bundleorder_header (accountnumber, businessunit, completiondate, createdby, createdbycontactname,
                                        createdbyname, creationdate, customercontact, customercontactname, customeridnumber,
                                        customeridtype, customername, customernumber, customersegmentation, customertype,
                                        cwdocid, cwdocstamp, cwordercreationdate, cworderid, cwparentid, feasibilityfor,
                                        icmssalesordernumber, ismigrated, lastupdateddate, ordernumber, orderstatus, ordertype,
                                        priority, receiveddate, referencetelnumber, remarks, reservation, reservationnumber,
                                        servicedate, updatedby, version)
         SELECT o.accountnumber,                                                 -- ACCOUNTNUMBER
                o.businessUnit,                                                  -- BUSINESSUNIT
                woCompletionDate,                                                -- COMPLETIONDATE
                o.createdBy,                                                     -- CREATEDBY
                NULL,                                                            -- CREATEDBYCONTACTNAME
                NULL,                                                            -- CREATEDBYNAME
                o.creationDate,                                                  -- CREATIONDATE
                o.customerContact,                                               -- CUSTOMERCONTACT
                NULL,                                                            -- CUSTOMERCONTACTNAME
                o.customerIDNumber,                                              -- CUSTOMERIDNUMBER
                o.customerIDType,                                                -- CUSTOMERIDTYPE
                o.customerName,                                                  -- CUSTOMERNAME
                o.customerNumber,                                                -- CUSTOMERNUMBER
                NULL,                                                            -- CUSTOMERSEGMENTATION
                o.customerType,                                                  -- CUSTOMERTYPE
                TO_CHAR(bundleOrderId + 1),                                      -- CWDOCID
                o.cwDocStamp,                                                    -- CWDOCSTAMP
                o.cwOrderCreationDate,                                           -- CWORDERCREATIONDATE
                TO_CHAR(bundleOrderId),                                          -- CWORDERID
                TO_CHAR(bundleOrderId),                                          -- CWPARENTID
                NULL,                                                            -- FEASIBILITYFOR
                o.icmsSONumber,                                                  -- ICMSSALESORDERNUMBER
                1,                                                               -- ISMIGRATED
                o.lastUpdatedDate,                                               -- LASTUPDATEDDATE
                legacyOrderNumber,                                               -- ORDERNUMBER
                o.orderStatus,                                                   -- ORDERSTATUS
                o.orderType,                                                     -- ORDERTYPE
                o.priority,                                                      -- PRIORITY
                o.cwOrderCreationDate,                                           -- RECEIVEDDATE
                o.referenceTelNumber,                                            -- REFERENCETELNUMBER
                o.remarks,                                                       -- REMARKS
                NULL,                                                            -- RESERVATION
                NULL,                                                            -- RESERVATIONNUMBER
                o.serviceDate,                                                   -- SERVICEDATE
                o.updatedBy,                                                     -- UPDATEDBY
                NULL                                                             -- VERSION
           FROM stc_order_message o
          WHERE o.cworderid = legacyOrderId;

    -- insert into cworderitems record for orderHeader
    INSERT INTO cworderitems (toporderid,    parentid,      itemid,                     metadatatype,
                              pos, instancekey,    hasattachment,
                              order_creation_date)
                       SELECT bundleOrderId, bundleOrderId, TO_CHAR(bundleOrderId + 1), 'bundleOrderSTC.orderHeader',
                              0,   'orderHeader', 4,
                              cwordercreationdate
                         FROM stc_order_message
                        WHERE cworderid = legacyOrderId;

  END create_bundleOrder_header;



  /***
    Create lineItem (STC_LINEITEM table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_lineItem(bundleOrderId IN VARCHAR2, legacyOrderId IN VARCHAR2, legacyOrderNumber IN VARCHAR2,
                            legacyOrderStatus IN VARCHAR2, legacyOrderType IN VARCHAR2, woCompletionDate IN DATE) IS

    CURSOR sent_to_granite (orderNumber IN VARCHAR2) IS
      SELECT UPPER(m.sent_order_status)
        FROM stc_orders_sent_to_granite m
       WHERE m.order_number = orderNumber
      ORDER BY m.creation_time DESC;


    CURSOR services_to_migrate(orderId IN VARCHAR2) IS
      SELECT s.cwDocId, s.cwDocStamp, s.cwParentId, s.creationDate, s.oldServiceNumber, s.serviceDate, s.serviceDescription, s.serviceNumber, s.serviceStatus, s.serviceType
        FROM stc_service_parameters s
       WHERE s.cworderId = orderId;


    latestOrderStatusSent   stc_orders_sent_to_granite.sent_order_status%TYPE;
    isCancel                NUMBER(1);
    isSubmit                NUMBER(1);
    bundleAction            stc_lineItem.action%TYPE;
    alreadySentToGranite    stc_lineItem.alreadySentToGranite%TYPE;
    provisioningFlag        stc_lineItem.provisioningFlag%TYPE;

    serviceCreationDate     stc_lineItem.creationDate%TYPE;
    serviceStatus           stc_lineItem.lineItemStatus%TYPE;
    serviceOldServiceNumber stc_lineItem.oldServiceNumber%TYPE;
    serviceDate             stc_lineItem.serviceDate%TYPE;
    serviceDescription      stc_lineItem.serviceDescription%TYPE;
    serviceNumber           stc_lineItem.serviceNumber%TYPE;
    serviceType             stc_lineItem.serviceType%TYPE;
    countNV                 NUMBER(5);
    nvAction                stc_name_value.action%TYPE;

  BEGIN
    /*******         COMPUTING INFO FOR BUNDLE           *******/
    -- compute if the order is a submit or a Cancel or a Revise
    latestOrderStatusSent := NULL;
    OPEN sent_to_granite(legacyOrderNumber);
    FETCH sent_to_granite INTO latestOrderStatusSent;
    CLOSE sent_to_granite;

    isSubmit := 1;
    isCancel := 0;

    IF(UPPER(legacyOrderStatus) = 'REVISE' OR (latestOrderStatusSent IS NOT NULL AND latestOrderStatusSent = 'REVISE')) THEN
      isSubmit := 0;
    END IF;

    IF(UPPER(legacyOrderStatus) IN('CANCEL', 'CANCELLED') OR (latestOrderStatusSent IS NOT NULL AND latestOrderStatusSent = 'CANCEL')) THEN
      isCancel := 1;
      isSubmit := 0;
    END IF;

    bundleAction := decode_action_of_lineItem(legacyOrderStatus, legacyOrderType, isSubmit, isCancel);
    nvAction := get_NVAction(bundleAction);

    -- compute if the order has been already sent to Granite
    alreadySentToGranite := 0;
    IF(UPPER(legacyOrderStatus) NOT IN('NEW', 'CANCEL', 'REVISE')) THEN
      alreadySentToGranite := 1;
    END IF;

    -- compute provisioning flag
    provisioningFlag := 'PROVISIONING';
    IF(UPPER(legacyOrderStatus) = 'COMPLETED') THEN
      IF(isCancel = 1) THEN
        provisioningFlag := 'CANCELLED';
      ELSE
        provisioningFlag := 'ACTIVE';
      END IF;
    ELSIF(UPPER(legacyOrderStatus) = 'CANCELLED') THEN
      provisioningFlag := 'CANCELLED';
    END IF;


    /*******         END COMPUTING INFO FOR BUNDLE           *******/


    -- insert into cworderitems record for "bundles", so bundle container
    INSERT INTO cworderitems (toporderid,    parentid,      itemid,                     metadatatype,
                              pos, instancekey,    hasattachment,
                              order_creation_date)
                       SELECT bundleOrderId, bundleOrderId, TO_CHAR(bundleOrderId + 2), 'bundleOrderSTC.bundles',
                              2,   'bundles', 0,
                              cwordercreationdate
                         FROM stc_order_message
                        WHERE cworderid = legacyOrderId;



    -- insert into stc_lineitem for Bundle
    INSERT INTO stc_lineItem (accountnumber, action, alreadyreceivedcancel, alreadysenttogranite, bandwidth, completiondate,
                              creationdate, cwdocid, cwdocstamp, cwordercreationdate, cworderid, cwparentid, dependencies,
                              elementtypeinordertree, fictbillingnumber, icmssonumber, iscancel, issubmit, lastupdateddate,
                              lineitemidentifier, lineitemstatus, lineitemtype, locationaaccesscircuit, locationaaccesstype,
                              locationacclicode, locationacity, locationacontactaddress, locationacontactemail, locationacontactname,
                              locationacontacttel, locationaexchangeswitchcode, locationainterface, locationajvcode,
                              locationaoldplateid, locationaplateid, locationaremarks, locationaunitnumber, locationbaccesscircuit,
                              locationbaccesstype, locationbcclicode, locationbcity, locationbcontactaddress, locationbcontactemail,
                              locationbcontactname, locationbcontacttel, locationbexchangeswitchcode, locationbinterface,
                              locationbjvcode, locationboldplateid, locationbplateid, locationbremarks, locationbunitnumber,
                              oldaccountnumber, oldservicenumber, priority, producttype, projectid, provisioningflag,
                              referencetelnumber, remarks, requestedactionisa, servicedate, servicedescription, servicenumber,
                              servicetype, tbportnumber, updatedby, wires, workordernumber)
         SELECT o.accountnumber,                                                 -- ACCOUNTNUMBER
                bundleAction,                                                    -- ACTION
                isCancel,                                                        -- ALREADYRECEIVEDCANCEL
                alreadySentToGranite,                                            -- ALREADYSENTTOGRANITE
                o.bandwidth,                                                     -- BANDWIDTH
                woCompletionDate,                                                -- COMPLETIONDATE
                o.creationDate,                                                  -- CREATIONDATE
                TO_CHAR(bundleOrderId + 4),                                      -- CWDOCID
                o.cwDocStamp,                                                    -- CWDOCSTAMP
                o.cwOrderCreationDate,                                           -- CWORDERCREATIONDATE
                TO_CHAR(bundleOrderId),                                          -- CWORDERID
                TO_CHAR(bundleOrderId + 3),                                      -- CWPARENTID
                NULL,                                                            -- DEPENDENCIES
                'B',                                                             -- ELEMENTTYPEINORDERTREE
                o.fictBillingNumber,                                             -- FICTBILLINGNUMBER
                o.icmsSONumber,                                                  -- ICMSSONUMBER
                isCancel,                                                        -- ISCANCEL
                isSubmit,                                                        -- ISSUBMIT
                o.lastUpdatedDate,                                               -- LASTUPDATEDDATE
                o.circuitNumber,                                                 -- LINEITEMIDENTIFIER
                o.circuitStatus,                                                 -- LINEITEMSTATUS
                'Root',                                                          -- LINEITEMTYPE
                o.locationAAccessCircuit,                                        -- LOCATIONAACCESSCIRCUIT
                o.locationAAccessType,                                           -- LOCATIONAACCESSTYPE
                o.locationACCLICode,                                             -- LOCATIONACCLICODE
                o.locationACity,                                                 -- LOCATIONACITY
                o.locationAContactAddress,                                       -- LOCATIONACONTACTADDRESS
                o.locationAContactEmail,                                         -- LOCATIONACONTACTEMAIL
                o.locationAContactName,                                          -- LOCATIONACONTACTNAME
                o.locationAContactTel,                                           -- LOCATIONACONTACTTEL
                o.locationAExchangeSwitchCode,                                   -- LOCATIONAEXCHANGESWITCHCODE
                o.locationAInterface,                                            -- LOCATIONAINTERFACE
                o.locationAJVCode,                                               -- LOCATIONAJVCODE
                o.oldPlateID,                                                    -- LOCATIONAOLDPLATEID
                o.locationAPlateID,                                              -- LOCATIONAPLATEID
                o.locationARemarks,                                              -- LOCATIONAREMARKS
                o.unitNumber,                                                    -- LOCATIONAUNITNUMBER
                o.locationBAccessCircuit,                                        -- LOCATIONBACCESSCIRCUIT
                o.locationBAccessType,                                           -- LOCATIONBACCESSTYPE
                o.locationBCCLICode,                                             -- LOCATIONBCCLICODE
                o.locationBCity,                                                 -- LOCATIONBCITY
                o.locationBContactAddress,                                       -- LOCATIONBCONTACTADDRESS
                o.locationBContactEmail,                                         -- LOCATIONBCONTACTEMAIL
                o.locationBContactName,                                          -- LOCATIONBCONTACTNAME
                o.locationBContactTel,                                           -- LOCATIONBCONTACTTEL
                o.locationBExchangeSwitchCode,                                   -- LOCATIONBEXCHANGESWITCHCODE
                o.locationBInterface,                                            -- LOCATIONBINTERFACE
                o.locationBJVCode,                                               -- LOCATIONBJVCODE
                o.oldPlateID,                                                    -- LOCATIONBOLDPLATEID
                o.locationBPlateID,                                              -- LOCATIONBPLATEID
                o.locationBRemarks,                                              -- LOCATIONBREMARKS
                o.unitNumber,                                                    -- LOCATIONBUNITNUMBER
                NULL,                                                            -- OLDACCOUNTNUMBER
                o.oldCircuitNumber,                                              -- OLDSERVICENUMBER
                1,                                                               -- PRIORITY
                o.serviceType,                                                   -- PRODUCTTYPE
                o.projectId,                                                     -- PROJECTID
                provisioningFlag,                                                -- PROVISIONINGFLAG
                o.referenceTelNumber,                                            -- REFERENCETELNUMBER
                o.remarks,                                                       -- REMARKS
                DECODE(o.orderType, 'I', 1, 0),                                  -- REQUESTEDACTIONISA
                o.serviceDate,                                                   -- SERVICEDATE
                o.serviceDescription,                                            -- SERVICEDESCRIPTION
                o.circuitNumber,                                                 -- SERVICENUMBER
                o.cctType,                                                       -- SERVICETYPE
                o.tbPortNumber,                                                  -- TBPORTNUMBER
                o.updatedBy,                                                     -- UPDATEDBY
                o.wires,                                                         -- WIRES
                o.orderNumber                                                    -- WORKORDERNUMBER
           FROM stc_order_message o
          WHERE o.cworderid = legacyOrderId;

    -- insert into cworderitems record for "bundles.1", so bundle container
    INSERT INTO cworderitems (toporderid,    parentid,                   itemid,                     metadatatype,
                              pos, instancekey,   hasattachment,
                              order_creation_date)
                       SELECT bundleOrderId, TO_CHAR(bundleOrderId + 2), TO_CHAR(bundleOrderId + 3), 'bundleOrderSTC.bundles',
                              1,   'bundles.1',   0,
                              cwordercreationdate
                         FROM stc_order_message
                        WHERE cworderid = legacyOrderId;

    -- insert into cworderitems record for bundle
    INSERT INTO cworderitems (toporderid,    parentid,                   itemid,                     metadatatype,
                              pos, instancekey,    hasattachment,
                              order_creation_date)
                       SELECT bundleOrderId, TO_CHAR(bundleOrderId + 3), TO_CHAR(bundleOrderId + 4), 'bundleOrderSTC.bundles.bundle',
                              0,   'bundles.1.bundle', 4,
                              cwordercreationdate
                         FROM stc_order_message
                        WHERE cworderid = legacyOrderId;


    -- update null value gathering them from stc_service_parameters

    SELECT creationDate, lineItemStatus, oldServiceNumber, serviceDate, serviceDescription, serviceNumber, serviceType
      INTO serviceCreationDate, serviceStatus, serviceOldServiceNumber, serviceDate, serviceDescription, serviceNumber, serviceType
      FROM stc_lineItem
     WHERE cwDocId = TO_CHAR(bundleOrderId + 4);

    countNV := 0;

    /*******      UPDATE STC_LINEITEM FOR ALL THE OLD SERVICES   *******/
    FOR legacyService IN services_to_migrate(legacyOrderId) LOOP
      BEGIN

        IF(serviceCreationDate IS NULL) THEN
          serviceCreationDate := legacyService.creationDate;
          UPDATE stc_lineItem
             SET creationDate = legacyService.creationDate
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;

        IF(serviceStatus IS NULL) THEN
          serviceStatus := legacyService.serviceStatus;
          UPDATE stc_lineItem
             SET lineItemStatus = legacyService.serviceStatus
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;


        IF(serviceOldServiceNumber IS NULL) THEN
          serviceOldServiceNumber := legacyService.oldServiceNumber;
          UPDATE stc_lineItem
             SET oldServiceNumber = legacyService.oldServiceNumber
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;

        IF(serviceDate IS NULL) THEN
          serviceDate := legacyService.serviceDate;
          UPDATE stc_lineItem
             SET serviceDate = legacyService.serviceDate
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;

        IF(serviceDescription IS NULL) THEN
          serviceDescription := legacyService.serviceDescription;
          UPDATE stc_lineItem
             SET serviceDescription = legacyService.serviceDescription
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;

        IF(serviceNumber IS NULL) THEN
          serviceNumber := legacyService.serviceNumber;
          UPDATE stc_lineItem
             SET serviceNumber = legacyService.serviceNumber
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;

        IF(serviceType IS NULL) THEN
          serviceType := legacyService.serviceType;
          UPDATE stc_lineItem
             SET serviceType = legacyService.serviceType
           WHERE cwDocId = TO_CHAR(bundleOrderId + 4);
        END IF;



        /*******      ADD NV PAIRS OF THE SERVICE   *******/
        create_nameValues(bundleOrderId, countNV, legacyOrderId, nvAction, legacyService.cwParentId);

        /*******      END ADD NV PAIRS OF THE SERVICE   *******/

      END;
    END LOOP;

  END create_lineItem;


  /***
    Create nameValue pairs (STC_NAME_VALUE table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_nameValues(bundleOrderId IN VARCHAR2, countNV IN OUT NUMBER, legacyOrderId IN VARCHAR2,
                              nvAction IN VARCHAR2, legacyServiceParentId IN VARCHAR2) IS

    CURSOR nameValues_to_migrate(orderId IN VARCHAR2, parentServiceId IN VARCHAR2) IS
      SELECT nv.cwDocId, nv.cwDocStamp, nv.lastUpdatedDate, nv.cwOrderCreationDate, nv.updatedBy, nv.name, nv.value
        FROM cworderitems parentServiceItem, cworderitems parentNVItem, stc_name_value nv
       WHERE parentServiceItem.toporderid = orderId
         AND parentServiceItem.parentid = parentServiceId
         AND parentServiceItem.metadatatype like '%nameValue%'
         AND parentNVItem.toporderid = orderId
         AND parentNVItem.parentid = parentServiceItem.itemid
         AND nv.cworderid = orderId
         AND nv.cwparentid = parentNVItem.itemid
      ORDER BY parentNVItem.pos;

    nvParentId              VARCHAR2(16);
    nvChildId               VARCHAR2(16);

  BEGIN
    FOR legacyNVPair IN nameValues_to_migrate(legacyOrderId, legacyServiceParentId) LOOP
      BEGIN
        IF(countNV = 0) THEN
          -- insert into cworderitems record container for nameValue:
          INSERT INTO cworderitems (toporderid,     parentid,                    itemid,                      metadatatype,
                                    pos, instancekey,                  hasattachment,
                                    order_creation_date)
                             SELECT bundleOrderId,  TO_CHAR(bundleOrderId + 3),  TO_CHAR(bundleOrderId + 5),  'bundleOrderSTC.bundles.bundleParameters',
                                    1,   'bundles.1.bundleParameters', 0,
                                    cwordercreationdate
                               FROM stc_order_message
                              WHERE cworderid = legacyOrderId;
        END IF;

        nvParentId := TO_CHAR(bundleOrderId + 6 + countNV*2);
        nvChildId  := TO_CHAR(bundleOrderId + 6 + countNV*2 + 1);
        countNV    := countNV + 1;


        INSERT INTO STC_NAME_VALUE(NAME, VALUE, CWDOCSTAMP, CWDOCID, LASTUPDATEDDATE, CWORDERCREATIONDATE, CWORDERID, CWPARENTID, UPDATEDBY, ACTION, PARENTELEMENTID)
          VALUES (legacyNVPair.name,                -- NAME
                  legacyNVPair.value,               -- VALUE
                  legacyNVPair.cwDocStamp,          -- CWDOCSTAMP
                  nvChildId,                        -- CWDOCID
                  legacyNVPair.lastUpdatedDate,     -- LASTUPDATEDDATE
                  legacyNVPair.cwOrderCreationDate, -- CWORDERCREATIONDATE
                  bundleOrderId,                    -- CWORDERID
                  nvParentId,                       -- CWPARENTID
                  legacyNVPair.updatedBy,           -- UPDATEDBY
                  nvAction,                         -- ACTION
                  TO_CHAR(bundleOrderId + 4)        -- PARENTELEMENTID
                 );

        --   container.1
        INSERT INTO cworderitems (toporderid,    parentid,                   itemid,      metadatatype,
                                  pos,      instancekey,                             hasattachment,
                                  order_creation_date)
                           VALUES(bundleOrderId, TO_CHAR(bundleOrderId + 5), nvParentId,  'bundleOrderSTC.bundles.bundleParameters',
                                  countNV,  'bundles.1.bundleParameters.'||countNV,  0,
                                  legacyNVPair.cwOrderCreationDate);

        --   container.1.bundleParameters
        INSERT INTO cworderitems (toporderid,    parentid,    itemid,     metadatatype,
                                  pos, instancekey,                                                hasattachment,
                                  order_creation_date)
                           VALUES(bundleOrderId, nvParentId,  nvChildId,  'bundleOrderSTC.bundles.bundleParameters.bundleParameter',
                                  0,   'bundles.1.bundleParameters.'||countNV||'.bundleParameter', 4,
                                  legacyNVPair.cwOrderCreationDate);


      END;
    END LOOP;

  END create_nameValues;

  /***
    To decode the action of the lineItem according to the:
    - orderStatus
    - orderType
    - if it's a SubmitOrder
    - if it's a CancelOrder
  ***/
  FUNCTION decode_action_of_lineItem(bundleOrderStatus IN VARCHAR2, bundleOrderType IN VARCHAR2, isSubmit IN NUMBER, isCancel IN NUMBER) RETURN VARCHAR2 IS

    bundleAction stc_lineItem.action%TYPE;

  BEGIN
    -- compute the proper action for the order
    bundleAction := get_action_by_orderStatus_type(bundleOrderStatus, bundleOrderType);

    IF(bundleAction IS NULL) THEN
      IF(isSubmit = 1) THEN
        bundleAction := get_action_by_orderStatus_type('NEW', bundleOrderType);
      ELSIF(isCancel = 1) THEN
        bundleAction := get_action_by_orderStatus_type('CANCEL', bundleOrderType);
      ELSE
        bundleAction := get_action_by_orderStatus_type('REVISE', bundleOrderType);
      END IF;
    END IF;

    RETURN bundleAction;

  END decode_action_of_lineItem;


  /***
    To decode the action of the lineItem according to the:
    - orderStatus
    - orderType
  ***/
  FUNCTION get_action_by_orderStatus_Type(orderStatus IN VARCHAR2, orderType IN VARCHAR2) RETURN VARCHAR2 IS

    bundleAction stc_lineItem.action%TYPE;

  BEGIN

    IF(UPPER(orderStatus) = 'NEW') THEN
      IF(orderType = 'I') THEN
        bundleAction := 'A';
      ELSIF(orderType IN('C', 'T')) THEN
        bundleAction := 'M';
      ELSIF(orderType = 'D') THEN
        bundleAction := 'S';
      ELSIF(orderType = 'E') THEN
        bundleAction := 'R';
      ELSIF(orderType = 'O') THEN
        bundleAction := 'D';
      END IF;
    ELSIF(UPPER(orderStatus) IN ('CANCEL', 'CANCELLED')) THEN
      bundleAction := 'C';
    ELSIF(UPPER(orderStatus) = 'REVISE') THEN
      bundleAction := 'M';
    END IF;

    RETURN bundleAction;

  END get_action_by_orderStatus_Type;


  /***
    To decode the action of the nvPair according to the:
    - action of the lineItem parent
  ***/
  FUNCTION get_NVAction(bundleAction IN VARCHAR2) RETURN VARCHAR2 IS

    nvAction stc_name_value.action%TYPE;

  BEGIN

    nvAction := 'Add';
    IF(bundleAction = 'A') THEN
      nvAction := 'Add';
    ELSIF(bundleAction IN('D', 'S')) THEN
      nvAction := 'Remove';
    ELSIF(bundleAction IN('M', 'R', 'C')) THEN
      nvAction := 'Modify';
    ELSIF(bundleAction = 'N') THEN
      nvAction := 'No-Change';
    END IF;

    RETURN nvAction;

  END get_NVAction;


  /***
    Validate the bundleOrder just created and dump all errors found.
  ***/
  PROCEDURE validate_bundleOrder(bundleOrderId IN VARCHAR2, isValid OUT CHAR) IS

    headerValidationPrinted    CHAR(1);

  BEGIN

    headerValidationPrinted := 'N';

    validate_bundleOrder_header(bundleOrderId, headerValidationPrinted);

    validate_lineItem(bundleOrderId, headerValidationPrinted);

    validate_NV_pairs(bundleOrderId, headerValidationPrinted);

    IF(headerValidationPrinted = 'Y') THEN
      isValid := 'N';
    ELSE
      isValid := 'Y';
    END IF;

  END validate_bundleOrder;



  /***
    Validate the header of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_bundleOrder_header(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR) IS

    CURSOR orderHeader IS
      SELECT *
        FROM stc_bundleorder_header
       WHERE cwOrderId = bundleOrderId;

  BEGIN

    FOR o in orderHeader LOOP
      BEGIN

        IF(o.orderNumber IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "orderNumber"');
        END IF;

        IF(o.orderType IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "orderType"');
        ELSIF(o.orderType NOT IN ('I', 'C', 'T', 'D', 'E', 'O')) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "orderType": invalid value in enumeration ['||o.orderType||']');
        END IF;

        IF(o.orderStatus IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "orderStatus"');
        END IF;

        IF(o.creationDate IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "creationDate"');
        END IF;

        IF(o.createdBy IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "createdBy"');
        END IF;

        IF(o.businessUnit IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "businessUnit"');
        ELSIF(o.businessUnit NOT IN ('Home', 'Enterprise', 'Wholesale')) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "businessUnit": invalid value in enumeration ['||o.businessUnit||']');
        END IF;

        IF(o.feasibilityFor IS NOT NULL AND is_a_valid_value(o.feasibilityFor, 'ds_ws:feasibilityFor') = 'N') THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "feasibilityFor": invalid value in enumeration ['||o.feasibilityFor||']');
        END IF;

        IF(o.reservation IS NOT NULL AND o.feasibilityFor NOT IN ('Y', 'N')) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "reservation": invalid value in enumeration ['||o.reservation||']');
        END IF;

      END;
    END LOOP;

  END validate_bundleOrder_header;


  /***
    Validate the lineItem of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_lineItem(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR) IS

    CURSOR lineItems IS
      SELECT *
        FROM stc_lineItem
       WHERE cwOrderId = bundleOrderId;

  BEGIN

    FOR l in lineItems LOOP
      BEGIN

        IF(l.lineItemIdentifier IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "lineItemIdentifier"');
        END IF;

        IF(l.priority IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "priority"');
        END IF;

        IF(l.action IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "action"');
        ELSIF(l.action NOT IN ('A', 'D', 'M', 'N', 'S', 'R', 'C')) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "action": invalid value in enumeration ['||l.action||']');
        END IF;

        IF(l.serviceType IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "serviceType"');
        END IF;

        IF(l.serviceNumber IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "serviceNumber"');
        END IF;

        IF(l.icmsSONumber IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "icmsSONumber"');
        END IF;

        IF(l.fictBillingNumber IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "fictBillingNumber"');
        END IF;

        IF(l.wires IS NOT NULL AND is_a_valid_value(l.wires, 'ds_ws:wires') = 'N') THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "wires": invalid value in enumeration ['||l.wires||']');
        END IF;

        IF(l.elementTypeInOrderTree IS NOT NULL AND l.elementTypeInOrderTree NOT IN ('O', 'B', 'C', 'S', 'T')) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "elementTypeInOrderTree": invalid value in enumeration ['||l.elementTypeInOrderTree||']');
        END IF;

      END;
    END LOOP;

  END validate_lineItem;


  /***
    Validate the nv pairs of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_NV_pairs(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR) IS

    CURSOR nameValues IS
      SELECT *
        FROM stc_name_value
       WHERE cwOrderId = bundleOrderId;

  BEGIN

    FOR nv in nameValues LOOP
      BEGIN

        IF(nv.name IS NULL) THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE0030 = No value in mandatory field "name"');
        END IF;

        IF(nv.action IS NOT NULL AND is_a_valid_value(nv.action, 'ds_ws:nvAction') = 'N') THEN
          print_validation_header(bundleOrderId, headerValidationPrinted);
          log('DE1107 = "action": invalid value in enumeration ['||nv.action||']');
        END IF;

      END;
    END LOOP;

  END validate_NV_pairs;



  /***
    Print validation header only if it's the first time for the order
  ***/
  PROCEDURE print_validation_header(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR) IS
  BEGIN

    IF(headerValidationPrinted = 'N') THEN
      log('Validation Errors in order '||bundleOrderId);
      headerValidationPrinted := 'Y';
    END IF;

  END print_validation_header;



  /***
    To verify if the input value is a valid value for the dataType.
    The check is implemented using the values in table STC_PICKLIST_FOR_VALIDATION.
    Return 'Y' is the valid is valid, 'N' otherwise.
   ***/
  FUNCTION is_a_valid_value(inputValue IN VARCHAR2, inputDataTypeName IN VARCHAR2) RETURN CHAR IS

    found       CHAR(1);
    countRecord NUMBER(1);

  BEGIN
    SELECT count(*)
      INTO countRecord
      FROM STC_PICKLIST_FOR_VALIDATION
     WHERE dataTypeName = inputDataTypeName
       AND value = inputValue;

    IF(countRecord > 0) THEN
      found := 'Y';
    ELSE
      found := 'N';
    END IF;

    RETURN found;

  END is_a_valid_value;



  /***
    It generates the entries for orchestration table for the new order.
   ***/
  PROCEDURE generate_orchestration_table(bundleOrderId IN VARCHAR2) IS
  BEGIN

    INSERT INTO stc_order_orchestration(orderNumber, cwOrderId, cwParentObjectId, sequence, cwOrderItemPath,
                                        provisionable, cwDocId, lineItemIdentifier, elementTypeInOrchestration)
         SELECT o.orderNumber,                    -- ORDERNUMBER
                o.cwOrderId,                      -- CWORDERID
                o.cwOrderId,                      -- CWPARENTOBJECTID
                1,                                -- SEQUENCE
                'orderHeader',                    -- CWORDERITEMPATH
                0,                                -- PROVISIONABLE
                o.cwOrderId,                      -- CWDOCID
                o.orderNumber,                    -- LINEITEMIDENTIFIER
                'O'                               -- ELEMENTTYPEINORCHESTRATION
           FROM stc_bundleorder_header o
          WHERE o.cwOrderId = bundleOrderId;

    INSERT INTO stc_order_orchestration(orderNumber, cwOrderId, cwParentObjectId, sequence, cwOrderItemPath,
                                        provisionable, cwDocId, lineItemIdentifier, elementTypeInOrchestration)
         SELECT o.orderNumber,                    -- ORDERNUMBER
                o.cwOrderId,                      -- CWORDERID
                o.cwOrderId,                      -- CWPARENTOBJECTID
                1,                                -- SEQUENCE
                'bundles.1.bundle',               -- CWORDERITEMPATH
                1,                                -- PROVISIONABLE
                b.cwDocId,                        -- CWDOCID
                b.lineItemIdentifier,             -- LINEITEMIDENTIFIER
                'B'                               -- ELEMENTTYPEINORCHESTRATION
           FROM stc_bundleorder_header o, stc_lineItem b
          WHERE o.cwOrderId = bundleOrderId
            AND b.cwOrderId = o.cwOrderId;

  END generate_orchestration_table;


END LEGACY_ORDER_MIGRATION;
/