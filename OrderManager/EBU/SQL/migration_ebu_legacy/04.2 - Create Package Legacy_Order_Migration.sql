CREATE OR REPLACE PACKAGE LEGACY_ORDER_MIGRATION IS


  /***
    To log messages. It insert into the log table and print on stdout.
  ***/
  PROCEDURE log(msg IN VARCHAR2);


  /***
    The MAIN!
    Actions:
    1. It performs migration of all the legacy orders found with:
        - businessUnit = 'Enterprise'
        - migratedToBundle = '0'
    2. validate the new order
    3. generate the orchestration table of the new order
   ***/
  PROCEDURE migrate_all_legacy_orders;


  /***
    It performs migration of a single legacy order found
   ***/
  PROCEDURE migrate_single_legacy_order(orderNumber IN VARCHAR2, orderStatus IN VARCHAR2, orderType IN VARCHAR2,
                                        legacyOrderId IN VARCHAR2, bundleOrderMdType IN VARCHAR2, workingVersionId IN NUMBER,
                                        bundleOrderId IN OUT VARCHAR2);


  /***
    Create orderHeader (STC_BUNDLEORDER_HEADER table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_bundleOrder_header(bundleOrderId IN VARCHAR2, woCompletionDate IN DATE, legacyOrderNumber IN VARCHAR2, legacyOrderId IN VARCHAR2);


  /***
    Create lineItem (STC_LINEITEM table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_lineItem(bundleOrderId IN VARCHAR2, legacyOrderId IN VARCHAR2, legacyOrderNumber IN VARCHAR2,
                            legacyOrderStatus IN VARCHAR2, legacyOrderType IN VARCHAR2, woCompletionDate IN DATE);


  /***
    Create nameValue pairs (STC_NAME_VALUE table) and the corresponding pointers in cworderitems.
  ***/
  PROCEDURE create_nameValues(bundleOrderId IN VARCHAR2, countNV IN OUT NUMBER, legacyOrderId IN VARCHAR2,
                              nvAction IN VARCHAR2, legacyServiceParentId IN VARCHAR2);


  /***
    To decode the action of the lineItem according to the:
    - orderStatus
    - orderType
    - if it's a SubmitOrder
    - if it's a CancelOrder
  ***/
  FUNCTION decode_action_of_lineItem(bundleOrderStatus IN VARCHAR2, bundleOrderType IN VARCHAR2, isSubmit IN NUMBER, isCancel IN NUMBER) RETURN VARCHAR2;


  /***
    To decode the action of the lineItem according to the:
    - orderStatus
    - orderType
  ***/
  FUNCTION get_action_by_orderStatus_Type(orderStatus IN VARCHAR2, orderType IN VARCHAR2) RETURN VARCHAR2;


  /***
    To decode the action of the nvPair according to the:
    - action of the lineItem parent
  ***/
  FUNCTION get_NVAction(bundleAction IN VARCHAR2) RETURN VARCHAR2;


  /***
    Validate the bundleOrder just created and dump all errors found.
  ***/
  PROCEDURE validate_bundleOrder(bundleOrderId IN VARCHAR2, isValid OUT CHAR);


  /***
    Validate the header of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_bundleOrder_header(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR);


  /***
    Validate the lineItem of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_lineItem(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR);


  /***
    Validate the nv pairs of the bundle order just created and dump all the errors found.
  ***/
  PROCEDURE validate_NV_pairs(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR);


  /***
    Print validation header only if it's the first time for the order
  ***/
  PROCEDURE print_validation_header(bundleOrderId IN VARCHAR2, headerValidationPrinted IN OUT CHAR);


  /***
    To verify if the input value is a valid value for the dataType.
    The check is implemented using the values in table STC_PICKLIST_FOR_VALIDATION.
    Return 'Y' is the valid is valid, 'N' otherwise.
   ***/
  FUNCTION is_a_valid_value(inputValue IN VARCHAR2, inputDataTypeName IN VARCHAR2) RETURN CHAR;


  /***
    It generates the entries for orchestration table for the new order.
   ***/
  PROCEDURE generate_orchestration_table(bundleOrderId IN VARCHAR2);


END LEGACY_ORDER_MIGRATION;
/