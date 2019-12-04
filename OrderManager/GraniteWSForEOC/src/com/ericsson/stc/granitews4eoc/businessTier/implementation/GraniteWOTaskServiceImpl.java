package com.ericsson.stc.granitews4eoc.businessTier.implementation;

import com.ericsson.stc.granitews4eoc.businessTier.GraniteWOTaskService;
import com.ericsson.stc.granitews4eoc.businessTier.Mapper_DTO_To_Pojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.UdaASIList;
import com.granite.asi.dto.clientview.Queue;
import com.granite.asi.dto.clientview.Uda;
import com.granite.asi.dto.clientview.WorkOrder;
import com.granite.asi.dto.clientview.WorkOrderTask;
import com.granite.asi.key.generated.WorkOrderKey;
import com.granite.asi.key.generated.WorkOrderTaskKey;
import com.granite.asi.service.LockService;
import com.granite.asi.service.QueueService;
import com.granite.asi.service.WorkOrderService;
import com.granite.asi.service.WorkOrderTaskService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;



/**
 * To manage all the API related to Task objects.
 */
public class GraniteWOTaskServiceImpl implements GraniteWOTaskService {

  private final Logger _logger = Logger.getLogger(GraniteWOTaskServiceImpl.class);

  public KeyPojo changeTaskStatus(long taskInstId, String newStatus, String userId) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    WorkOrder wo = null;
    WorkOrderTaskKey[] keys = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      WorkOrderTaskService taskService = asiServices.getWOTaskService();

      WorkOrderTask task = getTaskByInstId(taskInstId);
      if(task == null) {
        throw new Exception("Unable to find the task with id: " + taskInstId);
      }

      wo = getWOByInstId(task.getWoInstId());
      if(wo == null) {
        throw new Exception("Unable to find the wo with id: " + task.getWoInstId());
      }

      addUDAForUserId(userId, task);

      keys = new WorkOrderTaskKey[1];
      keys[0] = new WorkOrderTaskKey(taskInstId);

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(wo.getWorkOrderKey());
      isLocked = true;

      taskService.update(task);

