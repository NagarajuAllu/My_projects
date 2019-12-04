package com.ericsson.stc.granitews4eoc.webService.pojo;

import javax.xml.bind.annotation.XmlElement;
import java.util.Arrays;

/**
 * This is the input parameter for the method: updateOLT_ONTInfo
 */
public class UpdateOLTInfoPojo {

  @XmlElement(required = true, nillable = false)
  private int portInstId;

  @XmlElement(required = true, nillable = false)
  private int equipInstId;

  @XmlElement(required = true, nillable = false)
  private UDADetailsPojo[] udaDetailsPojos;


  public int getPortInstId() {
    return portInstId;
  }

  public void setPortInstId(int portInstId) {
    this.portInstId = portInstId;
  }

  public int getEquipInstId() {
    return equipInstId;
  }

  public void setEquipInstId(int equipInstId) {
    this.equipInstId = equipInstId;
  }

  public UDADetailsPojo[] getUdaDetailsPojos() {
    return udaDetailsPojos;
  }

  public void setUdaDetailsPojos(UDADetailsPojo[] udaDetailsPojos) {
    this.udaDetailsPojos = udaDetailsPojos;
  }

  @Override
  public String toString() {
    return "UpdateOLTInfoPojo{" +
           "portInstId=" + portInstId +
           ", equipInstId=" + equipInstId +
           ", udaDetailsPojos=" + Arrays.toString(udaDetailsPojos) +
           '}';
  }
}
