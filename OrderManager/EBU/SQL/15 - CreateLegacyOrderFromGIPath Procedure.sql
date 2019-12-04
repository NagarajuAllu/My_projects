CREATE OR REPLACE PROCEDURE CreateLegacyOrderFromGIPath (pathName IN VARCHAR2, errorMsg OUT VARCHAR2) AS

  pathInstId          NUMBER(10);
  pathHumId           VARCHAR2(100);
  customerId          VARCHAR2(60);
  serviceType         VARCHAR2(30);
  pathComments        VARCHAR2(4000);
  pathBW              VARCHAR2(30);
  pathASite           VARCHAR2(10);
  pathZSite           VARCHAR2(10);
  orderedDate         DATE;
  dueDate             DATE;
  inServiceDate       DATE;
  decommDate          DATE;

  newOrderNumber      stc_bundleOrder_header.orderNumber%TYPE;
  wOrdInstId          NUMBER(10);
  orderType           VARCHAR2(1);
  orderTypeFromPath   VARCHAR2(1);
  orderStatus         VARCHAR2(20);
  woComments          VARCHAR2(4000);
  complDate           DATE;
  startDate           DATE;

  existOrderNumber    stc_bundleOrder_header.orderNumber%TYPE;
  existOrderStatus    stc_bundleOrder_header.orderStatus%TYPE;
  existServiceNumber  stc_lineItem.serviceNumber%TYPE;
  existLIStatus       stc_lineItem.lineItemStatus%TYPE;
  existProvFlag       stc_lineItem.provisioningFlag%TYPE;
  orderId             cwOrderInstance.cwDocId%TYPE;

  stopRun             VARCHAR2(1);

