set serveroutput on


DECLARE

  TYPE OrderIdList IS TABLE OF VARCHAR2(50);
  orders_under_mgmt  OrderIdList;

  errorMsg           VARCHAR2(1000);
  countRecords       NUMBER(10);
  errorFound         NUMBER(1);
  
  orderNum           VARCHAR2(50);
  
  foundOrderType     stcw_bundleorder_header.orderType%TYPE;
  foundCWOrderId     stcw_bundleorder_header.cwOrderId%TYPE;
  foundProvFlag      stcw_lineitem.provisioningFlag%TYPE;
  foundProvBU        stcw_lineitem.provisioningBU%TYPE;
  foundServiceNum    stcw_lineitem.serviceNumber%TYPE;
  foundLIIdentifier  stcw_lineitem.lineItemIdentifier%TYPE;
  foundWONumber      stcw_lineitem.workOrderNumber%TYPE;
  
  wosuMsgXML         VARCHAR2(2000);
  
  foundWOActualCompl DATE;
  foundWOStatus      CHAR(1);
  foundUDAValue      VARCHAR2(3100);  
  foundWOComments    VARCHAR2(3100);
  foundActualImpl    VARCHAR2(3100);
  foundPlanFeas      VARCHAR2(3100);
  foundReservDays    VARCHAR2(3100);
  
BEGIN
  
  DBMS_OUTPUT.ENABLE(NULL);

  orders_under_mgmt := OrderIdList(
'F-10548515-6319', 'F-10548515-6320', 'F-10548515-6321', 'F-10548515-6322', 'F-10548515-6323', 'F-10548515-6324', 'F-10548515-6325', 
'F-10548515-6326', 'F-10548515-6327', 'F-10548515-6328', 'F-10548515-6329', 'F-10548515-6330', 'F-10548515-6331', 'F-10548515-6332', 
'F-10548515-6333', 'F-10548515-6334', 'F-10548515-6335', 'F-10548515-6336', 'F-10548515-6337', 'F-10548515-6338', 'F-10548515-6339', 
'F-10547989-6277', 'F-10547989-6278', 'F-10547989-6279', 'F-10547989-6280', 'F-10547989-6281', 'F-10547989-6282', 'F-10547989-6283', 
'F-10547989-6284', 'F-10547989-6285', 'F-10547989-6286', 'F-10547989-6287', 'F-10547989-6288', 'F-10547989-6289', 'F-10547989-6290', 
'F-10547989-6291', 'F-10547989-6292', 'F-10547989-6293', 'F-10547989-6294', 'F-10547989-6295', 'F-10547989-6296', 'F-10547989-6297', 
'F-10547463-6235', 'F-10547463-6236', 'F-10547463-6237', 'F-10547463-6238', 'F-10547463-6239', 'F-10547463-6240', 'F-10547463-6241', 
'F-10547463-6242', 'F-10547463-6243', 'F-10547463-6244', 'F-10547463-6245', 'F-10547463-6246', 'F-10547463-6247', 'F-10547463-6248', 
'F-10547463-6249', 'F-10547463-6250', 'F-10547463-6251', 'F-10547463-6252', 'F-10547463-6253', 'F-10547463-6254', 'F-10547463-6255', 
'F-10546937-6193', 'F-10546937-6194', 'F-10546937-6195', 'F-10546937-6196', 'F-10546937-6197', 'F-10546937-6198', 'F-10546937-6199', 
'F-10546937-6200', 'F-10546937-6201', 'F-10546937-6202', 'F-10546937-6203', 'F-10546937-6204', 'F-10546937-6205', 'F-10546937-6206', 
'F-10546937-6207', 'F-10546937-6208', 'F-10546937-6209', 'F-10546937-6210', 'F-10546937-6211', 'F-10546937-6212', 'F-10546937-6213', 
'F-10546411-6151', 'F-10546411-6152', 'F-10546411-6153', 'F-10546411-6154', 'F-10546411-6155', 'F-10546411-6156', 'F-10546411-6157', 
'F-10546411-6158', 'F-10546411-6159', 'F-10546411-6160', 'F-10546411-6161', 'F-10546411-6162', 'F-10546411-6163', 'F-10546411-6164', 
'F-10546411-6165', 'F-10546411-6166', 'F-10546411-6167', 'F-10546411-6168', 'F-10546411-6169', 'F-10546411-6170', 'F-10546411-6171', 
'F-10545871-6108', 'F-10545871-6110', 'F-10545871-6111', 'F-10545871-6112', 'F-10545871-6113', 'F-10545871-6114', 'F-10545871-6115', 
'F-10545871-6116', 'F-10545871-6117', 'F-10545871-6118', 'F-10545871-6119', 'F-10545871-6120', 'F-10545871-6121', 'F-10545871-6122', 
'F-10545871-6123', 'F-10545871-6124', 'F-10545871-6125', 'F-10545871-6126', 'F-10545871-6127', 'F-10545871-6128', 'F-10545871-6129',
'F-10549202-6373', 'F-10549189-6371', 'F-10549055-6363', 'F-10549041-6361'
);

