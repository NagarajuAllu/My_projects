CREATE OR REPLACE PACKAGE DELETE_PARENT_ORDER_STRUCTURE IS

  /**
   * To delete a parent order whose orderNumber is provided.
   */
  PROCEDURE deleteParentAndChildOrders(parent_order_number IN VARCHAR2);

  /**
   * To check if the parent order can be deleted or not, according to the status of the WOs in Granite.
   */
  FUNCTION validateCancelParentOrder(parent_order_number IN VARCHAR2) return CHAR;

  /**
   * To check if an order can be deleted or not, according to the status of the WO in Granite.
   */
  FUNCTION validateCancelChildOrder(order_number IN VARCHAR2) return CHAR;

  /**
   * To delete an order from WD.
   */
  PROCEDURE deleteOrderStructureFromWD(order_number IN VARCHAR2);


END DELETE_PARENT_ORDER_STRUCTURE;
/