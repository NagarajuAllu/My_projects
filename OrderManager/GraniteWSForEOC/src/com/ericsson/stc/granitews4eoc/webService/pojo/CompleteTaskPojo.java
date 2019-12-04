package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: completeTask
 */
public class CompleteTaskPojo {

  @XmlElement(required = true, nillable = false)
  private int taskInstId;

  @XmlElement(required = true, nillable = false)
  private String userId;

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

  @Override
  public String toString() {
    return "ChangeTaskStatusPojo{" +
           "taskInstId=" + taskInstId +
           ", userId=" + userId +
           '}';
  }
}
