package com.ericsson.stc.granitews4eoc.utility;

import com.granite.asi.dto.generated.clientview.WorkOrderStatus;

import javax.resource.spi.work.Work;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;

public class WoTaskStatusMgmt {

  private HashMap<Integer, String> _woTaskStatus = new HashMap<>();

  public WoTaskStatusMgmt() {
    _woTaskStatus.put(1, WorkOrderStatus.NEW.toString());
    _woTaskStatus.put(3, WorkOrderStatus.CANCELLING.toString());
    _woTaskStatus.put(4, WorkOrderStatus.READY.toString());
    _woTaskStatus.put(5, WorkOrderStatus.INPROCESS.toString());
    _woTaskStatus.put(6, WorkOrderStatus.ON_HOLD.toString());
    _woTaskStatus.put(7, WorkOrderStatus.COMPLETE.toString());
    _woTaskStatus.put(8, WorkOrderStatus.CANCELLED.toString());
    _woTaskStatus.put(9, WorkOrderStatus.FAILED.toString());
  }

  public String getNameForCode(int code) {
    return _woTaskStatus.get(code);
  }

  public int getCodeForName(String status) {
    int code = -1;

    if(_woTaskStatus.containsValue(status)) {
      Iterator<Integer> keyIter = _woTaskStatus.keySet().iterator();
      while(keyIter.hasNext() && code == -1) {
        Integer key = keyIter.next();
        String valueFound = _woTaskStatus.get(key);
        if (valueFound.equals(status)) {
          code = key;
        }
      }
    }
    return code;
  }
}
