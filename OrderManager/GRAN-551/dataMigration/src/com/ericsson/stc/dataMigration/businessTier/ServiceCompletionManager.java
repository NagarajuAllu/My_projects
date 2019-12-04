package com.ericsson.stc.dataMigration.businessTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.AsiServices;
import com.ericsson.stc.dataMigration.graniteServiceTier.GranitePathServiceImpl;


import com.ericsson.stc.dataMigration.graniteServiceTier.GraniteWOTaskServiceImpl;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.UdaPojo;
import com.ericsson.stc.dataMigration.persistentTier.OracleConnectionManager;
import com.ericsson.stc.dataMigration.persistentTier.pojo.ServiceData;
import com.ericsson.stc.dataMigration.utility.PropertyReader;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.HashMap;

public class ServiceCompletionManager {

  private final Logger         _log            = Logger.getLogger(getClass());

  private String             _parentPathNames = null;
  private ArrayList<KeyPojo> _parentPaths     = null;
  private ArrayList<UdaPojo> _udaToCreate     = null;

  public ServiceCompletionManager() throws Exception {
    _parentPathNames = PropertyReader.getInstance().getProperty("parentPaths");
    if(_parentPathNames == null) {
      throw new Exception("Error in configuration file: 'parentPaths' configuration is missing");
    }

    String udaConfigured = PropertyReader.getInstance().getProperty("udaToUpdate");
    if(udaConfigured == null) {
      throw new Exception("Error in configuration file: 'udaToUpdate' configuration is missing");
    }

    String[] udaDetails = udaConfigured.split(";");
    for(String udaDetail: udaDetails) {
      String[] singleUDAInfo = udaDetail.split(",");
      if(singleUDAInfo.length != 3) {
        throw new Exception("Error in configuration file: 'udaToUpdate' contains an udaDetail <" + udaDetail +
                            "> with a wrong number of info - expected 3, found: " + singleUDAInfo.length);
      }
      if(_udaToCreate == null) {
        _udaToCreate = new ArrayList<>();
      }
      _udaToCreate.add(new UdaPojo(singleUDAInfo[0], singleUDAInfo[1], singleUDAInfo[2]));
    }
  }

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

          //load parent paths info
          loadParentPathsInfo();
          if(_parentPaths == null) {
            _log.error("Unable to find parent paths; no activity will be performed on the services!!!!");
          }
          else {
            for (String pathName : allServices.keySet()) {
              ServiceData serviceData = allServices.get(pathName);
              String orderNumber = serviceData.getOrderNumber();

              int resultServiceManagement = -1;
              try {
                // update the uda and the routing of the path
                resultServiceManagement = (updateUDAAndRoutingForPath(pathName) ? 2 : -2);
                _log.info("Service <" + pathName + "," + orderNumber + "> updated for UDA and routing with result = " + resultServiceManagement);


                oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement);
                _log.info("Processed service <" + pathName + "," + orderNumber + "> with result = " + resultServiceManagement);
              }
              catch (Exception exc) {
                _log.error("Unexpected error while processing service <" + pathName + "," + orderNumber + ">", exc);
              }

              if (resultServiceManagement == 2) {
                try {
                  // perform check-in and check-out of the task
                  resultServiceManagement = (completeAllTasksForWO(orderNumber) ? 3 : -3);
                  _log.info("Service <" + pathName + "," + orderNumber + "> performed check-in and check-out with result = " + resultServiceManagement);


                  oracleConnectionManager.markServiceRecordAsProcessed(pathName, resultServiceManagement);
                  _log.info("Processed tasks for service <" + pathName + "," + orderNumber + "> with result = " + resultServiceManagement);
                }
                catch (Exception exc) {
                  _log.error("Unexpected error while processing tasks for service <" + pathName + "," + orderNumber + ">", exc);
                }
              }
            }
            _log.info("Completed processing all " + allServices.size() + " service records");
          }

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
   * To load the keys of the parent paths
   */
  private void loadParentPathsInfo() {
    String[] pPathNames = _parentPathNames.split(";");
    try {
      for (String parentPathName : pPathNames) {
        GranitePathServiceImpl granitePathService = new GranitePathServiceImpl();
        KeyPojo pathKey = granitePathService.getPathKeyByName(parentPathName);
        if (pathKey == null) {
          throw new Exception("Unable to find the parent path with name '" + parentPathName + "'");
        }

        if (_parentPaths == null) {
          _parentPaths = new ArrayList<>();
        }
        _parentPaths.add(pathKey);
      }
    }
    catch(Throwable exc){
      _log.error("Unexpected error while searching the parent paths", exc);
      _parentPaths = null;
    }
  }

  /**
   * To add the UDAs to a path and to route the path on the dynamic channels of the parent paths.
   *
   * @param pathName the name of the path under management.
   * @return the result of the operation: true is success, false if any error occurred.
   */
  private boolean updateUDAAndRoutingForPath(String pathName) {
    boolean successfullUpdate;

    try {
      GranitePathServiceImpl granitePathService = new GranitePathServiceImpl();
      KeyPojo pathKey = granitePathService.getPathKeyByName(pathName);
      if (pathKey == null) {
        throw new Exception("Unable to find the child path with name '" + pathName + "'");
      }

      granitePathService.addUDAsToPath(pathKey.getInstId(), _udaToCreate);

      int position = 1;
      for(KeyPojo parentPathKey : _parentPaths) {
        granitePathService.routePathOnDynamicChannel(pathKey.getInstId(),
                                                     parentPathKey.getInstId(),
                                                     position);
        position++;
      }

      successfullUpdate = true;
    }
    catch (Exception exc) {
      _log.error("Error in updating UDA and routing for path <" + pathName + ">:" + exc.getMessage(), exc);
      successfullUpdate = false;
    }

    return successfullUpdate;
  }

  /**
   * To complete all the tasks linked to the WO whose name is provided.
   *
   * @param woName the name of the workOrder under management.
   * @return the result of the operation: true is success, false if any error occurred.
   */
  private boolean completeAllTasksForWO(String woName) {
    boolean successfullUpdate;

    try {
      GraniteWOTaskServiceImpl graniteWOTaskService = new GraniteWOTaskServiceImpl();

      KeyPojo woKey = graniteWOTaskService.completeAllTasksInWO(woName);
      if(woKey == null) {
        throw new Exception("Unable to find the workOrder with name '" + woName + "'");
      }

      successfullUpdate = true;
    }
    catch (Exception exc) {
      _log.error("Error in completing all the tasks for WorkOrder <" + woName + ">:" + exc.getMessage(), exc);
      successfullUpdate = false;
    }

    return successfullUpdate;
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
