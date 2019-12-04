package com.ericsson.stc.c2f_association.graniteService.pojo;

/**
 * Pojo for Site info.
 */
public class ShelfPojo {

  private Long   _equipInstId;
  private String _name;
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
           ", siteInstId=" + _siteInstId +
           '}';
  }
}
