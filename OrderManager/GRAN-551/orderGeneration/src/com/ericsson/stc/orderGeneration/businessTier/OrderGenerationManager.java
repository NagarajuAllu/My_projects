package com.ericsson.stc.orderGeneration.businessTier;

import com.ericsson.stc.orderGeneration.persistentTier.OracleConnectionManager;
import com.ericsson.stc.orderGeneration.persistentTier.pojo.ServiceData;
import org.apache.commons.jxpath.JXPathContext;
import org.apache.commons.jxpath.xml.DOMParser;
import org.apache.log4j.Logger;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.HashMap;

public class OrderGenerationManager {

  private final Logger _log = Logger.getLogger(getClass());
  private WebServiceInvoker _webServiceInvoker = null;

  public OrderGenerationManager() throws Exception {
    _webServiceInvoker = WebServiceInvoker.getInstance();
  }

  /**
   * This method is responsible to:
   * - load all the services that should be managed from DB
   * - for each of them, it checks if the customer is in Granite;
   *   - if yes, update the record to 2
   *   - otherwise insert the customer and update the record to 1.
   */
  public void processAllServices() {
    try {
      OracleConnectionManager oracleConnectionManager = OracleConnectionManager.getInstance();
      HashMap<String, ServiceData> allServices = oracleConnectionManager.extractAllRecordsForServices();

      if(allServices == null) {
        _log.error("Unable to connect to the DB or to extract data for Services. Please check previous errors");
      }
      else {
        if (allServices.size() == 0) {
          _log.info("No service records that should be processed found in DB; so nothing to do");
        }
        else {
          _log.info("Found " + allServices.size() + " service records to process");

          for (String pathName : allServices.keySet()) {
            ServiceData serviceData = allServices.get(pathName);
            String orderNumber = serviceData.getOrderNumber();

            try {
              int resultServiceManagement;

              if(serviceData.getCustomerMigrationResult() != 1 && serviceData.getCustomerMigrationResult() != 2) {
                // customer not created for any reason
                _log.info("Customer Migration result for <" + pathName + "," + orderNumber + "> has wrong value; found: " + serviceData.getCustomerMigrationResult());
                resultServiceManagement = -8;
              }
              else {
                // customer created; generating the order
                try {
                  String resultMsg = _webServiceInvoker.invoke(serviceData);
                  if (resultMsg != null) {
                    resultServiceManagement = isOrderAccepted(resultMsg, orderNumber) ? 1 : -1;

                  }
                  else {
                    resultServiceManagement = -9;
                  }
                }
                catch (InvokerException iExc) {
                  _log.error("Error while invoking the WebService; errorMsg = " + iExc.getMessage(), iExc);
                  resultServiceManagement = -9;
                }
              }

              oracleConnectionManager.markRecordAsProcessed(pathName, resultServiceManagement);
              _log.info("Processed service <" + pathName + "," + orderNumber + "> with result = " + resultServiceManagement);
            }
            catch (Exception exc) {
              _log.error("Unexpected error while processing service <" + pathName + "," + orderNumber + ">", exc);
            }
          }

          _log.info("Completed processing all " + allServices.size() + " customer records");
        }
      }
    }
    catch(Throwable t) {
      _log.error("Unexpected error while managing customers", t);
    }
  }

  private boolean isOrderAccepted(String webServiceResponse, String orderNumber) {
    String responseStatus = null;
    if(webServiceResponse != null && webServiceResponse.trim().length() > 0) {
      ByteArrayInputStream inputStream = new ByteArrayInputStream(webServiceResponse.getBytes());
      DOMParser domParser = new DOMParser();
      Object o = domParser.parseXML(inputStream);
      // create XPath Context
      JXPathContext context = JXPathContext.newContext(o);

      // possible xPaths for "status"
      responseStatus = (String) context.getValue("//MasterOrderStatus", String.class);
      
      try {
        if (inputStream != null) {
          inputStream.close();
        }
      }
      catch(IOException exc) {
        // ignoring it
      }
    }
    else {
      responseStatus = "No Response Found";
    }

    _log.info("Received response for order <" + orderNumber + ">: " + responseStatus);

    return (responseStatus.equals("New"));
  }

}
