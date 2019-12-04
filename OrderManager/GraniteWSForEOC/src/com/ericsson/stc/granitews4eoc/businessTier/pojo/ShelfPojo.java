package com.ericsson.stc.granitews4eoc.businessTier.pojo;

/**
 * Pojo for Site info.
 */
public class ShelfPojo {

  private Long   _equipInstId;
  private String _name;
  private String _type;
  private String _status;
  private Long   _siteInstId;

  public Long getEquipInstId() {
    return _equipInstId;
  }

  public void setEquipInstId(Long equipInstId) {
    _equipInstId = equipInstId;
  }

  public String getName() {
    return _name;
  }

  public void setName(String shelfName) {
    _name = shelfName;
  }

  public String getType() {
    return _type;
  }

  public void setType(String type) {
    _type = type;
  }

  public String getStatus() {
    return _status;
  }

  public void setStatus(String status) {
    _status = status;
  }

  public Long getSiteInstId() {
    return _siteInstId;
  }

  public void setSiteInstId(Long siteInstId) {
    _siteInstId = siteInstId;
  }

  @Override
  public String toString() {
    return "ShelfPojo{" +
           " shelfInstId=" + _equipInstId +
           ", shelfName='" + _name + '\'' +
           ", type='" + _type + '\'' +
           ", status='" + _status + '\'' +
           ", siteInstId=" + _siteInstId +
           '}';
  }
}
