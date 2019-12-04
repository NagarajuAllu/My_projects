package com.ericsson.stc.dataMigration.graniteServiceTier;

import java.io.Serializable;
import java.util.Properties;

import com.ericsson.stc.dataMigration.utility.PropertyReader;
import com.granite.asi.dto.clientview.*;
import com.granite.asi.exception.ShutdownException;
import com.granite.asi.factory.ASIFactory;
import com.granite.asi.factory.DataObjectFactory;
import com.granite.asi.factory.ServiceFactory;
import com.granite.asi.service.*;
import com.granite.asi.util.*;
import org.apache.log4j.Logger;

/**
 * To manage ASI startup/shutdown and to object the services
 */
public class AsiServices implements Serializable{

  private static final long serialVersionUID = 4541479299193638994L;

  private Logger _log = Logger.getLogger(AsiServices.class);

  /**
   * The unique instance of this class.
   */
  private static AsiServices _instance;

  private Properties _graniteConnectionParams = null;

  private DataObjectFactory _dataObjectFactory = null;
  private ServiceFactory _serviceFactory = null;

  private AsiServices() {
    loadGraniteConnectionParams();
  }

  public static AsiServices getInstance() {
    if(_instance == null) {
      _instance = new AsiServices();
    }

    return _instance;
  }

  public void asiStartup() throws Exception {
    if(_graniteConnectionParams == null) {
      loadGraniteConnectionParams();
    }

    if((_serviceFactory != null) && (_serviceFactory.isStarted())) {
      throw new Exception("ServiceFactory already started!!!!");
    }

    try {
      _dataObjectFactory = ASIFactory.newDataObjectFactory(DataForms.CLIENTVIEW);
      _serviceFactory = ASIFactory.newServiceFactory(Protocols.IIOP , _dataObjectFactory);
      _serviceFactory.startup(_graniteConnectionParams);
      _log.info("\n asiStartup() --------> : [ASI Factory started] :"+ _graniteConnectionParams.toString());
    }
    catch (Exception exc) {
      _log.error("Unexpected error while starting up the factory", exc);
      throw new Exception("Unexpected error while starting up the factory: ", exc);
    }
  }

  public  void asiShutdown() throws Exception{
    try {
      if ((_serviceFactory != null) && (_serviceFactory.isStarted())){
        _serviceFactory.shutdown();
        _serviceFactory = null;
        _log.info("asiShutdown() --------> : [ASI Factory shutdown]");
      }
      else {
        _log.info("asiShutdown() --------> : [ASI Factory already down or null]");
      }
    }
    catch (ShutdownException exc) {
      throw new Exception("Unexpected error while shutting down the factory", exc);
    }
  }

  public PathService getPathService() throws Exception {
    return (PathService) _serviceFactory.newService(CoreServices.PATH);
  }

  public CustomerService getCustomerService() throws Exception {
    return (CustomerService) _serviceFactory.newService(CoreServices.CUSTOMER);
  }

  public LockService getLockService() throws Exception {
    return (LockService) _serviceFactory.newService(CoreServices.LOCK);
  }

  public WorkOrderTaskService getWOTaskService() throws Exception {
    return (WorkOrderTaskService) _serviceFactory.newService(WorxServices.WORKORDERTASK);
  }

  public WorkOrderService getWorkOrderService() throws Exception {
    return (WorkOrderService) _serviceFactory.newService(WorxServices.WORKORDER);
  }

  public Path getNewPath() throws Exception {
    return (Path)_dataObjectFactory.newDataObject(CoreDataObjects.PATH);
  }

  public Uda getNewUda() throws Exception {
      return (Uda)_dataObjectFactory.newDataObject(CoreDataObjects.UDA);
  }

  public PathElement getNewPathElement() throws Exception {
    return (PathElement) _dataObjectFactory.newDataObject(CoreDataObjects.PATHELEMENT);
  }

  public Customer getNewCustomer() throws Exception {
    return (Customer)_dataObjectFactory.newDataObject(CoreDataObjects.CUSTOMER);
  }

  public WorkOrder getNewWorkOrder() throws Exception {
    return (WorkOrder)_dataObjectFactory.newDataObject(WorxDataObjects.WORKORDER);
  }

  public WorkOrderTask getNewWorkOrderTask() throws Exception {
    return (WorkOrderTask)_dataObjectFactory.newDataObject(WorxDataObjects.WORKORDERTASK);
  }

  private void loadGraniteConnectionParams() {
    PropertyReader propertyReader = PropertyReader.getInstance();
    String[] params = {"java.naming.provider.url",
                       "java.naming.factory.initial",
                       "com.granite.asi.host",
                       "com.granite.asi.database",
                       "com.granite.asi.username",
                       "com.granite.asi.password"};

    for(String param : params) {
      String value = propertyReader.getProperty(param);
      if (_graniteConnectionParams == null) {
        _graniteConnectionParams = new Properties();
      }
      _graniteConnectionParams.put(param, value);
    }
  }
}
