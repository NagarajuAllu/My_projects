CREATE OR REPLACE PROCEDURE delete_stc_bundle_order (inputOrderNumber IN VARCHAR2, errorMsg OUT VARCHAR2) AS

  orderId                  stc_bundleorder_header.cworderid%TYPE;
  provisioningFlag         stc_lineitem.provisioningflag%TYPE;
  parentLineItemId         stc_lineitem.lineitemidentifier%TYPE;
  count_processes          NUMBER(2);
  count_instances_parentLI NUMBER(2);
  count_wo_in_granite      NUMBER(2);

  CURSOR c_workorders(orderID IN VARCHAR2) IS
    SELECT DISTINCT workOrderNumber, lineItemIdentifier 
      FROM stc_lineItem
     WHERE cwOrderId = orderID
       AND workOrderNumber IS NOT NULL;

BEGIN

  BEGIN
    SELECT cwOrderId
      INTO orderId
      FROM stc_bundleorder_header
     WHERE orderNumber = inputOrderNumber;
  EXCEPTION
    WHEN no_data_found THEN
      errorMsg := '[ERR] Unable to find any entry in STC_BUNDLEORDER_HEADER with orderNumber = '''||inputOrderNumber||'''';
      RETURN;
  END;

  SELECT COUNT(*)
    INTO count_processes
    FROM cwprocess
   WHERE status NOT IN (3, 6)
     AND order_id = orderId;

  IF(count_processes > 0) THEN
    errorMsg := '[ERR] Found '|| count_processes ||' processes not completed or terminated linked to the order = '''||inputOrderNumber||'''';
    RETURN;
  END IF;


  SELECT provisioningFlag, lineItemIdentifier
    INTO provisioningFlag, parentLineItemId
    FROM stc_lineitem
   WHERE cwOrderId = orderId
     AND provisioningFlag IS NOT NULL;

  IF(provisioningFlag = 'ACTIVE') THEN
    SELECT count(*)
      INTO count_instances_parentLI
      FROM stc_lineitem
     WHERE lineItemIdentifier = parentLineItemId
       AND provisioningFlag = 'OLD';

    IF(count_instances_parentLI > 1) THEN
      errorMsg := '[ERR] The provisioningFlag of the parentLineItem of the order = '''||inputOrderNumber||''' is ACTIVE and there are '||
                  count_instances_parentLI||' ''OLD'' instances of the parentLineItem';
      RETURN;
    END IF;
  END IF;

  FOR wo IN c_workorders(orderId) LOOP
    BEGIN
      SELECT count(*)
        INTO count_wo_in_granite
        FROM work_order_inst@rms_prod_db_link
       WHERE wo_name = wo.workordernumber;
      
      IF(count_wo_in_granite > 0) THEN
        errorMsg := '[ERR] The WO '''||wo.workordernumber||''' for lineItem '''||wo.lineitemidentifier||''' for order = '''||inputOrderNumber||
                    ''' is in Granite and so the order cannot be deleted';
        RETURN;
      END IF;
    
    END;
  END LOOP;

  -- BLOCK_VALUE
  INSERT INTO stc_del_block_value SELECT * FROM stc_block_value WHERE cwOrderId = orderId;
  DELETE FROM stc_block_value WHERE cwOrderId = orderId;

  -- BLOCK_NAME_VALUE
  INSERT INTO stc_del_block_name_value SELECT * FROM stc_block_name_value WHERE cwOrderId = orderId;
  DELETE FROM stc_block_name_value WHERE cwOrderId = orderId;

  -- NAME_VALUE
  INSERT INTO stc_del_name_value SELECT * FROM stc_name_value WHERE cwOrderId = orderId;
  DELETE FROM stc_name_value WHERE cwOrderId = orderId;

  -- LINEITEM
  INSERT INTO stc_del_lineitem SELECT * FROM stc_lineitem WHERE cwOrderId = orderId;
  DELETE FROM stc_lineitem WHERE cwOrderId = orderId;

  -- ORDER_ORCHESTRATION
  INSERT INTO stc_del_order_orchestration SELECT * FROM stc_order_orchestration WHERE cwOrderId = orderId;
  DELETE FROM stc_order_orchestration WHERE cwOrderId = orderId;

  -- REASON_CODE
  INSERT INTO stc_del_reason_code SELECT * FROM stc_reason_code WHERE cwOrderId = orderId;
  DELETE FROM stc_reason_code WHERE cwOrderId = orderId;

  -- ORDERITEMS
  INSERT INTO del_cworderitems SELECT * FROM cworderitems WHERE topOrderId = orderId;
  DELETE FROM cworderitems WHERE topOrderId = orderId;

  -- ORDERINSTANCE
  INSERT INTO del_cworderinstance SELECT * FROM cworderinstance WHERE cwDocId = orderId;
  DELETE FROM cworderinstance WHERE cwDocId = orderId;

  -- BUNDLEORDER_HEADER
  INSERT INTO stc_del_bundleorder_header SELECT * FROM stc_bundleorder_header WHERE cwOrderId = orderId;
  DELETE FROM stc_bundleorder_header WHERE cwOrderId = orderId;

END;
/
