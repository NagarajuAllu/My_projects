package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: moveTaskToNewQueue
 */
public class MoveTaskToNewQueuePojo {

  @XmlElement(required = true, nillable = false)
  private int taskInstId;

  @XmlElement(required = true, nillable = false)
  private String newQueueName;

  @XmlElement(required = true, nillable = false)
  private String userId;

  public int getTaskInstId() {
    return taskInstId;
  }

  public void setTaskInstId(int taskInstId) {
    this.taskInstId = taskInstId;
  }

  public String getNewQueueName() {
    return newQueueName;
  }

  public void setNewQueueName(String newQueueName) {
    this.newQueueName = newQueueName;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  @Override
  public String toString() {
    return "MoveTaskToNewQueuePojo{" +
           "taskInstId=" + taskInstId +
           ", newQueueName='" + newQueueName + '\'' +
           ", userId=" + userId +
           '}';
  }
}
