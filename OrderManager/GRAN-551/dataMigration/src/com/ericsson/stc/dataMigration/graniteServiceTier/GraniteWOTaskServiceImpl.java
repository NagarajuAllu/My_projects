package com.ericsson.stc.dataMigration.graniteServiceTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.granite.asi.dto.ASIList;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.clientview.WorkOrder;
import com.granite.asi.dto.clientview.WorkOrderTask;
import com.granite.asi.dto.generated.clientview.WorkOrderStatus;
import com.granite.asi.key.generated.WorkOrderKey;
import com.granite.asi.key.generated.WorkOrderTaskKey;
import com.granite.asi.service.LockService;
import com.granite.asi.service.WorkOrderService;
import com.granite.asi.service.WorkOrderTaskService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;

import java.util.ArrayList;

/**
 * To manage all the API related to Task objects.
 */
public class GraniteWOTaskServiceImpl {

  private final Logger _log = Logger.getLogger(getClass());

  public KeyPojo completeTask(long taskInstId) throws Exception {
    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderTaskService taskService = asiServices.getWOTaskService();

    WorkOrderTask task = getTaskByInstId(taskInstId);
    WorkOrder wo = getWOByInstId(task.getWoInstId());

    WorkOrderTaskKey[] keys = new WorkOrderTaskKey[1];
    keys[0] = new WorkOrderTaskKey(taskInstId);

    LockService lockService = asiServices.getLockService();
    lockService.lock(wo.getWorkOrderKey());

    taskService.checkOutTasks(keys);
    taskService.checkInTasks(keys, WorkOrderStatus.COMPLETE.toString());

    lockService.unlock(wo.getWorkOrderKey());

    return Mapper_DTO_To_Pojo.mapToKeyPojo(keys[0]);
  }

  public KeyPojo completeAllTasksInWO(String woName) throws Exception {
    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderTaskService workOrderTaskService = asiServices.getWOTaskService();

    // search WO
    WorkOrder wo = getWOByName(woName);
    ASIList allTasks = wo.getTasks();

    ArrayList<WorkOrderTaskKey> keys = null;

    for(int i=0; i<allTasks.size(); i++) {
      WorkOrderTask task = (WorkOrderTask)allTasks.get(i);

      if(! task.getStatusCode().equals(WorkOrderStatus.COMPLETE.toString())) {
        if(keys == null) {
          keys = new ArrayList<>();
        }
        keys.add(new WorkOrderTaskKey(task.getTaskInstId()));
      }
    }

    if(keys != null) {
      WorkOrderTaskKey[] woTaskKeys = new WorkOrderTaskKey[keys.size()];
      keys.toArray(woTaskKeys);

      LockService lockService = asiServices.getLockService();
      lockService.lock(wo.getWorkOrderKey());

      workOrderTaskService.checkOutTasks(woTaskKeys);
      workOrderTaskService.checkInTasks(woTaskKeys, WorkOrderStatus.COMPLETE.toString());

      lockService.unlock(wo.getWorkOrderKey());
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(wo.getWorkOrderKey());
  }

  private WorkOrderTask getTaskByInstId(long taskInstId) throws Exception {
    WorkOrderTask foundTask = null;

    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderTaskService taskService = asiServices.getWOTaskService();

    foundTask = (WorkOrderTask) taskService.get(new WorkOrderTaskKey(taskInstId));

    return foundTask;
  }

  private WorkOrder getWOByInstId(long woInstId) throws Exception {
    WorkOrder foundWO = null;

    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderService workOrderService = asiServices.getWorkOrderService();

    foundWO = (WorkOrder) workOrderService.get(new WorkOrderKey(woInstId));

    return foundWO;
  }

  private WorkOrder getWOByName(String woName) throws Exception {
    WorkOrder foundWO = null;

    AsiServices asiServices = AsiServices.getInstance();
    WorkOrderService workOrderService = asiServices.getWorkOrderService();

    WorkOrder workOrder = asiServices.getNewWorkOrder();
    workOrder.setWildName(false);
    workOrder.setName(woName);

    Query query = new Query();
    query.addQueryEntry(workOrder);

    DataObject[] queryResult = workOrderService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      if(queryResult.length > 1) {
        _log.error("Too many wo with name " + woName + " found: " + queryResult.length);
        throw new Exception("Too many wo with name " + woName + " found: " + queryResult.length);
      }
      foundWO = getWOByInstId(((WorkOrder)queryResult[0]).getWoInstId());
    }
    else {
      _log.info("Unable to wo with name " + woName);
    }

    return foundWO;
  }


}
