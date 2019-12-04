package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;
import java.util.Arrays;

/**
 * This is the input parameter for the method: updateOLT_ONTInfo
 */
public class UpdateONTInfoPojo {

  @XmlElement(required = true, nillable = false)
  private int equipInstId;

  @XmlElement(required = true, nillable = false)
  private String serialNo;

  @XmlElement(required = true, nillable = false)
  private int taskInstId;

  @XmlElement(required = true, nillable = false)
  private String userId;

  @XmlElement(required = true, nillable = false)
  private UDADetailsPojo[] udaDetailsPojos;

  public int getEquipInstId() {
    return equipInstId;
  }

  public void setEquipInstId(int equipInstId) {
    this.equipInstId = equipInstId;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public int getTaskInstId() {
    return taskInstId;
  }

  public void setTaskInstId(int taskInstId) {
    this.taskInstId = taskInstId;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public UDADetailsPojo[] getUdaDetailsPojos() {
    return udaDetailsPojos;
  }

  public void setUdaDetailsPojos(UDADetailsPojo[] udaDetailsPojos) {
    this.udaDetailsPojos = udaDetailsPojos;
  }

  @Override
  public String toString() {
    return "UpdateOLTInfoPojo{" +
           ", equipInstId=" + equipInstId +
           ", serialNumber=" + serialNo +
           ", taskInstId=" + taskInstId +
           ", userId=" + userId +
           ", udaDetailsPojo=" + Arrays.toString(udaDetailsPojos) +
           '}';
  }
}
