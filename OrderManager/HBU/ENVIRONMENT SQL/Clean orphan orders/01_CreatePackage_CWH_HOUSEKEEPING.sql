CREATE OR REPLACE PACKAGE CWH_HOUSEKEEPING IS


  debug_log        VARCHAR2(1) := 'Y';
  debug_on_std_out VARCHAR2(1) := 'N';

  /**
   * To log the input message on std output or on a table.
   */
  PROCEDURE log(msg IN VARCHAR2);

  /**
   * To debug the input message on std output or on a table.
   * Only if debug_log variable = 'Y' then it appens the log, otherwise it does nothing.
   */
  PROCEDURE debug(msg IN VARCHAR2);

  /**
   * To delete the entire structure of the order whose id is given.
   */
  PROCEDURE deleteSTC_ORDER_HOME(order_instance_id IN VARCHAR2);


  /**
   * To fill cwh_orderitems_hk table.
   */
  PROCEDURE fillCWH_OrderItems_HK_Table(finish_ok OUT VARCHAR2);

  /**
   * To remove all records in CWORDERINSTANCE whose id is not in STC_ORDER_MESSAGE_HOME.
   * Order Header (so, record in STC_ORDER_MESSAGE_HOME) is the only mandatory item in the definition of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanOrdersWithoutHeader(num_limit_for_commit IN NUMBER, finish_ok OUT VARCHAR2);


  /**
   * To remove all records in STC_ORDER_MESSAGE_HOME whose records are not in CWORDERINSTANCE.
   * Order Header (so, record in STC_ORDER_MESSAGE_HOME) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanHeaderOrdersWithoutOrder(finish_ok OUT VARCHAR2);


  /**
   * To remove all records in STC_SERVICE_PARAMETERS_HOME whose records are not in CWORDERINSTANCE.
   * Services (so, record in STC_SERVICE_PARAMETERS_HOME) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanServiceParamsWithoutOrder(finish_ok OUT VARCHAR2);


  /**
   * To remove all records in STC_NAME_VALUE whose records are not in CWORDERINSTANCE.
   * NV Pair (so, record in STC_NAME_VALUE) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanNVPairWithoutOrder(finish_ok OUT VARCHAR2);


  /**
   * To remove all records in STC_ORDER_ACK whose records are not in CWORDERINSTANCE.
   * Order Ack (so, record in STC_ORDER_ACK) is part of the order (ds_ws:default_orderSTC_HOME).
   */
  PROCEDURE cleanOrderAckWithoutOrder(finish_ok OUT VARCHAR2);


  /**
   * To perform all the procedures to clean up CWH DB.
   */
  PROCEDURE performCleanUp;

END CWH_HOUSEKEEPING;
