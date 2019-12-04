CREATE OR REPLACE PROCEDURE FIX_COMPLETED_WO_IN_EOC(lineItemId IN VARCHAR2, woNumber IN VARCHAR2)
AS
  docId             stc_lineitem.cwDocId%TYPE;
  orderId           stc_lineitem.cworderId%TYPE;
  woNum             stc_lineitem.workOrderNumber%TYPE;
  lineItemFinStatus stc_lineitem.lineItemStatus%TYPE;
  lineIteComplDate  stc_lineitem.completionDate%TYPE;
  orderNumber       stc_bundleorder_header.ordernumber%TYPE;
  cnt               NUMBER;
  error_msg         VARCHAR2(1000);
  wo_g_status       CHAR(1 BYTE);
  proc_status       cwprocess.status%TYPE;

BEGIN
  -- Verify if lineitem in stc_lineitem table
  BEGIN

    BEGIN
      SELECT cworderid, workordernumber, cwdocid
        INTO orderId, woNum, docId
        FROM stc_lineitem
       WHERE lineitemidentifier = lineItemId
         AND provisioningflag = 'PROVISIONING';
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          SELECT cworderid, workordernumber, cwdocid
            INTO orderId, woNum, docId
            FROM stc_lineitem
           WHERE lineitemidentifier = lineItemId
             AND provisioningflag = 'ACTIVE';

          RAISE_APPLICATION_ERROR(-20024, 'The lineItem with Id '||lineItemId||' is already ACTIVE with WO '||woNum);
        END;
    END;

    --Check work order number is not null
    IF( wonum IS NULL OR wonum = '') THEN
      RAISE_APPLICATION_ERROR(-20012, 'NO WO Number linked to lineItemIdentifier: '||lineItemId||' in order '||woNum);
    END IF;

    --Check work order number is the same as in input
    IF( wonum <> woNumber ) THEN
      RAISE_APPLICATION_ERROR(-20010, 'WO Number '||woNum||' linked to lineItemIdentifier '||lineItemId||' is different from input WO Number '||woNumber);
    END IF;


  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20013, 'There is no any order under management in PROVISIONING status with the provided lineItemIdentifier: '||lineItemId);
  END;


  -- Identify if lineitem is part of legacy order
  SELECT count(*)
    INTO cnt
    FROM stc_lineitem
   WHERE cworderid = orderId;

  IF(cnt > 1) THEN
    RAISE_APPLICATION_ERROR(-20015, 'The LineItem is part of a BundleOrder; Please check with ADM team');
  END IF;

  -- Check for Revised or Cancelled
  BEGIN
    SELECT ordernumber
      INTO orderNumber
      FROM stc_bundleorder_header
     WHERE cworderid = orderId;

    IF(orderNumber LIKE '%_REVI_%' OR orderNumber LIKE '%_CANC_%') THEN
      RAISE_APPLICATION_ERROR(-20016, 'Order already Revised or Cancelled; Please check with ADM team');
    END IF;

  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20014, 'Malformed Order; Unable to find OrderHeader for the provided lineItemIdentifier: '||lineItemId);
  END;


  -- Check Work Order Status in Granite
  BEGIN
    SELECT status, NVL(actual_compl, SYSDATE)
      INTO wo_g_status, lineIteComplDate
      FROM work_order_inst@rms_prod_db_link
     WHERE wo_name = woNum;

    IF(wo_g_status <> 7 AND wo_g_status <> 8) THEN
      RAISE_APPLICATION_ERROR(-20011, 'WO '||woNum||' linked to lineItemIdentifier '||lineItemId||' IN ORDER '||orderNumber||' is not yet COMPLETED or CANCELLED!');
    END IF;

  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20017, 'Cannot find WO '||woNum||' in Granite');
  END;

  -- Get Provisioning Process Id and Status
  BEGIN
    SELECT p.status
      INTO proc_status
      FROM stc_order_orchestration o, cwprocess p
     WHERE o.lineitemidentifier = lineItemId
       AND o.cwdocid = docId
       AND o.cworderid = orderId
       AND o.provisioningprocessid = p.process_id;

    IF(proc_status = 1) THEN
      RAISE_APPLICATION_ERROR(-20018, 'The process is still running so the synchronization is performed by the global process');
    ELSIF(proc_status = 2) THEN
      RAISE_APPLICATION_ERROR(-20019, 'The process is SUSPENDED, check with ADM team');
    ELSIF(proc_status = 4) THEN
      RAISE_APPLICATION_ERROR(-20020, 'The process is ABORTED, check with ADM team');
    ELSIF(proc_status = 5) THEN
      RAISE_APPLICATION_ERROR(-20021, 'The process is in ERROR, check with ADM team');
    ELSIF(proc_status = 8) THEN
      RAISE_APPLICATION_ERROR(-20022, 'The process is in STALE, check with ADM team');
    END IF;

  EXCEPTION
    WHEN no_data_found THEN
      NULL; -- it means that the process doesn't exist!
  END;

  -- Update LineItem to COMPLETED or CANCELLED status
  BEGIN
    lineItemFinStatus := 'COMPLETED';
    IF (wo_g_status <> 7) THEN
      lineItemFinStatus := 'CANCELLED';
    END IF;

    UPDATE stc_lineitem
       SET lineItemStatus = lineItemFinStatus,
           completiondate = lineIteComplDate
     WHERE lineitemidentifier = lineItemId
       AND cworderid = orderId
       AND cwdocid = docId;

    -- Archive previous ACTIVE record
    UPDATE stc_lineitem
       SET provisioningflag='OLD'
     WHERE provisioningflag='ACTIVE'
       AND lineitemidentifier = lineItemId;

    --Activate current record
    UPDATE stc_lineitem
       SET provisioningflag='ACTIVE'
     WHERE provisioningflag='PROVISIONING'
       AND lineitemidentifier = lineItemId
       AND cworderid = orderId
       AND cwdocid = docId;


    -- Update Order Header
    UPDATE stc_bundleorder_header
       SET orderstatus = lineItemFinStatus,
           completiondate = lineIteComplDate,
           isMigrated = DECODE(isMigrated, 0, 0, 1, 1, 1)
     WHERE cworderid = orderId;

  EXCEPTION
    WHEN others THEN
      error_msg := SUBSTR(SQLERRM, 1, 1000);
      RAISE_APPLICATION_ERROR(-20023, 'Unexpected error while updating the order: '||error_msg);
  END;
END;
/