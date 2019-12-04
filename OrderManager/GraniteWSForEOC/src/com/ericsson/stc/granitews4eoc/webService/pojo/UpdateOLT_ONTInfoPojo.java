package com.ericsson.stc.granitews4eoc.webService.pojo;


import javax.xml.bind.annotation.XmlElement;

/**
 * This is the input parameter for the method: updateOLT_ONTInfo
 */
public class UpdateOLT_ONTInfoPojo {

  @XmlElement(required = true, nillable = false)
  private UpdateOLTInfoPojo updateOLTInfoPojo;

  @XmlElement(required = true, nillable = false)
  private UpdateONTInfoPojo updateONTInfoPojo;

  public UpdateOLTInfoPojo getUpdateOLTInfoPojo() {
    return updateOLTInfoPojo;
  }

  public void setUpdateOLTInfoPojo(UpdateOLTInfoPojo updateOLTInfoPojo) {
    this.updateOLTInfoPojo = updateOLTInfoPojo;
  }

  public UpdateONTInfoPojo getUpdateONTInfoPojo() {
    return updateONTInfoPojo;
  }

  public void setUpdateONTInfoPojo(UpdateONTInfoPojo updateONTInfoPojo) {
    this.updateONTInfoPojo = updateONTInfoPojo;
  }

  @Override
  public String toString() {
    return "UpdateOLT_ONTInfoPojo{" +
           "updateOLTInfoPojo=" + updateOLTInfoPojo +
           ", updateONTInfoPojo=" + updateONTInfoPojo +
           '}';
  }
}
