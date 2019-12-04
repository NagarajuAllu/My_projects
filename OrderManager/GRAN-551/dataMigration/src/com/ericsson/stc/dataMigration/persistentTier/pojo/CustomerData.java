package com.ericsson.stc.dataMigration.persistentTier.pojo;

/**
 * Pojo class representing the content of table returned by the query 'dbQueryStringForCustomer'
 */
public class CustomerData {

  private int _id;
  private String _customerRef;
  private String _customerType;
  private String _customerSubType;
  private String _idType;
  private String _idNO;
  private String _segment;
  private String _accountNO;
  private String _serviceNumber;
  private String _sne;
  private String _serviceCode;
  private String _sneStartDt;
  private String _accessNumber;

  public int getId() {
    return _id;
  }

  public void setId(int id) {
    _id = id;
  }

  public String getCustomerRef() {
    return _customerRef;
  }

  public void setCustomerRef(String customerRef) {
    _customerRef = customerRef;
  }

  public String getCustomerType() {
    return _customerType;
  }

  public void setCustomerType(String customerType) {
    _customerType = customerType;
  }

  public String getCustomerSubType() {
    return _customerSubType;
  }

  public void setCustomerSubType(String customerSubType) {
    _customerSubType = customerSubType;
  }

  public String getIdType() {
    return _idType;
  }

  public void setIdType(String idType) {
    _idType = idType;
  }

  public String getIdNO() {
    return _idNO;
  }

  public void setIdNO(String idNO) {
    _idNO = idNO;
  }

  public String getSegment() {
    return _segment;
  }

  public void setSegment(String segment) {
    _segment = segment;
  }

  public String getAccountNO() {
    return _accountNO;
  }

  public void setAccountNO(String accountNO) {
    _accountNO = accountNO;
  }

  public String getServiceNumber() {
    return _serviceNumber;
  }

  public void setServiceNumber(String serviceNumber) {
    _serviceNumber = serviceNumber;
  }

  public String getSne() {
    return _sne;
  }

  public void setSne(String sne) {
    _sne = sne;
  }

  public String getServiceCode() {
    return _serviceCode;
  }

  public void setServiceCode(String serviceCode) {
    _serviceCode = serviceCode;
  }

  public String getSneStartDt() {
    return _sneStartDt;
  }

  public void setSneStartDt(String sneStartDt) {
    _sneStartDt = sneStartDt;
  }

  public String getAccessNumber() {
    return _accessNumber;
  }

  public void setAccessNumber(String accessNumber) {
    _accessNumber = accessNumber;
  }

  @Override
  public String toString() {
    return "CustomerData{" +
           "id=" + _id +
           ", customerRef='" + _customerRef + '\'' +
           ", customerType='" + _customerType + '\'' +
           ", customerSubType='" + _customerSubType + '\'' +
           ", idType='" + _idType + '\'' +
           ", idNO='" + _idNO + '\'' +
           ", segment='" + _segment + '\'' +
           ", accountNO='" + _accountNO + '\'' +
           ", serviceNumber='" + _serviceNumber + '\'' +
           ", sne='" + _sne + '\'' +
           ", serviceCode='" + _serviceCode + '\'' +
           ", sneStartDt='" + _sneStartDt + '\'' +
           ", accessNumber='" + _accessNumber + '\'' +
           '}';
  }
}