/****

  Tests for PT

  orders_under_mgmt := OrderIdList(
'BVURALSOM006', 'FVURALSOM021', 'FVURALSOM002', 'WQ-10034494-0084', '10019377', '1-397254340#1', '1-345353083#1', 'F-10446731-1376'
);

***/

  FOR i IN orders_under_mgmt.FIRST .. orders_under_mgmt.LAST
  LOOP
    BEGIN
      orderNum   := orders_under_mgmt(i);
      errorFound := 0;

      BEGIN
        -- to check if the table exists
        SELECT COUNT(*)
          INTO countRecords
          FROM stcw_wosu4sync;
          
      EXCEPTION
        WHEN others THEN
          -- destination table does not exist
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The destination table STCW_WOSU4SYNC is not available');
          errorFound := 1;
      END;
      
      IF(errorFound = 0) THEN
        BEGIN
          -- to check if the order exists and the orderType = 'F'
          SELECT NVL(orderType, 'NULL'), cwOrderId
            INTO foundOrderType, foundCWOrderId
            FROM stcw_bundleorder_header
           WHERE orderNumber = orderNum;
        
          IF(foundOrderType <> 'F') THEN
            -- orderType different from 'F'
            DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' refers to an order with wrong orderType; expected ''F''; found '''||foundOrderType||'''');
            errorFound := 1;
          END IF;
          
        EXCEPTION
          WHEN no_data_found THEN
            -- order is not in EOC
            DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' is not in EOC');
            errorFound := 1;
        END;
      END IF;
      
      IF(errorFound = 0) THEN
        -- to check if the order is flat
        SELECT count(*)
          INTO countRecords
          FROM stcw_lineItem 
         WHERE cwOrderId = foundCWOrderId
           AND elementTypeInOrderTree <> 'B';
        
        IF(countRecords > 0) THEN
          -- there are lineItems with elementTypeInOrderTree is different from 'B', so not flat
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' refers to a bundle order');
          errorFound := 1;
        END IF;
      END IF;
      
      IF(errorFound = 0) THEN
        -- to check if the order is in 'PROVISIONING'
        SELECT NVL(provisioningFlag, 'NULL'), NVL(provisioningBU, 'X'), NVL(serviceNumber, 'NULL'), lineItemIdentifier, workOrderNumber
          INTO foundProvFlag, foundProvBU, foundServiceNum, foundLIIdentifier, foundWONumber
          FROM stcw_lineItem 
         WHERE cwOrderId = foundCWOrderId
           AND elementTypeInOrderTree = 'B';
        
        IF(foundProvFlag <> 'PROVISIONING') THEN
          -- the lineItem has provisioningFlag different from 'PROVISIONING'
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' has wrong provisioningFlag; expected ''PROVISIONING''; found '''||foundProvFlag||'''');
          errorFound := 1;
        ELSIF(foundProvBU <> 'W') THEN
          -- the lineItem has provisioningBU different from 'W'
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' has wrong provisioningBU; expected ''W''; found '''||foundProvBU||'''');
          errorFound := 1;
        ELSIF(foundServiceNum = 'NULL') THEN
          -- the lineItem has no serviceNumber
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' has no serviceNumber');
          errorFound := 1;
        END IF;
      END IF;
      
      IF(errorFound = 0) THEN
        -- to check if there are processes not completed or terminated
        SELECT count(*)
          INTO countRecords
          FROM cwprocess
         WHERE order_id = foundCWOrderId 
           AND status NOT IN (3, 6);
        
        IF(countRecords > 0) THEN
          -- there are processes linked to the order not completed or terminated so still "running"
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' has processes whose status different from 3 and 6');
          errorFound := 1;
        END IF;
      END IF;
      
      IF(errorFound = 0) THEN
        -- to check if the order is already in STCW_WOSU4SYNC
        SELECT count(*)
          INTO countRecords
          FROM stcw_wosu4sync
         WHERE orderId = orderNum;
        
        IF(countRecords > 0) THEN
          -- the order is already in STCW_WOSU4SYNC
          DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' is already in table STCW_WOSU4SYNC');
          errorFound := 1;
        END IF;
      END IF;
      
      IF(errorFound = 0) THEN
        -- extract WO info from Granite DB
        BEGIN
          SELECT NVL(woi.actual_compl, sysdate), woi.status, wo_comments, NVL(feasibility_status, 'Feasible'), actual_implementation_days, planned_feasible_days, reservation_days
            INTO foundWOActualCompl, foundWOStatus, foundWOComments, foundUDAValue, foundActualImpl, foundPlanFeas, foundReservDays
            FROM work_order_inst@rms_prod_db_link woi, rms_prod.stc_expeditor_wbu_quoteinfo@rms_prod_db_link qi
           WHERE woi.wo_name = foundWONumber
             AND qi.wo_name = woi.wo_name;
        
          IF(foundWOStatus <> 7) THEN
            -- the WO has status different from COMPLETED
            DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' refers to a workOrder '''||foundWONumber||''' whose status is wrong; expected ''7''; found '''||foundWOStatus||'''');
            errorFound := 1;
          END IF;
        EXCEPTION
          WHEN no_data_found THEN
            -- the UDA has no value; defaulting it to 'FEASIBLE'
            DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - The provided orderNumber '''||orderNum||''' refers to a workOrder '''||foundWONumber||''' that does not exist in GI');
            errorFound := 1;
        END;
      END IF;

      IF(errorFound = 0) THEN
        IF(UPPER(foundUDAValue) = 'NOT FEASIBLE') THEN
          UPDATE stcw_lineItem 
             SET lineItemStatus = foundUDAValue, provisioningFlag = 'PROVISIONING', completionDate = NULL,
                 remarks = foundWOComments, reservationDays = foundReservDays
           WHERE cwOrderId = foundCWOrderId AND lineItemIdentifier = foundLIIdentifier AND elementTypeInOrderTree = 'B';
          
          UPDATE stcw_bundleorder_header
             SET orderStatus = 'NOT_FEASIBLE', completionDate = NULL
           WHERE cwOrderId = foundCWOrderId AND orderNumber = orderNum;
          
        ELSE
          -- archiving previous ACTIVE lineItems
          UPDATE stcw_lineItem 
             SET provisioningFlag = 'OLD' 
           WHERE lineItemIdentifier = foundLIIdentifier AND elementTypeInOrderTree = 'B' AND provisioningFlag = 'ACTIVE';
          
          UPDATE stcw_lineItem 
             SET lineItemStatus = foundUDAValue, provisioningFlag = 'ACTIVE', completionDate = foundWOActualCompl,
                 remarks = foundWOComments, reservationDays = foundReservDays
           WHERE cwOrderId = foundCWOrderId AND lineItemIdentifier = foundLIIdentifier AND elementTypeInOrderTree = 'B';
          
          UPDATE stcw_bundleorder_header
             SET orderStatus = 'COMPLETED', completionDate = foundWOActualCompl
           WHERE cwOrderId = foundCWOrderId AND orderNumber = orderNum;
        
        END IF;
        
        -- preparing the XML
        SELECT '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' ||
               '  <soapenv:Body>'||
               '    <comOrderStatusUpdate:receiveOrderStatusUpdate xmlns:comOrderStatusUpdate="orderStatusUpdate" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||
               '      <orderStatusUpdateRequest>'||
               '        <header>'||
               '          <systemId>Granite</systemId>'||
               '          <serverInfo>172.20.214.54</serverInfo>'||
               '          <messageId>'||to_char(systimestamp, 'yyyymmddhh24missFF3')||'</messageId>'||
               '          <conversationId>'||to_char(systimestamp, 'yyyymmddhh24missFF3')||'</conversationId>'||
               '          <timestamp>'||to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.FF3')||'</timestamp>'||
               '          <domainId>Data</domainId>'||
               '          <serviceId>WorkOrderStatusUpdate</serviceId>'||
               '          <operationType>Update</operationType>'||
               '          <userId>URY_WRMS</userId>'||
               '        </header>'||
               '        <body>'||
               '          <orderNo>'||h.orderNumber||'</orderNo>'||
               '          <orderStatus>'||h.orderStatus||'</orderStatus>'||
               '          <businessUnit>Wholesale</businessUnit>'||
               '          <reservationNo>'||l.reservationNumber||'</reservationNo>'||
               '          <reservationDays>'||foundReservDays||'</reservationDays>'||
               '          <feasibilityStatus>'||l.lineItemStatus||'</feasibilityStatus>'||
               '          <actualImplementationDays>'||foundActualImpl||'</actualImplementationDays>'||
               '          <plannedFeasibleDays>'||foundPlanFeas||'</plannedFeasibleDays>'||
               '          <lineItemIdentifier>'||l.lineItemIdentifier||'</lineItemIdentifier>'||
               '          <lineItemStatus>'||l.lineItemStatus||'</lineItemStatus>'||
               '          <assetNo>'||l.serviceNumber||'</assetNo>'||
               '          <workOrderName>'||l.workOrderNumber||'</workOrderName>'||
               '          <workOrderStatus>COMPLETED</workOrderStatus>'||
               '          <workOrderRemarks>'||l.remarks||'</workOrderRemarks>'||
               '          <taskServiceStatus>'||foundUDAValue||'</taskServiceStatus>'||
               '        </body>'||
               '      </orderStatusUpdateRequest>'||
               '    </comOrderStatusUpdate:receiveOrderStatusUpdate>'||
               '  </soapenv:Body>'||
               '</soapenv:Envelope>'
          INTO wosuMsgXML
          FROM stcw_bundleorder_header h, stcw_lineitem l
         WHERE l.cworderid = h.cworderid
           AND h.orderNumber = orderNum;
 
        INSERT INTO stcw_wosu4sync(orderid, wosumsg, dumped) VALUES(orderNum, wosuMsgXML, 0);
        
        DBMS_OUTPUT.PUT_LINE('[OK] '||orderNum);
      END IF;
      
    EXCEPTION
      WHEN others THEN
        errorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] '||orderNum||' - Unexpected exception while processing the order '''||orderNum||'''; error Msg = '||errorMsg);
    END;
  END LOOP;
END;

/