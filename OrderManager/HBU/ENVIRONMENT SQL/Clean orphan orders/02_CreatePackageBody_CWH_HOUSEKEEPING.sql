CREATE OR REPLACE PACKAGE BODY CWH_HOUSEKEEPING IS

  /**
   * To log the input message on std output or on a table.
   */
  PROCEDURE log(msg IN VARCHAR2) IS
  BEGIN
    IF(debug_on_std_out = 'Y') THEN
      DBMS_OUTPUT.PUT_LINE(msg);
    END IF;

    INSERT INTO LOG_HOUSEKEEPING VALUES(sysdate, msg);
  END;

  /**
   * To debug the input message on std output or on a table.
   * Only if debug_log variable = 'Y' then it appens the log, otherwise it does nothing.
   */
  PROCEDURE debug(msg IN VARCHAR2) IS
  BEGIN
    IF(debug_log = 'Y') THEN
      log(msg);
    END IF;
  END;
  
  /**
   * To delete the entire structure of the order whose id is given.
   */
  PROCEDURE deleteSTC_ORDER_HOME(order_instance_id IN VARCHAR2) IS

    count_record NUMBER;

  BEGIN
    SELECT COUNT(1) INTO count_record FROM stc_order_message_home WHERE cworderid = order_instance_id;
    IF(count_record > 0) THEN
      DELETE FROM stc_order_message_home WHERE cworderid = order_instance_id;
--      debug('  [DEBUG] Deleted order_header for order '||order_instance_id);
    END IF;

    SELECT COUNT(1) INTO count_record FROM stc_service_parameters_home WHERE cworderid = order_instance_id;
    IF(count_record > 0) THEN
      DELETE FROM stc_service_parameters_home WHERE cworderid = order_instance_id;
--      debug('  [DEBUG] Deleted service_parameters for order '||order_instance_id);
    END IF;

    SELECT COUNT(1) INTO count_record FROM stc_name_value WHERE cworderid = order_instance_id;
    IF(count_record > 0) THEN
      DELETE FROM stc_name_value WHERE cworderid = order_instance_id;
--      debug('  [DEBUG] Deleted nv_pairs for order '||order_instance_id);
    END IF;

    SELECT COUNT(1) INTO count_record FROM stc_order_ack WHERE cworderid = order_instance_id;
    IF(count_record > 0) THEN
      DELETE FROM stc_order_ack WHERE cworderid = order_instance_id;
--      debug('  [DEBUG] Deleted order_ack for order '||order_instance_id);
    END IF;

    SELECT COUNT(1) INTO count_record FROM cworderinstance WHERE cwdocid = order_instance_id;
    IF(count_record > 0) THEN
      DELETE FROM cworderinstance WHERE cwdocid = order_instance_id;
