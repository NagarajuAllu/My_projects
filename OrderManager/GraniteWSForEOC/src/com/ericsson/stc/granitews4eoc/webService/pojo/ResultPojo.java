package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the result returned by all the methods of the WS
 */
public class ResultPojo {

  @XmlElement(required = true)
  private String result;

  @XmlElement(required = false, nillable = false)
  private String errorCode;

  @XmlElement(required = false, nillable = false)
  private String errorDescription;

  public String getResult() {
    return result;
  }

  public void setResult(String result) {
    this.result = result;
  }

  public String getErrorCode() {
    return errorCode;
  }

  public void setErrorCode(String errorCode) {
    this.errorCode = errorCode;
  }

  public String getErrorDescription() {
    return errorDescription;
  }

  public void setErrorDescription(String errorDescription) {
    this.errorDescription = errorDescription;
  }

  @Override
  public String toString() {
    return "ResultPojo{" +
           "result='" + result + '\'' +
           ", errorCode='" + errorCode + '\'' +
           ", errorDescription='" + errorDescription + '\'' +
           '}';
  }
}