      taskService.checkOutTasks(keys);
      taskService.checkInTasks(keys, newStatus);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in changeTaskStatus <" + taskInstId + "," + newStatus + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(wo.getWorkOrderKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking WO with key " + wo.getWorkOrderKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }

  public KeyPojo moveTaskToNewQueue(long taskInstId, String newQueueName, String userId) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    WorkOrder wo = null;
    WorkOrderTaskKey[] keys = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      WorkOrderTaskService taskService = asiServices.getWOTaskService();

      WorkOrderTask task = getTaskByInstId(taskInstId);
      if(task == null) {
        throw new Exception("Unable to find the task with id: " + taskInstId);
      }

      wo = getWOByInstId(task.getWoInstId());
      if(wo == null) {
        throw new Exception("Unable to find the wo with id: " + task.getWoInstId());
      }

      Queue newQueue = getQueueByName(newQueueName);
      if(newQueue == null) {
        throw new Exception("Unable to find the queue with name: " + newQueueName);
      }

      keys = new WorkOrderTaskKey[1];
      keys[0] = new WorkOrderTaskKey(taskInstId);

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(wo.getWorkOrderKey());

      addUDAForUserId(userId, task);

      isLocked = true;

      task.setQueueName(newQueueName);
      task.setQueueInstId(newQueue.getQueueInstId());
      taskService.update(task);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in moveTaskToNewQueue <" + taskInstId + "," + newQueueName + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(wo.getWorkOrderKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking WO with key " + wo.getWorkOrderKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }


  public KeyPojo updateUDAsForWorkOrderByTaskId(long taskInstId, UDAPojo[] udas, String userId) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    WorkOrder wo = null;
    WorkOrderTaskKey[] keys = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      WorkOrderService workOrderService = asiServices.getWorkOrderService();
      WorkOrderTaskService taskService = asiServices.getWOTaskService();

      WorkOrderTask task = getTaskByInstId(taskInstId);
      if(task == null) {
        throw new Exception("Unable to find the task with id: " + taskInstId);
      }

      wo = getWOByInstId(task.getWoInstId());
      if(wo == null) {
        throw new Exception("Unable to find the wo with id: " + task.getWoInstId());
      }

      keys = new WorkOrderTaskKey[1];
      keys[0] = new WorkOrderTaskKey(taskInstId);


      for(UDAPojo uda : udas) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(uda.getUdaGroup());
        newUda.setUdaName(uda.getUdaName());
        newUda.setUdaValue(uda.getUdaValue());

        UdaASIList udaASIList = wo.getUdas();
        udaASIList.add(newUda);
      }
      addUDAForUserId(userId, task);

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(wo.getWorkOrderKey());

      isLocked = true;

      workOrderService.update(wo);
      taskService.update(task);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateUDAsForTask <" + taskInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(wo.getWorkOrderKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking WO with key " + wo.getWorkOrderKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }


  public KeyPojo updateUDAsForTask(long taskInstId, UDAPojo[] udas, String userId) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    WorkOrder wo = null;
    WorkOrderTaskKey[] keys = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      WorkOrderTaskService taskService = asiServices.getWOTaskService();

      WorkOrderTask task = getTaskByInstId(taskInstId);
      if(task == null) {
        throw new Exception("Unable to find the task with id: " + taskInstId);
      }

      wo = getWOByInstId(task.getWoInstId());
      if(wo == null) {
        throw new Exception("Unable to find the wo with id: " + task.getWoInstId());
      }

      keys = new WorkOrderTaskKey[1];
      keys[0] = new WorkOrderTaskKey(taskInstId);


      for(UDAPojo uda : udas) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(uda.getUdaGroup());
        newUda.setUdaName(uda.getUdaName());
        newUda.setUdaValue(uda.getUdaValue());

        UdaASIList udaASIList = task.getUdas();
        udaASIList.add(newUda);
      }
      addUDAForUserId(userId, task);

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(wo.getWorkOrderKey());

      isLocked = true;

      taskService.update(task);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateUDAsForTask <" + taskInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(wo.getWorkOrderKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking WO with key " + wo.getWorkOrderKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }


  public KeyPojo updateUDAsForWorkOrder(long workOrderInstId, UDAPojo[] udas, String userId) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    WorkOrder wo = null;
    WorkOrderKey[] keys = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      WorkOrderService workOrderService = asiServices.getWorkOrderService();

      wo = getWOByInstId(workOrderInstId);
      if(wo == null) {
        throw new Exception("Unable to find the workOrder with id: " + workOrderInstId);
      }

      keys = new WorkOrderKey[1];
      keys[0] = new WorkOrderKey(workOrderInstId);


      for(UDAPojo uda : udas) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(uda.getUdaGroup());
        newUda.setUdaName(uda.getUdaName());
        newUda.setUdaValue(uda.getUdaValue());

        UdaASIList udaASIList = wo.getUdas();
        udaASIList.add(newUda);
      }

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(wo.getWorkOrderKey());

      isLocked = true;

      workOrderService.update(wo);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateUDAsForWorkOrder <" + workOrderInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(wo.getWorkOrderKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking WO with key " + wo.getWorkOrderKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }


  private WorkOrderTask getTaskByInstId(long taskInstId) throws Exception {
    WorkOrderTask foundTask;

    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderTaskService taskService = asiServices.getWOTaskService();

    foundTask = (WorkOrderTask) taskService.get(new WorkOrderTaskKey(taskInstId));

    return foundTask;
  }

  private WorkOrder getWOByInstId(long woInstId) throws Exception {
    WorkOrder foundWO;

    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderService workOrderService = asiServices.getWorkOrderService();

    foundWO = (WorkOrder) workOrderService.get(new WorkOrderKey(woInstId));

    return foundWO;
  }

  private Queue getQueueByName(String queueName) throws Exception {
    Queue foundQueue = null;
    AsiServices asiServices = AsiServices.getInstance();
    QueueService workOrderService = asiServices.getQueueService();

    Queue queue = asiServices.getNewQueue();
    queue.setQueueName(queueName);

    Query query = new Query();
    query.addQueryEntry(queue);

    DataObject[] queryResult = workOrderService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      if(queryResult.length > 1) {
        throw new Exception("Too many queue with name " + queueName + " found: " + queryResult.length);
      }
      foundQueue = (Queue)queryResult[0];
    }

    return foundQueue;
  }

  private void addUDAForUserId(String userId, WorkOrderTask task) throws Exception {
    addUDAToTask("Task Info", "FO Last User", userId, task);
  }

  private void addUDAToTask(String groupName, String udaName, String udaValue, WorkOrderTask task) throws Exception {
    AsiServices asiServices = AsiServices.getInstance();
    Uda newUda = asiServices.getNewUda();
    newUda.setGroupName(groupName);
    newUda.setUdaName(udaName);
    newUda.setUdaValue(udaValue);

    UdaASIList udaASIList = task.getUdas();
    udaASIList.add(newUda);
  }
}