BEGIN


  -- check if the WO and the path are in online tables
  BEGIN
    SELECT circ_path_inst_id, circ_path_hum_id, order_num
      INTO pathInstId, pathHumId, newOrderNumber
      FROM circ_path_inst@rms_prod_db_link
     WHERE circ_path_hum_id = pathName;
  EXCEPTION
    WHEN no_data_found THEN
      errorMsg := '[ERR] Unable to find Path with name '||pathName||'; it''s missing in online table!';
      RETURN;
    WHEN too_many_rows THEN
      errorMsg := '[ERR] Found more than 1 Path in Granite with name '||pathName||'!';
      RETURN;      
  END;

  IF(newOrderNumber IS NOT NULL) THEN
    BEGIN
      SELECT wo_inst_id
        INTO wOrdInstId
        FROM work_order_inst@rms_prod_db_link
       WHERE wo_name = newOrderNumber;
    EXCEPTION
      WHEN no_data_found THEN
        errorMsg := '[ERR] Unable to find WorkOrder '||newOrderNumber||' linked to Path '||pathName||';'||
                    'it''s missing in online table! Simulating it';
    END;
  ELSE
    BEGIN
      SELECT wo_name, wo_inst_id
        INTO newOrderNumber, wOrdInstId
        FROM work_order_inst@rms_prod_db_link
       WHERE element_inst_id = pathInstId
         AND element_type = 'P';
    EXCEPTION
      WHEN no_data_found THEN
        errorMsg := '[ERR] Unable to find WorkOrder for Path '||pathName||'; it''s missing in online table! Simulating it';
    END;
  END IF;


  -- check if the order exists or not
  BEGIN
    stopRun := 'N';

    IF(newOrderNumber IS NOT NULL) THEN
      SELECT orderStatus, serviceNumber, lineItemStatus, provisioningFlag
        INTO existOrderStatus, existServiceNumber, existLIStatus, existProvFlag
        FROM stc_bundleorder_header h, stc_lineitem b
       WHERE b.cworderid = h.cworderid
         AND h.ordernumber = newOrderNumber
         AND b.elementTypeInOrderTree = 'B';

      stopRun := 'Y';
    END IF;

  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END;

  IF(stopRun = 'Y') THEN
    errorMsg := '[ERR] Order already exists in WD: orderNumber = '||existOrderNumber||'; orderStatus = '||existOrderStatus||'; serviceNumber = '||existServiceNumber||
                '; lineItemStatus = '||existLIStatus||'; provisioningFlag = '||existProvFlag;
    RETURN;
  END IF;



  BEGIN
    stopRun := 'N';

    SELECT orderNumber, orderStatus, lineItemStatus, provisioningFlag
      INTO existOrderNumber, existOrderStatus, existLIStatus, existProvFlag
      FROM stc_bundleorder_header h, stc_lineitem b
     WHERE b.cworderid = h.cworderid
       AND b.serviceNumber = pathHumId
       AND b.elementTypeInOrderTree = 'B'
       AND b.provisioningFlag NOT IN ('CANCELLED', 'OLD')
       AND rownum < 2;

    stopRun := 'Y';

  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END;

  IF(stopRun = 'Y') THEN
    errorMsg := '[ERR] Found order for path in WD: orderNumber = '||existOrderNumber||'; orderStatus = '||existOrderStatus||
                '; serviceNumber = '||pathHumId||'; lineItemStatus = '||existLIStatus||'; provisioningFlag = '||existProvFlag;
    RETURN;
  END IF;


  SELECT cwDocSeq.nextval
    INTO orderId
    FROM dual;


  -- gather values from circ_path_inst
  SELECT customer_id, type, description, bandwidth, a_side_site_id, z_side_site_id, ordered, due, in_service, decommission
    INTO customerId, serviceType, pathComments, pathBW, pathASite, pathZSite, orderedDate, dueDate, inServiceDate, decommDate
    FROM circ_path_inst@rms_prod_db_link
   WHERE circ_path_inst_id = pathInstId;

  IF(serviceType IN ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')) THEN
    errorMsg := '[ERR] The type of the path is '||serviceType||' that is not supported by this procedure';
    RETURN;
  END IF;

  -- computing orderType
  BEGIN
    SELECT attr_value
      INTO orderType
      FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
     WHERE circ_path_inst_id = pathInstId
       AND van.val_attr_inst_id = cpas.val_attr_inst_id
       AND van.attr_name = 'Order Type'
       AND van.group_name = 'Service Order Details';
  EXCEPTION
    WHEN no_data_found THEN
      orderType := NULL;
  END;

  IF(orderType IS NULL AND wOrdInstId IS NOT NULL) THEN
    BEGIN
      SELECT attr_value
        INTO orderType
        FROM rms_prod.workOrder_attr_settings@rms_prod_db_link woas, rms_prod.val_attr_name@rms_prod_db_link van
       WHERE workorder_inst_id = wOrdInstId
         AND van.val_attr_inst_id = woas.val_attr_inst_id
         AND van.attr_name = 'Order Type'
         AND van.group_name = 'Work Order Info';
    EXCEPTION
      WHEN no_data_found THEN
        orderType := NULL;
    END;
  END IF;

  IF(orderType IS NULL AND newOrderNumber IS NOT NULL) THEN
    orderTypeFromPath := substr(newOrderNumber, 1, 1);

    IF(orderTypeFromPath IN ('I', 'C', 'T', 'D', 'E', 'O')) THEN
      orderType := orderTypeFromPath;
    END IF;
  END IF;


  IF(orderType IS NULL) THEN
    errorMsg := '[ERR] Impossible to find OrderType';
    RETURN;
  END IF;

  -- gather values from work_order_inst
  IF(wOrdInstId IS NOT NULL) THEN
    SELECT vts.status_name, comments, actual_compl, start_after
      INTO orderStatus, woComments, complDate, startDate
      FROM work_order_inst@rms_prod_db_link woi, val_task_status@rms_prod_db_link vts
     WHERE wo_inst_id = wOrdInstId
       AND vts.stat_code = woi.status;
  ELSE
    -- simulating WO existence
    orderStatus := 'READY';
    woComments  := NULL;
    complDate   := NULL;
    startDate   := orderedDate;
    IF(orderType = 'O') THEN
      IF(decommDate IS NOT NULL) THEN
        orderStatus := 'COMPLETED';
        complDate   := decommDate;
      END IF;
    ELSE
      IF(inServiceDate IS NOT NULL) THEN
        orderStatus := 'COMPLETED';
        complDate   := inServiceDate;
      END IF;
    END IF;

    SELECT orderType||LPAD(stcOrderNumberSeq.nextval, 7, '0')
      INTO newOrderNumber
      FROM dual;
  END IF;

  IF(startDate IS NULL) THEN
    startDate := complDate;
  END IF;

  IF(complDate IS NULL) THEN
    SELECT '[ERR] Impossible to find the completion date ('||DECODE(orderType, 'O', 'Decommission', 'In Service')||') of the path'
      INTO errorMsg
      FROM dual;
    RETURN;
  END IF;

  INSERT INTO stc_bundleOrder_header(customerIdNumber, accountNumber, orderNumber, orderType, orderStatus, creationDate, createdBy,
                                     serviceDate, priority, remarks, referenceTelNumber, icmsSalesOrderNumber, businessUnit, completionDate,
                                     receivedDate, isMigrated, cwOrderCreationDate, cwOrderId, cwParentId, lastUpdatedDate, updatedBy, cwDocId)
  VALUES(
         -- customerIdNumber
         customerId,

         -- accountNumber
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Account Number'
             AND van.group_name = 'Customer Details'),

         -- orderNumber
         newOrderNumber,

         -- orderType
         orderType,

         -- orderStatus
         orderStatus,

         -- creationDate
         orderedDate,

         -- createdBy
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Created by'
             AND van.group_name = 'Service Order Details'),

         -- serviceDate
         dueDate,

         -- priority
         'Standard',

         -- remarks
         woComments,

         -- referenceTelNumber
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Reference Tel. Number'
             AND van.group_name = 'Circuit Details'),

         -- icmsSalesOrderNumber
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'ICMS S/O Number'
             AND van.group_name = 'Service Order Details'),

         -- businessUnit
         'Enterprise',

         -- completionDate
         complDate,

         -- receivedDate
         startDate,

         -- isMigrated
         1,

         -- cwOrderCreationDate
         startDate,

         -- cwOrderId
         orderId,

         -- cwParentId
         orderId,

         -- lastUpdatedDate
         complDate,

         -- updatedBy
         'upadmin',

         --cwDocId
         TO_CHAR(TO_NUMBER(orderId) + 1)
        );



  INSERT INTO stc_lineItem(lineItemIdentifier, lineItemType, lineItemStatus, workOrderNumber, priority, action, serviceType, serviceNumber,
                           oldServiceNumber, productType, remarks, icmsSONumber, fictBillingNumber, referenceTelNumber, bandwidth,
                           locationACity, locationACCliCode, locationAJVCode, locationAExchangeSwitchCode, locationAAccessType, locationAPlateId,
                           locationAContactAddress, locationAContactName, locationAContactTel, locationAContactEmail,
                           locationBCity, locationBCCliCode, locationBJVCode, locationBExchangeSwitchCode, locationBAccessType, locationBPlateId,
                           locationBContactAddress, locationBContactName, locationBContactTel, locationBContactEmail,
                           wires, serviceDate, creationDate, completionDate, elementTypeInOrderTree, isSubmit, isCancel, alreadySentToGranite,
                           alreadyReceivedCancel, requestedActionIsA, provisioningFlag, cwDocId, cwOrderCreationDate, cwOrderId, cwParentId, updatedBy)
  VALUES(
         -- lineItemIdentifier
         pathHumId,

         -- lineItemType
         'Root',

         -- lineItemStatus
         orderStatus,

         -- workOrderNumber
         newOrderNumber,

         -- priority
         1,

         -- action
         DECODE(orderType, 'I', 'A',
                           'C', 'M',
                           'T', 'M',
                           'D', 'S',
                           'E', 'R',
                           'O', 'D',
                           'M'),

         -- serviceType
         serviceType,

         -- serviceNumber
         pathHumId,

         -- oldServiceNumber
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Old Circuit Number'
             AND van.group_name = 'Circuit Details'),

          --productType
          serviceType,

          -- remarks
          pathComments,

          -- icmsSONumber
          (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'ICMS S/O Number'
             AND van.group_name = 'Service Order Details'),

          -- fictBillingNumber
          (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Fict. Billing Number'
             AND van.group_name = 'Customer Details'),

          -- referenceTelNumber
         (SELECT attr_value
            FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
           WHERE circ_path_inst_id = pathInstId
             AND van.val_attr_inst_id = cpas.val_attr_inst_id
             AND van.attr_name = 'Reference Tel. Number'
             AND van.group_name = 'Circuit Details'),

          -- bandwidth
          pathBW,

          -- locationACity
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'City A'
              AND van.group_name = 'Site A Details'),

          -- locationACCliCode
          (SELECT site_hum_id
             FROM site_inst@rms_prod_db_link
            WHERE site_inst_id = pathASite),

          -- locationAJVCode
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'JV Code A'
              AND van.group_name = 'Site A Details'),

          -- locationAExchangeSwitchCode
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Exchange Switch Code A'
              AND van.group_name = 'Site A Details'),

          -- locationAAccessType
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Access Type A'
              AND van.group_name = 'Site A Details'),

          -- locationAPlateId
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Plate ID A'
              AND van.group_name = 'Site A Details'),

          -- locationAContactAddress
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Address A'
              AND van.group_name = 'Site A Details'),

          -- locationAContactName
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Name A'
              AND van.group_name = 'Site A Details'),

          -- locationAContactTel
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Tel # A'
              AND van.group_name = 'Site A Details'),

          -- locationAContactEmail
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Email A'
              AND van.group_name = 'Site A Details'),

          -- locationZCity
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'City Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZCCliCode
          (SELECT site_hum_id
             FROM site_inst@rms_prod_db_link
            WHERE site_inst_id = pathZSite),

          -- locationZJVCode
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'JV Code Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZExchangeSwitchCode
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Exchange Switch Code Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZAccessType
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Access Type Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZPlateId
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Plate ID Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZContactAddress
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Address Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZContactName
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Name Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZContactTel
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Tel # Z'
              AND van.group_name = 'Site Z Details'),

          -- locationZContactEmail
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Contact Email Z'
              AND van.group_name = 'Site Z Details'),

          -- wires
          (SELECT attr_value
             FROM circ_path_attr_settings@rms_prod_db_link cpas, val_attr_name@rms_prod_db_link van
            WHERE circ_path_inst_id = pathInstId
              AND van.val_attr_inst_id = cpas.val_attr_inst_id
              AND van.attr_name = 'Wires'
              AND van.group_name = 'Circuit Details'),

          -- serviceDate
          dueDate,

          -- creationDate
          orderedDate,

          -- completionDate
          complDate,

          -- elementTypeInOrderTree
          'B',

          -- isSubmit
          1,

          -- isCancel
          0,

          -- alreadySentToGranite
          1,

          -- alreadyReceivedCancel
          0,

          -- requestedActionIsA
          DECODE(orderType, 'I', 1, 0),

          -- provisioningFlag
          'ACTIVE',

          -- cwDocId
          TO_CHAR(TO_NUMBER(orderId) + 4),

          -- cwOrderCreationDate
          startDate,

          -- cwOrderId
          orderId,

          -- cwParentId
          TO_CHAR(TO_NUMBER(orderId) + 3),

          -- updatedBy
          'upadmin'
         );



  INSERT INTO cwOrderInstance (cwDocId, metadataType, state, visualKey, creationDate, createdBy, updatedBy,
                               lastUpdatedDate, hasAttachment, metadataType_ver)
  VALUES(
         -- cwDocId
         orderId,

         -- metadataType
         (SELECT typeid
            FROM cwmdtypes
           WHERE typename = 'ds_ws.bundleOrderSTC'),

         -- state
         'NEW',

         -- visualKey
         'Bundle Order STC',

         -- creationdate
         startDate,

         -- createdBy
         'upadmin',

         -- updatedBy
         'upadmin',

         -- lastUpdatedSate
         nvl(complDate, sysdate),

         -- hasattachment
         0,

         -- metadataType_Ver
         (SELECT MAX(mid)
            FROM cwmdworkingversion)
        );

  INSERT INTO cwOrderItems (topOrderId, parentId, itemId, metadataType, pos, instanceKey, hasAttachment, order_creation_date)
  VALUES(orderId, orderId, TO_CHAR(TO_NUMBER(orderId) + 1), 'bundleOrderSTC.orderHeader', 0, 'orderHeader', 4, startDate);

  INSERT INTO cwOrderItems (topOrderId, parentId, itemId, metadataType, pos, instanceKey, hasAttachment, order_creation_date)
  VALUES(orderId, orderId, TO_CHAR(TO_NUMBER(orderId) + 2), 'bundleOrderSTC.bundles', 2, 'bundles', 0, startDate);

  INSERT INTO cwOrderItems (topOrderId, parentId, itemId, metadataType, pos, instanceKey, hasAttachment, order_creation_date)
  VALUES(orderId, TO_CHAR(TO_NUMBER(orderId) + 2), TO_CHAR(TO_NUMBER(orderId) + 3), 'bundleOrderSTC.bundles', 1, 'bundles.1', 0, startDate);

  INSERT INTO cwOrderItems (topOrderId, parentId, itemId, metadataType, pos, instanceKey, hasAttachment, order_creation_date)
  VALUES(orderId, TO_CHAR(TO_NUMBER(orderId) + 3), TO_CHAR(TO_NUMBER(orderId) + 4), 'bundleOrderSTC.bundles.bundle', 0, 'bundles.1.bundle', 4, startDate);


  INSERT INTO stc_order_orchestration (orderNumber, cwOrderId, cwParentObjectId, sequence, cwOrderItemPath, provisionable, cwDocId, lineItemIdentifier, elementTypeInOrchestration)
  VALUES(newOrderNumber, orderId, orderId, 1, 'orderHeader', 0, orderId, newOrderNumber, 'O');

  INSERT INTO stc_order_orchestration (orderNumber, cwOrderId, cwParentObjectId, sequence, cwOrderItemPath, provisionable, cwDocId, lineItemIdentifier, elementTypeInOrchestration)
  VALUES(newOrderNumber, orderId, orderId, 1, 'bundles.1.bundle', 0, TO_CHAR(TO_NUMBER(orderId) + 4), pathHumId, 'B');

  errorMsg := NULL;

END CreateLegacyOrderFromGIPath;
/