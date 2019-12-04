package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: changeTaskStatus
 */
public class ChangeTaskStatusPojo {

  @XmlElement(required = true, nillable = false)
  private int taskInstId;

  @XmlElement(required = true, nillable = false)
  private int newStatusCode;

  @XmlElement(required = true, nillable = false)
  private String userId;

  public int getTaskInstId() {
    return taskInstId;
  }

  public void setTaskInstId(int taskInstId) {
    this.taskInstId = taskInstId;
  }

  public int getNewStatusCode() {
    return newStatusCode;
  }

  public void setNewStatusCode(int newStatusCode) {
    this.newStatusCode = newStatusCode;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  @Override
  public String toString() {
    return "ChangeTaskStatusPojo{" +
           "taskInstId=" + taskInstId +
           ", newStatusCode=" + newStatusCode +
           ", userId=" + userId +
           '}';
  }
}
