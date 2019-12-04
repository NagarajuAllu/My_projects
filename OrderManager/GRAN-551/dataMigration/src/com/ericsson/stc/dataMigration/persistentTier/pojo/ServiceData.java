package com.ericsson.stc.dataMigration.persistentTier.pojo;

/**
 * Pojo class representing the content of table returned by the query 'dbQueryStringForService'
 */
public class ServiceData {

  private String _pathName;
  private String _orderNumber;

  public String getPathName() {
    return _pathName;
  }

  public void setPathName(String pathName) {
    _pathName = pathName;
  }

  public String getOrderNumber() {
    return _orderNumber;
  }

  public void setOrderNumber(String orderNumber) {
    _orderNumber = orderNumber;
  }

  @Override
  public String toString() {
    return "ServiceData{" +
           " pathName='" + _pathName + '\'' +
           ", orderNumber='" + _orderNumber + '\'' +
           '}';
  }
}
