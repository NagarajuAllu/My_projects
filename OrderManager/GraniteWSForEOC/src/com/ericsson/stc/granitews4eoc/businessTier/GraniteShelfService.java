package com.ericsson.stc.granitews4eoc.businessTier;

import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;

/**
 * The generic interface for the Granite TaskService.
 */
public interface GraniteShelfService {

  public KeyPojo updateSerialNumberForShelf(long equipInstId, String serialNumber) throws Exception;

  public KeyPojo updateUDAsForPort(long portInstId, long equipInstId, UDAPojo[] udas) throws Exception;

  public KeyPojo updateUDAsForShelf(long equipInstId, UDAPojo[] udas) throws Exception;
}
