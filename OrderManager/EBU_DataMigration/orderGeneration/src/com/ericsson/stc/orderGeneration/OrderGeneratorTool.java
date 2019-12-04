package com.ericsson.stc.orderGeneration;

import com.ericsson.stc.orderGeneration.businessTier.OrderGenerationManager;
import org.apache.log4j.Logger;

/**
 * To manage customer migration. It uses the OrderGenerationManager class to perform all the actions.
 */
public class OrderGeneratorTool {

  private Logger         _log                = Logger.getLogger(OrderGeneratorTool.class);

  public static void main(String[] args) {
    OrderGeneratorTool orderGeneratorTool = new OrderGeneratorTool();
    orderGeneratorTool.runMigration();
  }

  private void runMigration() {
    try {
      OrderGenerationManager orderGenerationManager = new OrderGenerationManager();
      orderGenerationManager.processAllServices();
    }
    catch(Exception exc) {
      _log.error(exc);
    }
  }
}