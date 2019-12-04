package com.ericsson.stc.granitews4eoc.businessTier.implementation;

import com.ericsson.stc.granitews4eoc.businessTier.*;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;
import com.ericsson.stc.granitews4eoc.utility.WoTaskStatusMgmt;
import org.apache.log4j.Logger;

import javax.transaction.UserTransaction;
import java.util.Arrays;

public class GraniteServiceImpl implements GraniteService {

  private final Logger _logger = Logger.getLogger(GraniteServiceImpl.class);

  public void startupASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiStartup();
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in starting up the ASI Factory", exc);
      throw exc;
    }
  }

  public UserTransaction getUserTransaction() throws Exception {
    UserTransaction userTransaction;

    try {
      AsiServices asiServices= AsiServices.getInstance();
      userTransaction = asiServices.getUserTransaction();
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in getting the UserTransaction", exc);
      throw exc;
    }
    return userTransaction;
  }

  public KeyPojo changeTaskStatus(long taskInstId, String newStatus, String userId) throws Exception {
    Exception foundException = null;
    KeyPojo taskKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();
      taskKeyPojo = graniteWOTaskService.changeTaskStatus(taskInstId, newStatus, userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing changeTaskStatus(" + taskInstId + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return taskKeyPojo;
  }

  public KeyPojo completeBlockedTask(long sourceTaskInstId, long blockingTaskInstId,
                                     String newQueueName, String userId) throws Exception {
    Exception foundException = null;
    KeyPojo taskKeyPojo = null;

    UserTransaction userTransaction = null;

    String step = null;
    long taskId = -1;
    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      WoTaskStatusMgmt woTaskStatusMgmt = new WoTaskStatusMgmt();
      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();

      step = "Move Task To New Queue";
      taskId = sourceTaskInstId;
      taskKeyPojo = graniteWOTaskService.moveTaskToNewQueue(sourceTaskInstId, newQueueName, userId);

      step = "CompleteTask";
      taskId = blockingTaskInstId;
      taskKeyPojo = graniteWOTaskService.changeTaskStatus(blockingTaskInstId, woTaskStatusMgmt.getNameForCode(7), userId);

      step = "CompleteTask";
      taskId = sourceTaskInstId;
      taskKeyPojo = graniteWOTaskService.changeTaskStatus(sourceTaskInstId, woTaskStatusMgmt.getNameForCode(7), userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing " + step + "(" + taskId + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return taskKeyPojo;
  }

  public KeyPojo moveTaskToNewQueue(long taskInstId, String newQueueName, String userId) throws Exception {
    Exception foundException = null;
    KeyPojo taskKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();

      taskKeyPojo = graniteWOTaskService.moveTaskToNewQueue(taskInstId, newQueueName, userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing movingTaskToNewQueue(" + taskInstId + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return taskKeyPojo;
  }

  public KeyPojo updateOLTInfo(long portInstId, long equipInstId, UDAPojo[] udas) throws Exception {
    Exception foundException = null;
    KeyPojo taskKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteShelfService graniteShelfService = new GraniteShelfServiceImpl();

      taskKeyPojo = graniteShelfService.updateUDAsForPort(portInstId, equipInstId, udas);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing updateOLTInfo(" + portInstId + "," +
                    equipInstId + "," + Arrays.toString(udas) + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return taskKeyPojo;
  }

  public KeyPojo updateONTInfo(long equipInstId, String serialNumber,
                               long taskInstId, String userId,
                               UDAPojo[] udas) throws Exception {
    Exception foundException = null;
    KeyPojo equipKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteShelfService graniteShelfService = new GraniteShelfServiceImpl();

      equipKeyPojo = graniteShelfService.updateSerialNumberForShelf(equipInstId, serialNumber);
      equipKeyPojo = graniteShelfService.updateUDAsForShelf(equipInstId, udas);

      UDAPojo[] udaPojos = new UDAPojo[1];
      udaPojos[0] = new UDAPojo();
      udaPojos[0].setUdaName("ONT Serial Number");
      udaPojos[0].setUdaGroup("WBU STC/OLO Order Info");
      udaPojos[0].setUdaValue(serialNumber);

      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();
      graniteWOTaskService.updateUDAsForWorkOrderByTaskId(taskInstId, udaPojos, userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing updateONTInfo(" + equipInstId + "," +
                    serialNumber + "," + Arrays.toString(udas) + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return equipKeyPojo;
  }

  public KeyPojo updateUDAsForTask(long taskInstId, UDAPojo[] udaPojos, String userId) throws Exception {
    Exception foundException = null;
    KeyPojo taskKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();

      taskKeyPojo = graniteWOTaskService.updateUDAsForTask(taskInstId, udaPojos, userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing updateUDAsForTask  (" + taskInstId + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return taskKeyPojo;
  }

  public KeyPojo updateUDAsForWorkOrder(long workOrderInstId, UDAPojo[] udaPojos, String userId) throws Exception {
    Exception foundException = null;
    KeyPojo woKeyPojo = null;

    UserTransaction userTransaction = null;

    try {
      userTransaction = getUserTransaction();
      if(userTransaction != null) {
        userTransaction.begin();
      }

      GraniteWOTaskService graniteWOTaskService = new GraniteWOTaskServiceImpl();

      woKeyPojo = graniteWOTaskService.updateUDAsForWorkOrder(workOrderInstId, udaPojos, userId);

      if(userTransaction != null) {
        userTransaction.commit();
      }
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in executing updateUDAsForWorkOrder  (" + workOrderInstId + ")", exc);
      foundException = exc;

      try {
        if (userTransaction != null) {
          userTransaction.rollback();
        }
      }
      catch(Throwable t) {
        _logger.error("Unexpected error while rolling back user transaction - but ignored!", t);
      }
    }

    if (foundException != null) {
      throw foundException;
    }

    return woKeyPojo;
  }

  public void shutdownASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiShutdown();
    }
    catch (Exception exc) {
      _logger.error("Unexpected error in shutting down the ASI Factory", exc);
      throw exc;
    }
  }

}
