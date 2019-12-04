package com.ericsson.stc.granitews4eoc.businessTier;

import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;

/**
 * The generic interface for the Granite TaskService.
 */
public interface GraniteWOTaskService {

  public KeyPojo changeTaskStatus(long taskInstId, String newStatus, String userId) throws Exception;

  public KeyPojo moveTaskToNewQueue(long taskInstId, String newQueueName, String userId) throws Exception;

  public KeyPojo updateUDAsForWorkOrderByTaskId(long taskInstId, UDAPojo[] udas, String userId) throws Exception;

  public KeyPojo updateUDAsForTask(long taskInstId, UDAPojo[] udas, String userId) throws Exception;

  public KeyPojo updateUDAsForWorkOrder(long workOrderInstId, UDAPojo[] udas, String userId) throws Exception;
}
