package com.ericsson.stc.orderGeneration.persistentTier.pojo;

/**
 * Pojo class representing the content of table returned by the query 'dbQueryString'
 */
public class ServiceData {

  private String _pathName;
  private String _serviceCustomerNumber;
  private String _accountNumber;
  private String _serviceNumber;
  private String _accessNumber;
  private String _samControlNumber;
  private String _cityCode;
  private String _districtCode;
  private String _description;
  private String _plateId;
  private String _type;
  private String _siteA;
  private String _siteB;
  private String _functionCode;
  private String _computedSiteA;
  private String _computedSiteB;
  private String _orderNumber;

  private String _customerRef;
  private String _customerType;
  private String _customerSubType;
  private String _customerIdType;
  private String _customerIdNO;
  private String _customerSegment;
  private String _customerAccountNO;
  private String _customerServiceNumber;
  private String _customerSne;
  private String _customerServiceCode;
  private String _customerSneStartDt;
  private String _customerAccessNumber;
  private int _customerMigrationResult;

  public String getPathName() {
    return _pathName;
  }

  public void setPathName(String pathName) {
    _pathName = pathName;
  }

  public String getServiceCustomerNumber() {
    return _serviceCustomerNumber;
  }

  public void setServiceCustomerNumber(String serviceCustomerNumber) {
    _serviceCustomerNumber = serviceCustomerNumber;
  }

  public String getAccountNumber() {
    return _accountNumber;
  }

  public void setAccountNumber(String accountNumber) {
    _accountNumber = accountNumber;
  }

  public String getServiceNumber() {
    return _serviceNumber;
  }

  public void setServiceNumber(String serviceNumber) {
    _serviceNumber = serviceNumber;
  }

  public String getAccessNumber() {
    return _accessNumber;
  }

  public void setAccessNumber(String accessNumber) {
    _accessNumber = accessNumber;
  }

  public String getSamControlNumber() {
    return _samControlNumber;
  }

  public void setSamControlNumber(String samControlNumber) {
    _samControlNumber = samControlNumber;
  }

  public String getCityCode() {
    return _cityCode;
  }

  public void setCityCode(String cityCode) {
    _cityCode = cityCode;
  }

  public String getDistrictCode() {
    return _districtCode;
  }

  public void setDistrictCode(String districtCode) {
    _districtCode = districtCode;
  }

  public String getDescription() {
    return _description;
  }

  public void setDescription(String description) {
    _description = description;
  }

  public String getPlateId() {
    return _plateId;
  }

  public void setPlateId(String plateId) {
    _plateId = plateId;
  }

  public String getType() {
    return _type;
  }

