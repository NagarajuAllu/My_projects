package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: changeTaskStatus
 */
public class UDADetailsPojo {

  @XmlElement(required = true, nillable = false)
  private String udaName;

  @XmlElement(required = true, nillable = false)
  private String udaGroup;

  @XmlElement(required = true, nillable = true)
  private String udaValue;

  public String getUdaName() {
    return udaName;
  }

  public void setUdaName(String udaName) {
    this.udaName = udaName;
  }

  public String getUdaGroup() {
    return udaGroup;
  }

  public void setUdaGroup(String udaGroup) {
    this.udaGroup = udaGroup;
  }

  public String getUdaValue() {
    return udaValue;
  }

  public void setUdaValue(String udaValue) {
    this.udaValue = udaValue;
  }

  @Override
  public String toString() {
    return "UDADetailsPojo{" +
           "udaName='" + udaName + '\'' +
           ", udaGroup='" + udaGroup + '\'' +
           ", udaValue='" + udaValue + '\'' +
           '}';
  }
}
