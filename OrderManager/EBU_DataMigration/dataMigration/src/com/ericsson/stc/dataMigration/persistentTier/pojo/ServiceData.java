package com.ericsson.stc.dataMigration.persistentTier.pojo;

/**
 * Pojo class representing the content of table returned by the query 'dbQueryStringForService'
 */
public class ServiceData {

  private String _pathName;
  private String _customerNumber;
  private String _accountNumber;
  private String _accessNumber;
  private String _circuitCategory;
  private String _siteA;
  private String _siteB;
  private String _bandwidth;
  private String _functionCode;
  private String _orderNumber;

  private String _rtnSpeed;
  private String _msIsdn;
  private String _simNumber;
  private String _mvpnAccessType;
  private String _mvpnSpeed;

  public String getPathName() {
    return _pathName;
  }

  public void setPathName(String pathName) {
    _pathName = pathName;
  }

  public String getCustomerNumber() {
    return _customerNumber;
  }

  public void setCustomerNumber(String customerNumber) {
    _customerNumber = customerNumber;
  }

  public String getAccountNumber() {
    return _accountNumber;
  }

  public void setAccountNumber(String accountNumber) {
    _accountNumber = accountNumber;
  }

  public String getAccessNumber() {
    return _accessNumber;
  }

  public void setAccessNumber(String accessNumber) {
    _accessNumber = accessNumber;
  }

  public String getCircuitCategory() {
    return _circuitCategory;
  }

  public void setCircuitCategory(String circuitCategory) {
    _circuitCategory = circuitCategory;
  }

  public String getSiteA() {
    return _siteA;
  }

  public void setSiteA(String siteA) {
    _siteA = siteA;
  }

  public String getSiteB() {
    return _siteB;
  }

  public void setSiteB(String siteB) {
    _siteB = siteB;
  }

  public String getBandwidth() {
    return _bandwidth;
  }

  public void setBandwidth(String bandwidth) {
    _bandwidth = bandwidth;
  }

  public String getFunctionCode() {
    return _functionCode;
  }

  public void setFunctionCode(String functionCode) {
    _functionCode = functionCode;
  }

  public String getOrderNumber() {
    return _orderNumber;
  }

  public void setOrderNumber(String orderNumber) {
    _orderNumber = orderNumber;
  }

  public String getRtnSpeed() {
    return _rtnSpeed;
  }

  public void setRtnSpeed(String rtnSpeed) {
    _rtnSpeed = rtnSpeed;
  }

  public String getMsIsdn() {
    return _msIsdn;
  }

  public void setMsIsdn(String msIsdn) {
    _msIsdn = msIsdn;
  }

  public String getSimNumber() {
    return _simNumber;
  }

  public void setSimNumber(String simNumber) {
    _simNumber = simNumber;
  }

  public String getMvpnAccessType() {
    return _mvpnAccessType;
  }

  public void setMvpnAccessType(String mvpnAccessType) {
    _mvpnAccessType = mvpnAccessType;
  }

  public String getMvpnSpeed() {
    return _mvpnSpeed;
  }

  public void setMvpnSpeed(String mvpnSpeed) {
    _mvpnSpeed = mvpnSpeed;
  }

  @Override
  public String toString() {
    return "ServiceData{" +
           "_pathName='" + _pathName + '\'' +
           ", _customerNumber='" + _customerNumber + '\'' +
           ", _accountNumber='" + _accountNumber + '\'' +
           ", _accessNumber='" + _accessNumber + '\'' +
           ", _circuitCategory='" + _circuitCategory + '\'' +
           ", _siteA='" + _siteA + '\'' +
           ", _siteB='" + _siteB + '\'' +
           ", _bandwidth='" + _bandwidth + '\'' +
           ", _functionCode='" + _functionCode + '\'' +
           ", _orderNumber='" + _orderNumber + '\'' +
           ", _rtnSpeed='" + _rtnSpeed + '\'' +
           ", _msIsdn='" + _msIsdn + '\'' +
           ", _simNumber='" + _simNumber + '\'' +
           ", _mvpnAccessType ='" + _mvpnAccessType + '\'' +
           ", _mvpnSpeed='" + _mvpnSpeed + '\'' +
           '}';
  }
}
