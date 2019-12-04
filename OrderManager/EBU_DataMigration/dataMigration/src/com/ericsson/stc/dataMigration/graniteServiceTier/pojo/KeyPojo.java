package com.ericsson.stc.dataMigration.graniteServiceTier.pojo;

/**
 * Created by emiorni on 03/05/2018.
 */
public class KeyPojo {
  private Long _instId;
  private String _type;

  public Long getInstId() {
    return _instId;
  }

  public void setInstId(Long instId) {
    _instId = instId;
  }

  public String getType() {
    return _type;
  }

  public void setType(String type) {
    _type = type;
  }

  @Override
  public String toString() {
    return "KeyPojo{" +
           " instId=" + _instId +
           ", type='" + _type + '\'' +
           '}';
  }
}
