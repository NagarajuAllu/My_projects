package com.ericsson.stc.c2f_association.graniteService.pojo;

/**
 * Pojo for Site info.
 */
public class SitePojo {

  private Long _siteInstId;
  private String _type;

  public Long getSiteInstId() {
    return _siteInstId;
  }

  public void setSiteInstId(Long siteInstId) {
    _siteInstId = siteInstId;
  }

  public String getType() {
    return _type;
  }

  public void setType(String type) {
    _type = type;
  }

  @Override
  public String toString() {
    return "SitePojo{" +
           " siteInstId=" + _siteInstId +
           ", type='" + _type + '\'' +
           '}';
  }
}