  public void setType(String type) {
    _type = type;
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

  public String getFunctionCode() {
    return _functionCode;
  }

  public void setFunctionCode(String functionCode) {
    _functionCode = functionCode;
  }

  public String getComputedSiteA() {
    return _computedSiteA;
  }

  public void setComputedSiteA(String computedSiteA) {
    _computedSiteA = computedSiteA;
  }

  public String getComputedSiteB() {
    return _computedSiteB;
  }

  public void setComputedSiteB(String computedSiteB) {
    _computedSiteB = computedSiteB;
  }

  public String getOrderNumber() {
    return _orderNumber;
  }

  public void setOrderNumber(String orderNumber) {
    _orderNumber = orderNumber;
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

  public String getCustomerIdType() {
    return _customerIdType;
  }

  public void setCustomerIdType(String customerIdType) {
    _customerIdType = customerIdType;
  }

  public String getCustomerIdNO() {
    return _customerIdNO;
  }

  public void setCustomerIdNO(String customerIdNO) {
    _customerIdNO = customerIdNO;
  }

  public String getCustomerSegment() {
    return _customerSegment;
  }

  public void setCustomerSegment(String customerSegment) {
    _customerSegment = customerSegment;
  }

  public String getCustomerAccountNO() {
    return _customerAccountNO;
  }

  public void setCustomerAccountNO(String customerAccountNO) {
    _customerAccountNO = customerAccountNO;
  }

  public String getCustomerServiceNumber() {
    return _customerServiceNumber;
  }

  public void setCustomerServiceNumber(String customerServiceNumber) {
    _customerServiceNumber = customerServiceNumber;
  }

  public String getCustomerSne() {
    return _customerSne;
  }

  public void setCustomerSne(String customerSne) {
    _customerSne = customerSne;
  }

  public String getCustomerServiceCode() {
    return _customerServiceCode;
  }

  public void setCustomerServiceCode(String customerServiceCode) {
    _customerServiceCode = customerServiceCode;
  }

  public String getCustomerSneStartDt() {
    return _customerSneStartDt;
  }

  public void setCustomerSneStartDt(String customerSneStartDt) {
    _customerSneStartDt = customerSneStartDt;
  }

  public String getCustomerAccessNumber() {
    return _customerAccessNumber;
  }

  public void setCustomerAccessNumber(String customerAccessNumber) {
    _customerAccessNumber = customerAccessNumber;
  }

  public int getCustomerMigrationResult() {
    return _customerMigrationResult;
  }

  public void setCustomerMigrationResult(int customerMigrationResult) {
    _customerMigrationResult = customerMigrationResult;
  }

  @Override
  public String toString() {
    return "ServiceData{" +
           "_pathName='" + _pathName + '\'' +
           ", _serviceCustomerNumber='" + _serviceCustomerNumber + '\'' +
           ", _accountNumber='" + _accountNumber + '\'' +
           ", _serviceNumber='" + _serviceNumber + '\'' +
           ", _accessNumber='" + _accessNumber + '\'' +
           ", _samControlNumber='" + _samControlNumber + '\'' +
           ", _cityCode='" + _cityCode + '\'' +
           ", _districtCode='" + _districtCode + '\'' +
           ", _description='" + _description + '\'' +
           ", _plateId='" + _plateId + '\'' +
           ", _type='" + _type + '\'' +
           ", _siteA='" + _siteA + '\'' +
           ", _siteB='" + _siteB + '\'' +
           ", _functionCode='" + _functionCode + '\'' +
           ", _computedSiteA='" + _computedSiteA + '\'' +
           ", _computedSiteB='" + _computedSiteB + '\'' +
           ", _orderNumber='" + _orderNumber + '\'' +
           ", _customerRef='" + _customerRef + '\'' +
           ", _customerType='" + _customerType + '\'' +
           ", _customerSubType='" + _customerSubType + '\'' +
           ", _customerIdType='" + _customerIdType + '\'' +
           ", _customerIdNO='" + _customerIdNO + '\'' +
           ", _customerSegment='" + _customerSegment + '\'' +
           ", _customerAccountNO='" + _customerAccountNO + '\'' +
           ", _customerServiceNumber='" + _customerServiceNumber + '\'' +
           ", _customerSne='" + _customerSne + '\'' +
           ", _customerServiceCode='" + _customerServiceCode + '\'' +
           ", _customerSneStartDt='" + _customerSneStartDt + '\'' +
           ", _customerAccessNumber='" + _customerAccessNumber + '\'' +
           ", _customerMigrationResult=" + _customerMigrationResult +
           '}';
  }


  public String getRemarks() {
    return "MIGRATED FROM ICMS : " +
           (_customerRef != null ? _customerRef : "") + ", " +
           (_customerType != null ? _customerType : "") + ", " +
           (_customerSubType != null ? _customerSubType : "") + ", " +
           (_customerIdType != null ? _customerIdType : "") + ", " +
           (_customerIdNO != null ? _customerIdNO : "") + ", " +
           (_customerSegment != null ? _customerSegment : "") + ", " +
           (_customerAccountNO != null ? _customerAccountNO : "") + ", " +
           (_customerServiceNumber != null ? _customerServiceNumber : "") + ", " +
           (_customerSne != null ? _customerSne : "") + ", " +
           (_customerServiceCode != null ? _customerServiceCode : "") + ", " +
           (_customerSneStartDt != null ? _customerSneStartDt : "") + ", " +
           (_customerAccessNumber != null ? _customerAccessNumber : "") + ", " +
           (_samControlNumber != null ? _samControlNumber : "") + ", " +
           (_cityCode != null ? _cityCode : "") + ", " +
           (_districtCode != null ? _districtCode : "") + ", " +
           (_description != null ? _description : "") + ", " +
           (_plateId != null ? _plateId : "") + ", " +
           (_type != null ? _type : "") + ", " +
           (_siteA != null ? _siteA : "") + ", " +
           (_siteB != null ? _siteB : "") + ", " +
           (_functionCode != null ? _functionCode : "") + ", " +
           (_pathName != null ? _pathName : "");
  }
}
