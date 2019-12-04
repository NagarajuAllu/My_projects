CREATE OR REPLACE PACKAGE BODY DELETE_PARENT_ORDER_STRUCTURE IS

  /**
   * To delete a parent order whose orderNumber is provided.
   * No backup is implemented.
   */
  PROCEDURE deleteParentAndChildOrders(parent_order_number IN VARCHAR2) IS
  BEGIN
    delWithBCKParentAndChildOrders(parent_order_number, 'N');
  END deleteParentAndChildOrders;

  /**
   * To delete a parent order whose orderNumber is provided.
   * Backup occurs according to parameter "backup".
   */
  PROCEDURE delWithBCKParentAndChildOrders(parent_order_number IN VARCHAR2, backup IN VARCHAR) IS

    CURSOR c_childOrders IS
      SELECT ordernumber
        FROM stc_order_message_home
       WHERE parentordernumber = parent_order_number;

    isPossibleDeleteOrder CHAR(1);
    count_parent_order    NUMBER;
    error_code            NUMBER;
    error_msg             VARCHAR2(100);

  BEGIN

    DBMS_OUTPUT.ENABLE(NULL);

    INSERT INTO stc_del_parentorder_struct_log (log_number, when_occurred, parent_order_number, msg) 
        VALUES (stc_del_parentorder_struct_seq.NEXTVAL, SYSDATE, parent_order_number, 'Starting to delete parent order with backup = '||backup);
    
    SELECT COUNT(1)
      INTO count_parent_order
      FROM stc_order_message_home
     WHERE ordernumber = parent_order_number;

    IF(count_parent_order <> 1) THEN
      RAISE_APPLICATION_ERROR(-20100, 'ORDER: '||parent_order_number||' - PARENT ORDER INSTANCES IN WD '||count_parent_order);
    END IF;

    -- check if it's possible to delete parent order according to the status of the WOs in Granite
    isPossibleDeleteOrder := validateCancelParentOrder(parent_order_number);

    IF (isPossibleDeleteOrder = 'Y') THEN
      FOR childOrder IN c_childOrders LOOP
        BEGIN
          -- check if it's possible to delete child order according to the status of the WO in Granite
          isPossibleDeleteOrder := validateCancelChildOrder(childOrder.ordernumber);

          IF (isPossibleDeleteOrder <> 'Y') THEN
            RAISE_APPLICATION_ERROR(-20102, 'ORDER: '||childOrder.ordernumber||' - IMPOSSIBLE DELETE BECAUSE VALIDATION FAILED');
          END IF;
        END;
      END LOOP;

    ELSE
      RAISE_APPLICATION_ERROR(-20101, 'ORDER: '||parent_order_number||' - IMPOSSIBLE DELETE BECAUSE VALIDATION FAILED');
    END IF;

    DBMS_OUTPUT.PUT_LINE(parent_order_number||': It''s possible to delete order and all its child');

    INSERT INTO stc_del_parentorder_struct_log (log_number, when_occurred, parent_order_number, msg) 
        VALUES (stc_del_parentorder_struct_seq.NEXTVAL, SYSDATE, parent_order_number, 'It''s possible to delete order and all its child');

    FOR childOrder IN c_childOrders LOOP
      deleteOrderStructureFromWD (childOrder.ordernumber, backup);
      DBMS_OUTPUT.PUT_LINE(parent_order_number||': deleted child order '||childOrder.ordernumber);

      INSERT INTO stc_del_parentorder_struct_log (log_number, when_occurred, parent_order_number, msg) 
          VALUES (stc_del_parentorder_struct_seq.NEXTVAL, SYSDATE, parent_order_number, 'Deleted child order '||childOrder.ordernumber);
    END LOOP;

    deleteOrderStructureFromWD (parent_order_number, backup);
    DBMS_OUTPUT.PUT_LINE(parent_order_number||': deleted parent order ');
      INSERT INTO stc_del_parentorder_struct_log (log_number, when_occurred, parent_order_number, msg) 
          VALUES (stc_del_parentorder_struct_seq.NEXTVAL, SYSDATE, parent_order_number, 'Deleted parent order');

    DBMS_OUTPUT.PUT_LINE(parent_order_number||': delete completed');
      INSERT INTO stc_del_parentorder_struct_log (log_number, when_occurred, parent_order_number, msg) 
          VALUES (stc_del_parentorder_struct_seq.NEXTVAL, SYSDATE, parent_order_number, 'Deleted completed');

  EXCEPTION
    WHEN others THEN
      error_code := SQLCODE;
      error_msg  := SUBSTR(SQLERRM, 1 , 100);

      DBMS_OUTPUT.PUT_LINE(parent_order_number||': caught exception <'||error_code||','||error_msg||'>');

      RAISE_APPLICATION_ERROR(error_code, SQLERRM);

  END delWithBCKParentAndChildOrders;


  /**
   * To check if the parent order can be deleted or not, according to the status of the WOs in Granite.
   */
  FUNCTION validateCancelParentOrder(parent_order_number IN VARCHAR2) return CHAR IS

    result CHAR(1) := 'N';

    count_not_valid_wo NUMBER;

  BEGIN
    -- search all the work orders whose UDA 'Parent Order Number' is equals to the parent order provided
    SELECT COUNT(1)
      INTO count_not_valid_wo
      FROM rms_prod.work_order_inst woi, rms_prod.workorder_attr_settings was, rms_prod.val_attr_name van
     WHERE woi.wo_inst_id = was.workorder_inst_id
       AND was.val_attr_inst_id = van.val_attr_inst_id
       AND van.group_name = 'Work Order Info'
       AND van.attr_name = 'Parent Order Number'
       AND woi.status NOT IN (7, 8)
       AND was.attr_value = parent_order_number;

    IF (count_not_valid_wo = 0) THEN
      result := 'Y';
    ELSE
      RAISE_APPLICATION_ERROR(-20103, 'ORDER: '||parent_order_number||' - FOUND '|| count_not_valid_wo ||' WORK_ORDERS WITH INVALID STATUS');
    END IF;

    RETURN result;
  END validateCancelParentOrder;


  /**
   * To check if a child order can be deleted or not, according to the status of the WO in Granite.
   */
  FUNCTION validateCancelChildOrder(order_number IN VARCHAR2) return CHAR IS

    result CHAR(1) := 'N';

    work_order_status  rms_prod.work_order_inst.status%TYPE;
    status_name        rms_prod.val_task_status.status_name%TYPE;


  BEGIN
    BEGIN
      SELECT status, (SELECT status_name FROM rms_prod.val_task_status WHERE stat_code = status) status_name
        INTO work_order_status, status_name
        FROM rms_prod.work_order_inst
       WHERE wo_name = order_number;

      IF (work_order_status IN (7, 8)) THEN
        result := 'Y';
      ELSE
        RAISE_APPLICATION_ERROR(-20104, 'ORDER: '||order_number||' - FOUND INVALID WORKORDER STATUS: '||status_name);
      END IF;

    EXCEPTION
      WHEN no_data_found THEN
      result := 'Y';

    END;
    RETURN result;
  END validateCancelChildOrder;


  PROCEDURE deleteOrderStructureFromWD(order_number IN VARCHAR2, backup IN VARCHAR2) IS
    cw_order_id   cworderinstance.cwdocid%TYPE;
  BEGIN

    SELECT cworderid
      INTO cw_order_id
      FROM stc_order_message_home
     WHERE ordernumber = order_number;

    IF( backup = 'Y') THEN
      archiveOrder(cw_order_id);
    END IF;

    DELETE FROM cworderinstance WHERE cwdocid = cw_order_id;
    DELETE FROM stc_order_ack WHERE cworderid = cw_order_id;
    DELETE FROM stc_name_value WHERE cworderid = cw_order_id;
    DELETE FROM stc_service_parameters_home WHERE cworderid = cw_order_id;
    DELETE FROM stc_order_message_home WHERE cworderid = cw_order_id;

  END deleteOrderStructureFromWD;


  /**
   * To backup an order, creating a copy into _archive tables.
   */
  PROCEDURE archiveOrder(cw_order_id IN VARCHAR2) IS
    fun_order_ack stc_order_ack.functionname%TYPE;
    count_record  NUMBER(5);
  BEGIN
    SELECT COUNT(*)
      INTO count_record
      FROM stc_order_ack
     WHERE cworderid = cw_order_id;

    IF(count_record > 0) THEN
      SELECT functionname
        INTO fun_order_ack
        FROM stc_order_ack
       WHERE cworderid = cw_order_id;

      INSERT INTO stc_order_ack_archive (errorcode, errordescription, errortime, errortype, functionname, objectid, processinstanceld, sourceerrorcode, status, systemname, targetrecored, userid, remarks, ordernumber, xngordernumber, businessunit, cwdocstamp, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, cwdocid, when_archived)
           SELECT errorcode, errordescription, errortime, errortype, substr(fun_order_ack, 1, 2000), objectid, processinstanceld, sourceerrorcode, status, systemname, targetrecored, userid, remarks, ordernumber, xngordernumber, businessunit, cwdocstamp, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, cwdocid, sysdate
             FROM stc_order_ack
            WHERE cworderid = cw_order_id;
    END IF;

    INSERT INTO stc_name_value_archive (name, value, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, when_archived)
         SELECT name, value, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, sysdate
           FROM stc_name_value
          WHERE cworderid = cw_order_id;

    INSERT INTO stc_serv_params_home_archive (creationdate, servicenumber, oldservicenumber, servicedate, servicedescription, servicetype, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, servicestatus, plateid, oldplateid, unitnumber, oldunitnumber, orderrowitemid, tobeprocessed, tobecancelled, when_archived)
         SELECT creationdate, servicenumber, oldservicenumber, servicedate, servicedescription, servicetype, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, servicestatus, plateid, oldplateid, unitnumber, oldunitnumber, orderrowitemid, tobeprocessed, tobecancelled, sysdate
           FROM stc_service_parameters_home
          WHERE cworderid = cw_order_id;

    INSERT INTO stc_order_message_home_archive (accountnumber, alternativesolution, bandwidth, ccttype, circuitnumber, createdby, creationdate, customeridnumber, fictbillingnumber, icmssonumber, oldcircuitnumber, ordernumber, orderstatus, ordertype, priority, projectid, referencetelnumber, remarks, servicedate, servicedescription, servicetype, wires, customername, customertype, customercontact, tbportnumber, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, internalorderstatus, circuitstatus, businessunit, customeridtype, customernumber, inhold, commonplateid, parentordernumber, commonservicenumber, reservationnumber, reservationexpiry, completion_date, orderdomain, dialogsizey, dialogsizex, tobesending, actiononorder, already_cancelled, when_archived)
         SELECT accountnumber, alternativesolution, bandwidth, ccttype, circuitnumber, createdby, creationdate, customeridnumber, fictbillingnumber, icmssonumber, oldcircuitnumber, ordernumber, orderstatus, ordertype, priority, projectid, referencetelnumber, remarks, servicedate, servicedescription, servicetype, wires, customername, customertype, customercontact, tbportnumber, cwdocstamp, cwdocid, lastupdateddate, cwordercreationdate, cworderid, cwparentid, updatedby, internalorderstatus, circuitstatus, businessunit, customeridtype, customernumber, inhold, commonplateid, parentordernumber, commonservicenumber, reservationnumber, reservationexpiry, completion_date, orderdomain, dialogsizey, dialogsizex, tobesending, actiononorder, already_cancelled, sysdate
           FROM stc_order_message_home
          WHERE cworderid = cw_order_id;

  END archiveOrder;

END DELETE_PARENT_ORDER_STRUCTURE;
/