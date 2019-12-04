package com.ericsson.stc.dataMigration.businessTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.AsiServices;
import com.ericsson.stc.dataMigration.graniteServiceTier.GranitePathServiceImpl;


import com.ericsson.stc.dataMigration.graniteServiceTier.GraniteWOTaskServiceImpl;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.UdaPojo;
import com.ericsson.stc.dataMigration.persistentTier.OracleConnectionManager;
import com.ericsson.stc.dataMigration.persistentTier.pojo.ServiceData;
import com.ericsson.stc.dataMigration.utility.PropertyReader;
import org.apache.commons.jxpath.JXPathContext;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.HashMap;

public class ServiceCompletionManager {

  private final Logger         _log            = Logger.getLogger(getClass());

  private HashMap<String, ArrayList<KeyPojo>> _parentPathsForServices = new HashMap<>();
  private HashMap<String, ArrayList<UdaPojo>> _udaToCreateForServices = new HashMap<>();

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

          // startup the factory
          startupASIFactory();

          for (String pathName : allServices.keySet()) {
            ServiceData serviceData = allServices.get(pathName);

            String orderNumber = serviceData.getOrderNumber();

            int resultServiceManagement;
            String errorMsg;
            try {
              // update the udas of the path
              errorMsg = updateUDAForPath(serviceData);
              resultServiceManagement = ((errorMsg == null) ? 2 : -2);
              _log.info("Service <" + pathName + "," + orderNumber + "> updated for UDA with result = " + resultServiceManagement);


              oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
              _log.info("Processed UDAs for service <" + pathName + "," + orderNumber + "> with result = " +
                        resultServiceManagement + "; errorMsg = " + errorMsg);
            }
            catch (Exception exc) {
              _log.error("Unexpected error while processing UDAs for service <" + pathName + "," + orderNumber + ">", exc);

              // managing the error
              resultServiceManagement=-2;
              errorMsg = "Unexpected error:" + exc.getMessage();
              oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
            }

            if (resultServiceManagement == 2) {
              try {
                // update the udas of the path
                errorMsg = updateRoutingForPath(serviceData);
                resultServiceManagement = ((errorMsg == null) ? 3 : -3);
                _log.info("Service <" + pathName + "," + orderNumber + "> updated for routing with result = " +
                          resultServiceManagement + "; errorMsg = " + errorMsg);


                oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
                _log.info("Processed routing for service <" + pathName + "," + orderNumber + "> with result = " + resultServiceManagement);
              }
              catch (Exception exc) {
                _log.error("Unexpected error while processing routing for service <" + pathName + "," + orderNumber + ">", exc);

                // managing the error
                resultServiceManagement=-3;
                errorMsg = "Unexpected error:" + exc.getMessage();
                oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
              }
            }

            if (resultServiceManagement == 3) {
              try {
                // perform check-in and check-out of the task
                errorMsg = completeAllTasksForWO(orderNumber);
                resultServiceManagement = ((errorMsg == null) ? 4 : -4);
                _log.info("Service <" + pathName + "," + orderNumber + "> performed check-in and check-out with result = " +
                          resultServiceManagement + "; errorMsg = " + errorMsg);

                oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
                _log.info("Processed tasks for service <" + pathName + "," + orderNumber + "> with result = " + resultServiceManagement);
              }
              catch (Exception exc) {
                _log.error("Unexpected error while processing tasks for service <" + pathName + "," + orderNumber + ">", exc);
                // managing the error
                resultServiceManagement=-4;
                errorMsg = "Unexpected error:" + exc.getMessage();
                oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement, errorMsg, orderNumber);
              }
            }
          }
          _log.info("Completed processing all " + allServices.size() + " service records");

          shutdownASIFactory();
        }
      }
    }
    catch(Throwable t) {
      _log.error("Unexpected error while managing services", t);
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

  /**
   * To add the UDAs to a path.
   *
   * @param serviceData the data of path under management.
   * @return the result of the operation: null is success, the error description if any error occurred.
   */
  private String updateUDAForPath(ServiceData serviceData) {
    String errorMessage = null;

    try {
      ArrayList<UdaPojo> udaPojos = _udaToCreateForServices.get(serviceData.getCircuitCategory());

      if(udaPojos == null) {
        udaPojos = loadUDADefinitionForService(serviceData.getCircuitCategory());
      }

      if(udaPojos != null) {
        ArrayList<UdaPojo> udaToCreate = fillUDAValuesForService(udaPojos, serviceData);

        GranitePathServiceImpl granitePathService = new GranitePathServiceImpl();
        KeyPojo pathKey = granitePathService.getPathKeyByName(serviceData.getPathName());
        if (pathKey == null) {
          throw new Exception("Unable to find the path with name '" + serviceData.getPathName() + "'");
        }

        granitePathService.addUDAsToPath(pathKey.getInstId(), udaToCreate);
      }
    }
    catch (Exception exc) {
      _log.error("Error in updating UDA for path <" + serviceData.getPathName() + ">:" + exc.getMessage(), exc);
      errorMessage = exc.getMessage();
    }

    return errorMessage;
  }

  /**
   * To route the path on the dynamic channels of the parent paths.
   *
   * @param serviceData the data of the path under management.
   * @return the result of the operation: null is success, the error description if any error occurred.
   */
  private String updateRoutingForPath(ServiceData serviceData) {
    String errorMessage = null;

    try {
      ArrayList<KeyPojo> parentPathKeys = _parentPathsForServices.get(serviceData.getCircuitCategory());
      if(parentPathKeys == null) {
        parentPathKeys = loadParentPathsInfoForService(serviceData.getCircuitCategory());
      }

      if(parentPathKeys != null) {
        GranitePathServiceImpl granitePathService = new GranitePathServiceImpl();
        KeyPojo pathKey = granitePathService.getPathKeyByName(serviceData.getPathName());
        if (pathKey == null) {
          throw new Exception("Unable to find the path with name '" + serviceData.getPathName() + "'");
        }

        int position = 1;
        for (KeyPojo parentPathKey : parentPathKeys) {
          granitePathService.routePathOnDynamicChannel(pathKey.getInstId(),
                                                       parentPathKey.getInstId(),
                                                       position);
          position++;
        }
      }
    }
    catch (Exception exc) {
      _log.error("Error in updating routing for path <" + serviceData.getPathName() + ">:" + exc.getMessage(), exc);
      errorMessage = exc.getMessage();
    }

    return errorMessage;
  }

  /**
   * To complete all the tasks linked to the WO whose name is provided.
   *
   * @param woName the name of the workOrder under management.
   * @return the result of the operation: null is success, the error description if any error occurred.
   */
  private String completeAllTasksForWO(String woName) {
    String errorMessage = null;

    try {
      GraniteWOTaskServiceImpl graniteWOTaskService = new GraniteWOTaskServiceImpl();

      KeyPojo woKey = graniteWOTaskService.completeAllTasksInWO(woName);
      if(woKey == null) {
        throw new Exception("Unable to find the workOrder with name '" + woName + "'");
      }
    }
    catch (Exception exc) {
      _log.error("Error in completing all the tasks for WorkOrder <" + woName + ">:" + exc.getMessage(), exc);
      errorMessage = exc.getMessage();
    }

    return errorMessage;
  }

  /**
   * To startup the ASI factory.
   *
   * @throws Exception if any error occurs during startup.
   */
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

  /**
   * To shutdown the ASI factory.
   *
   * @throws Exception if any error occurs during shutdown.
   */
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

  /**
   * To load the definition of the UDAs that need to be created for the provided serviceType.
   * The ArrayList is also loaded in the class attribute _udaToCreateForServices.
   * @param circuitCategory the category of the path under management.
   * @return the definition of the UDAs that need to be created.
   * @throws Exception if any error occurs.
   */
  private ArrayList<UdaPojo> loadUDADefinitionForService(String circuitCategory) throws Exception{
    String propertyName = "udasForGENRService";
    if(circuitCategory.equals("DSLSKY")) {
      propertyName = "udasForDSLSKYService";
    }
    else if(circuitCategory.equals("MVPN")) {
      propertyName = "udasForMVPNService";
    }
    String udaConfigured = PropertyReader.getInstance().getProperty(propertyName);
    if(udaConfigured == null) {
      throw new Exception("Error in configuration file: '" + propertyName + "' configuration is missing");
    }


    ArrayList<UdaPojo> udaToCreate = null;

    String[] udaDetails = udaConfigured.split(";");
    for(String udaDetail: udaDetails) {
      String[] singleUDAInfo = udaDetail.split(",");
      if(singleUDAInfo.length != 3) {
        throw new Exception("Error in configuration file: '" + propertyName + "' contains an udaDetail <" + udaDetail +
                            "> with a wrong number of info - expected 3, found: " + singleUDAInfo.length);
      }

      if(udaToCreate == null) {
        udaToCreate = new ArrayList<>();
      }
      udaToCreate.add(new UdaPojo(singleUDAInfo[0], singleUDAInfo[1], singleUDAInfo[2]));
    }

    _udaToCreateForServices.put(circuitCategory, udaToCreate);

    return udaToCreate;
  }

  /**
   * To have all the UDAs (with the value) that need to be created for the provided service.
   * @param udaPojos the definition of the UDAs that must be created.
   * @param serviceData the details of the service under management.
   * @return the details of the UDAs that need to be created.
   */

  private ArrayList<UdaPojo> fillUDAValuesForService(ArrayList<UdaPojo> udaPojos, ServiceData serviceData) {
    ArrayList<UdaPojo> udaToCreate = new ArrayList<>(udaPojos.size());

    JXPathContext context = JXPathContext.newContext(serviceData);

    for(UdaPojo udaPojo: udaPojos) {
      UdaPojo newUdaPojo = new UdaPojo();
      newUdaPojo.setUdaGroup(udaPojo.getUdaGroup());
      newUdaPojo.setUdaName(udaPojo.getUdaName());

      String udaValue = udaPojo.getUdaValue();
      if(udaValue.startsWith("//")) {
        // it's an attribute of the pojo, so grabbing the value from that
        newUdaPojo.setUdaValue((String)context.getValue(udaValue));
      }
      else {
        newUdaPojo.setUdaValue(udaValue);
      }

      udaToCreate.add(newUdaPojo);
    }

    return udaToCreate;
  }


  /**
   * To load the keys of the parent paths according to the serviceType.
   * The ArrayList is also loaded in the class attribute _udaToCreateForServices.
   * @param circuitCategory the category of the path under management.
   * @return the details of the UDAs that need to be created.
   * @throws Exception if any error occurs.
   */
  private ArrayList<KeyPojo> loadParentPathsInfoForService(String circuitCategory) throws Exception {
    String propertyName = "parentPathsForGENR";
    if(circuitCategory.equals("DSLSKY")) {
      propertyName = "parentPathsForDSLSKY";
    }
    else if(circuitCategory.equals("MVPN")) {
      propertyName = "parentPathsForMVPN";
    }
    String parentPathsConfigured = PropertyReader.getInstance().getProperty(propertyName);
    if(parentPathsConfigured == null) {
      throw new Exception("Error in configuration file: '" + propertyName + "' configuration is missing");
    }

    ArrayList<KeyPojo> parentPathKeys = null;
    if(! parentPathsConfigured.equals("NULL")) {
      String[] pPathNames = parentPathsConfigured.split(";");
      try {
        for (String parentPathName : pPathNames) {
          GranitePathServiceImpl granitePathService = new GranitePathServiceImpl();
          KeyPojo pathKey = granitePathService.getPathKeyByName(parentPathName);
          if (pathKey == null) {
            throw new Exception("Unable to find the parent path with name '" + parentPathName + "'");
          }

          if (parentPathKeys == null) {
            parentPathKeys = new ArrayList<>();
          }
          parentPathKeys.add(pathKey);
        }
      }
      catch(Throwable exc){
        _log.error("Unexpected error while searching the parent paths", exc);
        parentPathKeys = null;
      }
    }

    _parentPathsForServices.put(circuitCategory, parentPathKeys);
    return parentPathKeys;
  }
}
