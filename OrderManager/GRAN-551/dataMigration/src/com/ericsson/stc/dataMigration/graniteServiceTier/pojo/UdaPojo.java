package com.ericsson.stc.dataMigration.graniteServiceTier.pojo;

/**
 * Created by emiorni on 03/05/2018.
 */
public class UdaPojo {
  private String _udaGroup;
  private String _udaName;
  private String _udaValue;

  public UdaPojo(String udaGroup, String udaName, String udaValue) {
    _udaGroup = udaGroup;
    _udaName = udaName;
    _udaValue = udaValue;
  }

  public String getUdaGroup() {
    return _udaGroup;
  }

  public void setUdaGroup(String udaGroup) {
    _udaGroup = udaGroup;
  }

  public String getUdaName() {
    return _udaName;
  }

  public void setUdaName(String udaName) {
    _udaName = udaName;
  }

  public String getUdaValue() {
    return _udaValue;
  }

  public void setUdaValue(String udaValue) {
    _udaValue = udaValue;
  }

  @Override
  public String toString() {
    return "UdaPojo{" +
           " udaGroup='" + _udaGroup + '\'' +
           ", udaName='" + _udaName + '\'' +
           ", udaValue='" + _udaValue + '\'' +
           '}';
  }
}
