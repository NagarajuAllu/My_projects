package com.ericsson.stc.dataMigration.businessTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.AsiServices;
import com.ericsson.stc.dataMigration.graniteServiceTier.GraniteCustomerServiceImpl;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.ericsson.stc.dataMigration.persistentTier.OracleConnectionManager;
import com.ericsson.stc.dataMigration.persistentTier.pojo.CustomerData;
import org.apache.log4j.Logger;

import java.util.HashMap;

public class CustomerManager {

  private final Logger         _log            = Logger.getLogger(CustomerManager.class);
  private GraniteCustomerServiceImpl _graniteCustomerService = null;

  public CustomerManager() throws Exception {
    _graniteCustomerService = new GraniteCustomerServiceImpl();
  }

  /**
   * This method is responsible to:
   * - load all the customers that should be managed from DB
   * - for each of them, it checks if the customer is in Granite;
   *   - if yes, update the record to 2
   *   - otherwise insert the customer and update the record to 1.
   */
  public void processAllCustomers() {
    try {
      OracleConnectionManager oracleConnectionManager = OracleConnectionManager.getInstance();
      HashMap<Integer, CustomerData> allCustomers = oracleConnectionManager.extractAllRecordsForCustomers();

      if(allCustomers == null) {
        _log.error("Unable to connect to the DB or to extract data for Customers. Please check previous errors");
      }
      else {
        if (allCustomers.size() == 0) {
          _log.info("No customer records that should be processed found in DB; so nothing to do");
        }
        else {
          _log.info("Found " + allCustomers.size() + " customer records to process");

          // startup the factory
          startupASIFactory();

          for (Integer key : allCustomers.keySet()) {
            CustomerData customerData = allCustomers.get(key);
            String customerId = customerData.getCustomerRef();

            try {
              int resultCustomerManagement;

              KeyPojo customerKey = getCustomerKeyByCustomerId(customerId);
              if (customerKey != null) {
                // customer already exists; update the record to "2"
                resultCustomerManagement = 2;
                _log.info("Customer already exists for <" + key + "," + customerId + ">; InstId = " + customerKey.getInstId());
              }
              else {
                // customer does not exist so it has to be created
                KeyPojo newCustomer = createNewCustomer(customerId,
                                                        customerData.getCustomerRef(),
                                                        customerData.getCustomerType(),
                                                        "ACTIVE",
                                                        customerData.getCustomerSubType(),
                                                        customerData.getIdType(),
                                                        customerData.getAccountNO());

                resultCustomerManagement = 1;
                _log.info("New Customer created for <" + key + "," + customerId + ">; InstId = " + newCustomer.getInstId());
              }

              oracleConnectionManager.markCustomerRecordAsProcessed(key, resultCustomerManagement);
              _log.info("Processed customer <" + key + "," + customerId + "> with result = " + resultCustomerManagement);
            }
            catch (Exception exc) {
              _log.error("Unexpected error while processing customer <" + key + "," + customerId + ">", exc);
            }
          }

          shutdownASIFactory();

          _log.info("Completed processing all " + allCustomers.size() + " customer records");
        }
      }
    }
    catch(Throwable t) {
      _log.error("Unexpected error while managing customers", t);
    }
    finally {
      try {
        shutdownASIFactory();
      }
      catch (Throwable t) {
        _log.error("Unexpected error while shutting down the ASI factory", t);
      }
    }
  }

  private KeyPojo getCustomerKeyByCustomerId(String customerId) throws Exception {
    Exception foundException = null;
    KeyPojo customerKey = null;

    try {
      customerKey = _graniteCustomerService.getCustomerKeyByCustomerId(customerId);
    }
    catch (Exception exc) {
      _log.error("Unexpected error in executing getCustomerKeyByCustomerId(" + customerId + ")", exc);
      foundException = exc;
    }

    if (foundException != null) {
      throw foundException;
    }

    return customerKey;
  }

  private KeyPojo createNewCustomer(String customerId, String customerName, String customerType,
                                    String status, String customerSubTypeUDAValue, String idTypeUDAValue,
                                    String accountNoUDAValue) throws Exception {
    Exception foundException = null;
    KeyPojo customerKeyPojo = null;

    try {
      customerKeyPojo = _graniteCustomerService.createNewCustomer(customerId, customerName, customerType, status,
                                                                  customerSubTypeUDAValue, idTypeUDAValue,
                                                                  accountNoUDAValue);
    }
    catch (Exception exc) {
      _log.error("Unexpected error in executing createNewCustomer(" + customerId + ")", exc);
      foundException = exc;
    }

    if (foundException != null) {
      throw foundException;
    }

    return customerKeyPojo;
  }

  private void startupASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiStartup();
    }
    catch (Exception exc) {
      _log.error("Unexpected error in starting up the ASI Factory", exc);
      throw exc;
    }
  }

  private void shutdownASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiShutdown();
    }
    catch (Exception exc) {
      _log.error("Unexpected error in shutting down the ASI Factory", exc);
      throw exc;
    }
  }

}
