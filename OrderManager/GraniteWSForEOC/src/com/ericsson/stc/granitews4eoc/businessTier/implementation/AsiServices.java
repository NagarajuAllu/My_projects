package com.ericsson.stc.granitews4eoc.businessTier.implementation;

import com.ericsson.stc.granitews4eoc.utility.PropertyReader;
import com.granite.asi.dto.clientview.*;
import com.granite.asi.exception.ShutdownException;
import com.granite.asi.factory.ASIFactory;
import com.granite.asi.factory.DataObjectFactory;
import com.granite.asi.factory.ServiceFactory;
import com.granite.asi.service.*;
import com.granite.asi.util.*;
import org.apache.log4j.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.transaction.UserTransaction;
import java.io.Serializable;
import java.util.Properties;

/**
 * To manage ASI startup/shutdown and to object the services
 */
public class AsiServices implements Serializable {

  private static final long serialVersionUID = 4541479299193638994L;

  private Logger _log = Logger.getLogger(AsiServices.class);

  /**
   * The unique instance of this class.
   */
  private static AsiServices _instance;

  private Properties _graniteConnectionParams   = null;

  private DataObjectFactory _dataObjectFactory  = null;
  private ServiceFactory    _serviceFactory     = null;
  private int               _transactionTimeOut = 60;
  private boolean           _useTransaction     = true;

  private AsiServices() {
    loadGraniteConnectionParams();

    loadTransactionParameters();
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
      _log.info("\n asiStartup() --------> : [ASI Factory starting] :"+ _graniteConnectionParams.toString());
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

  public UserTransaction getUserTransaction() throws Exception {
    UserTransaction ut = null;
    if(_useTransaction) {
      try {
        Context ctx = new InitialContext(_graniteConnectionParams);
        ut = (UserTransaction) ctx.lookup("javax/transaction/UserTransaction");
        ut.setTransactionTimeout(_transactionTimeOut);
      }
      catch (Exception exc) {
        _log.error("Unexpected error while creating the UserTransaction", exc);
        throw new Exception("Unexpected error while creating the UserTransaction", exc);
      }
    }

    return ut;
  }

  public ShelfService getShelfService() throws Exception {
    return (ShelfService) _serviceFactory.newService(CoreServices.SHELF);
  }

  public PortService getPortService() throws Exception {
    return (PortService) _serviceFactory.newService(CoreServices.PORT);
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

  public QueueService getQueueService() throws Exception {
    return (QueueService) _serviceFactory.newService(WorxServices.QUEUE);
  }

  public Shelf getNewShelf() throws Exception {
    return (Shelf)_dataObjectFactory.newDataObject(CoreDataObjects.SHELF);
  }

  public Port getNewPort() throws Exception {
    return (Port)_dataObjectFactory.newDataObject(CoreDataObjects.PORT);
  }

  public Uda getNewUda() throws Exception {
      return (Uda)_dataObjectFactory.newDataObject(CoreDataObjects.UDA);
  }

  public WorkOrder getNewWorkOrder() throws Exception {
    return (WorkOrder)_dataObjectFactory.newDataObject(WorxDataObjects.WORKORDER);
  }

  public WorkOrderTask getNewWorkOrderTask() throws Exception {
    return (WorkOrderTask)_dataObjectFactory.newDataObject(WorxDataObjects.WORKORDERTASK);
  }

  public Queue getNewQueue() throws Exception {
    return (Queue)_dataObjectFactory.newDataObject(WorxDataObjects.QUEUE);
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

  private void loadTransactionParameters() {
    PropertyReader propertyReader = PropertyReader.getInstance();
    _transactionTimeOut = Integer.valueOf(propertyReader.getProperty("transactionTimeout", "60"));
    String useTransationValue = propertyReader.getProperty("useTransaction", "N");
    _useTransaction = useTransationValue.equals("Y");

    _log.info("transactionTimeout: " + _transactionTimeOut);
    _log.info("useTransaction: " + _useTransaction);
  }
}
