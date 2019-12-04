package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: completeBlockedTask
 */
public class CompleteBlockedTaskPojo {

  @XmlElement(required = true, nillable = false)
  private int sourceTaskInstId;

  @XmlElement(required = true, nillable = false)
  private String newQueueName;

  @XmlElement(required = true, nillable = false)
  private int blockingTaskInstId;

  @XmlElement(required = true, nillable = false)
  private String userId;

  public int getSourceTaskInstId() {
    return sourceTaskInstId;
  }

  public void setSourceTaskInstId(int sourceTaskInstId) {
    this.sourceTaskInstId = sourceTaskInstId;
  }

  public String getNewQueueName() {
    return newQueueName;
  }

  public void setNewQueueName(String newQueueName) {
    this.newQueueName = newQueueName;
  }

  public int getBlockingTaskInstId() {
    return blockingTaskInstId;
  }

  public void setBlockingTaskInstId(int blockingTaskInstId) {
    this.blockingTaskInstId = blockingTaskInstId;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  @Override
  public String toString() {
    return "CompleteBlockedTaskPojo{" +
           "sourceTaskInstId=" + sourceTaskInstId +
           ", newQueueName='" + newQueueName + '\'' +
           ", blockingTaskInstId=" + blockingTaskInstId +
           ", userId=" + userId +
           '}';
  }
}
