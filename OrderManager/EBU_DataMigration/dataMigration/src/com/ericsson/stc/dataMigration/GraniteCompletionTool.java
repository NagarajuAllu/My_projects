package com.ericsson.stc.dataMigration;

import com.ericsson.stc.dataMigration.businessTier.ServiceCompletionManager;
import org.apache.log4j.Logger;

/**
 * To manage customer migration. It uses the CustomerManager class to perform all the actions.
 */
public class GraniteCompletionTool {

  private Logger         _log                = Logger.getLogger(GraniteCompletionTool.class);

  public static void main(String[] args) {
    GraniteCompletionTool graniteCompletionTool = new GraniteCompletionTool();
    graniteCompletionTool.runMigration();
  }

  private void runMigration() {
    try {
      ServiceCompletionManager serviceCompletionManager = new ServiceCompletionManager();
      serviceCompletionManager.processAllServices();
    }
    catch(Exception exc) {
      _log.error(exc);
    }
  }
}
