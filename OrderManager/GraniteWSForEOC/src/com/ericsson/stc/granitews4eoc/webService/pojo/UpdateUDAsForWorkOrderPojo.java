package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;
import java.util.Arrays;

/**
 * This is the input parameter for the method: updateUDAsForWorkOrder
 */
public class UpdateUDAsForWorkOrderPojo {

  @XmlElement(required = true, nillable = false)
  private int workOrderInstId;

  @XmlElement(required = true, nillable = false)
  private UDADetailsPojo[] udaDetailsPojos;

  @XmlElement(required = true, nillable = false)
  private String userId;

  public int getWorkOrderInstId() {
    return workOrderInstId;
  }

  public void setWorkOrderInstId(int workOrderInstId) {
    this.workOrderInstId = workOrderInstId;
  }

  public UDADetailsPojo[] getUdaDetailsPojos() {
    return udaDetailsPojos;
  }

  public void setUdaDetailsPojos(UDADetailsPojo[] udaDetailsPojos) {
    this.udaDetailsPojos = udaDetailsPojos;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  @Override
  public String toString() {
    return "UpdateUDAsForWorkOrderPojo{" +
           "workOrderInstId=" + workOrderInstId +
           ", udaDetailsPojo=" + Arrays.toString(udaDetailsPojos) +
           ", userId=" + userId +
           '}';
  }
}
