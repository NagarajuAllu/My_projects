package com.ericsson.stc.granitews4eoc.businessTier.pojo;

public class UDAPojo {

  private String udaName;

  private String udaGroup;

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
    return "UDAPojo{" +
           "udaName='" + udaName + '\'' +
           ", udaGroup='" + udaGroup + '\'' +
           ", udaValue='" + udaValue + '\'' +
           '}';
  }
}

