package com.ericsson.stc.granitews4eoc.businessTier;


import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;

import javax.transaction.UserTransaction;
import java.util.ArrayList;

public interface GraniteService {

  public void startupASIFactory() throws Exception;

  public UserTransaction getUserTransaction() throws Exception;

  public KeyPojo changeTaskStatus(long taskInstId, String newStatus, String userId) throws Exception;

  public KeyPojo completeBlockedTask(long sourceTaskInstId, long blockingTaskInstId,
                                     String newQueueName, String userId) throws Exception;

  public KeyPojo moveTaskToNewQueue(long taskInstId, String newQueueName, String userId) throws Exception;

  public KeyPojo updateOLTInfo(long portInstId, long equipInstId, UDAPojo[] udas) throws Exception;

  public KeyPojo updateONTInfo(long equipInstId, String serialNumber,
                               long taskInstId, String userId,
                               UDAPojo[] udas) throws Exception;

  public KeyPojo updateUDAsForTask(long taskInstId, UDAPojo[] udaPojos, String userId) throws Exception;

  public KeyPojo updateUDAsForWorkOrder(long workOrderInstId, UDAPojo[] udaPojos, String userId) throws Exception;

  public void shutdownASIFactory() throws Exception;

}