--      debug('  [DEBUG] Deleted cworderinstance for order '||order_instance_id);
    END IF;

  END;


  /**
   * To fill cwh_orderitems_hk table.
   */
  PROCEDURE fillCWH_OrderItems_HK_Table(finish_ok OUT VARCHAR2) IS
  BEGIN

    log('[fillCWH_OrderItems_HK_Table] Start');

    INSERT INTO cwh_orderitems_hk (order_id, processed) 
      SELECT i.cwdocid, null processed
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME'
         AND i.cwdocid not in (
             SELECT c.cworderid
               FROM stc_order_message_home c
              WHERE c.cworderid = i.cwdocid);

    log('[fillCWH_OrderItems_HK_Table] Completed; result is: Y');

    finish_ok := 'Y';
  END;


  /**
   * To remove all records in CWORDERINSTANCE whose id is not in STC_ORDER_MESSAGE_HOME.
   * Order Header (so, record in STC_ORDER_MESSAGE_HOME) is the only mandatory item in the definition of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanOrdersWithoutHeader(num_limit_for_commit IN NUMBER, finish_ok OUT VARCHAR2) IS

    CURSOR c_cworderinstance IS
      SELECT order_id
        FROM cwh_orderitems_hk
       WHERE processed IS NULL;

    process_ok CHAR(1) := 'Y';
    processed  NUMBER  := 0;

  BEGIN

    log('[cleanOrdersWithoutHeader] Start');

    FOR c IN c_cworderinstance LOOP
      BEGIN

        IF(process_ok = 'Y') THEN

          BEGIN
            deleteSTC_ORDER_HOME(c.order_id);
            update cwh_orderitems_hk
               set processed = 'Y'
             where order_id = c.order_id;
            processed := processed + 1;
          END;
          
          IF(MOD(processed, num_limit_for_commit) = 0) THEN
            debug('[cleanOrdersWithoutHeader] Processed other '||num_limit_for_commit);
            COMMIT;
          END IF;

        END IF;

      EXCEPTION
        WHEN others THEN
          log('[cleanOrdersWithoutHeader] Error in processing cworderinstance '''||c.order_id ||': '||SUBSTR(sqlerrm, 1, 1000));
          process_ok := 'N';
      END;
    END LOOP;


    log('[cleanOrdersWithoutHeader] Completed; result is: '||process_ok);
    IF(process_ok = 'Y') THEN
      debug('[cleanOrdersWithoutHeader] processed '||processed||' orders');
    END IF;

    finish_ok     := process_ok;
  END;


  /**
   * To remove all records in STC_ORDER_MESSAGE_HOME whose records are not in CWORDERINSTANCE.
   * Order Header (so, record in STC_ORDER_MESSAGE_HOME) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanHeaderOrdersWithoutOrder(finish_ok OUT VARCHAR2) IS

    CURSOR c_orderHeader IS
      SELECT c.cworderid
        FROM stc_order_message_home c
      MINUS
      SELECT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME';

    process_ok CHAR(1) := 'Y';
    processed  NUMBER  := 0;

  BEGIN
    
    log('[cleanHeaderOrdersWithoutOrder] Start');

    FOR c IN c_orderHeader LOOP
      BEGIN

        IF(process_ok = 'Y') THEN

          BEGIN
            deleteSTC_ORDER_HOME(c.cworderid);
            processed := processed + 1;
          END;

        END IF;

      EXCEPTION
        WHEN others THEN
          log('[cleanHeaderOrdersWithoutOrder] Error in processing cworderinstance '''||c.cworderid ||': '||SUBSTR(sqlerrm, 1, 1000));
          process_ok := 'N';
      END;
    END LOOP;


    log('[cleanHeaderOrdersWithoutOrder] Completed; result is: '||process_ok);
    IF(process_ok = 'Y') THEN
      debug('[cleanHeaderOrdersWithoutOrder] processed '||processed||' orders');
    END IF;

    finish_ok := process_ok;

  END;


  /**
   * To remove all records in STC_SERVICE_PARAMETERS_HOME whose records are not in CWORDERINSTANCE.
   * Services (so, record in STC_SERVICE_PARAMETERS_HOME) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanServiceParamsWithoutOrder(finish_ok OUT VARCHAR2) IS

    CURSOR c_serviceParameters IS
      SELECT c.cworderid
        FROM stc_service_parameters_home c
      MINUS
      SELECT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME';

    process_ok CHAR(1) := 'Y';
    processed  NUMBER  := 0;

  BEGIN

    log('[cleanServiceParamsWithoutOrder] Start');

    FOR c IN c_serviceParameters LOOP
      BEGIN

        IF(process_ok = 'Y') THEN

          BEGIN
            deleteSTC_ORDER_HOME(c.cworderid);
            processed := processed + 1;
          END;

        END IF;

      EXCEPTION
        WHEN others THEN
          log('[cleanServiceParamsWithoutOrder] Error in processing cworderinstance '''||c.cworderid ||': '||SUBSTR(sqlerrm, 1, 1000));
          process_ok := 'N';
      END;
    END LOOP;


    log('[cleanServiceParamsWithoutOrder] Completed; result is: '||process_ok);
    IF(process_ok = 'Y') THEN
      debug('[cleanServiceParamsWithoutOrder] processed '||processed||' orders');
    END IF;

    finish_ok := process_ok;

  END;


  /**
   * To remove all records in STC_NAME_VALUE whose records are not in CWORDERINSTANCE.
   * NV Pair (so, record in STC_NAME_VALUE) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanNVPairWithoutOrder(finish_ok OUT VARCHAR2) IS

    CURSOR c_nvPairs IS
      SELECT c.cworderid
        FROM stc_name_value c
      MINUS
      SELECT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename in ('ds_ws:default_orderSTC_HOME', 'ds_ws:default_orderSTC');

    process_ok CHAR(1) := 'Y';
    processed  NUMBER  := 0;

  BEGIN

    log('[cleanNVPairWithoutOrder] Start');

    FOR c IN c_nvPairs LOOP
      BEGIN

        IF(process_ok = 'Y') THEN

          BEGIN
            deleteSTC_ORDER_HOME(c.cworderid);
            processed := processed + 1;
          END;

        END IF;

      EXCEPTION
        WHEN others THEN
          log('[cleanNVPairWithoutOrder] Error in processing cworderinstance '''||c.cworderid ||': '||SUBSTR(sqlerrm, 1, 1000));
          process_ok := 'N';
      END;
    END LOOP;


    log('[cleanNVPairWithoutOrder] Completed; result is: '||process_ok);
    IF(process_ok = 'Y') THEN
      debug('[cleanNVPairWithoutOrder] processed '||processed||' orders');
    END IF;

    finish_ok := process_ok;

  END;


  /**
   * To remove all records in STC_ORDER_ACK whose records are not in CWORDERINSTANCE.
   * Order Ack (so, record in STC_ORDER_ACK) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanOrderAckWithoutOrder(finish_ok OUT VARCHAR2) IS

    CURSOR c_orderAck IS
      SELECT c.cworderid
        FROM stc_order_ack c
      MINUS
      SELECT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME';

    process_ok CHAR(1) := 'Y';
    processed  NUMBER  := 0;

  BEGIN

    log('[cleanOrderAckWithoutOrder] Start');

    FOR c IN c_orderAck LOOP
      BEGIN

        IF(process_ok = 'Y') THEN

          BEGIN
            deleteSTC_ORDER_HOME(c.cworderid);
            processed := processed + 1;
          END;

        END IF;

      EXCEPTION
        WHEN others THEN
          log('[cleanOrderAckWithoutOrder] Error in processing cworderinstance '''||c.cworderid ||': '||SUBSTR(sqlerrm, 1, 1000));
          process_ok := 'N';
      END;
    END LOOP;


    log('[cleanOrderAckWithoutOrder] Completed; result is: '||process_ok);
    IF(process_ok = 'Y') THEN
      debug('[cleanOrderAckWithoutOrder] processed '||processed||' orders');
    END IF;

    finish_ok := process_ok;

  END;



  /**
   * To perform all the procedures to clean up CWH DB.
   */
  PROCEDURE performCleanUp IS

    finish_ok     VARCHAR2(100) := 'Y';

  BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
    
    log('[performCleanUp] Start');

    fillCWH_OrderItems_HK_Table(finish_ok);
    COMMIT;

    IF(finish_ok <> 'Y') THEN
      log('Error in executing procedure ''fillCWH_OrderItems_HK_Table''; please ROLLBACK');
    ELSE
      COMMIT;
    END IF;

    IF(finish_ok = 'Y') THEN
      cleanOrdersWithoutHeader(1000, finish_ok);

      IF(finish_ok <> 'Y') THEN
        log('Error in executing procedure ''cleanOrdersWithoutHeader''; please ROLLBACK');
      ELSE
        COMMIT;
      END IF;
    END IF;
    
    IF(finish_ok = 'Y') THEN
      cleanHeaderOrdersWithoutOrder(finish_ok);

      IF(finish_ok <> 'Y') THEN
        log('Error in executing procedure ''cleanServiceParamsWithoutOrder''; please ROLLBACK');
      ELSE
        COMMIT;
      END IF;
    END IF;

    IF(finish_ok = 'Y') THEN
      cleanServiceParamsWithoutOrder(finish_ok);

      IF(finish_ok <> 'Y') THEN
        log('Error in executing procedure ''cleanServiceParamsWithoutOrder''; please ROLLBACK');
      ELSE
        COMMIT;
      END IF;
    END IF;

    IF(finish_ok = 'Y') THEN
      cleanNVPairWithoutOrder(finish_ok);

      IF(finish_ok <> 'Y') THEN
        log('Error in executing procedure ''cleanNVPairWithoutOrder''; please ROLLBACK');
      ELSE
        COMMIT;
      END IF;
    END IF;

    IF(finish_ok = 'Y') THEN
      cleanOrderAckWithoutOrder(finish_ok);

      IF(finish_ok <> 'Y') THEN
        log('Error in executing procedure ''cleanOrderAckWithoutOrder''; please ROLLBACK');
      ELSE
        log('[performCleanUp] Completed; result is: '||finish_ok);
        COMMIT;
      END IF;
    END IF;

  END;


END CWH_HOUSEKEEPING;
