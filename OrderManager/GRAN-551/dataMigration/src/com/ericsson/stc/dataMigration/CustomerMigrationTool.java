package com.ericsson.stc.dataMigration;

import com.ericsson.stc.dataMigration.businessTier.CustomerManager;
import org.apache.log4j.Logger;

/**
 * To manage customer migration. It uses the CustomerManager class to perform all the actions.
 */
public class CustomerMigrationTool {

  private Logger         _log                = Logger.getLogger(CustomerMigrationTool.class);

  public static void main(String[] args) {
    CustomerMigrationTool customerMigrationTool = new CustomerMigrationTool();
    customerMigrationTool.runMigration();
  }

  private void runMigration() {
    try {
      CustomerManager customerManager = new CustomerManager();
      customerManager.processAllCustomers();
    }
    catch(Exception exc) {
      _log.error(exc);
    }
  }
}
