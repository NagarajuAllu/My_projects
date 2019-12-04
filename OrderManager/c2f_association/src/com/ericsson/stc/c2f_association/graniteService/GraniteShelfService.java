package com.ericsson.stc.c2f_association.graniteService;

import com.ericsson.stc.c2f_association.graniteService.pojo.ShelfPojo;

/**
 * The generic interface for the Granite ShelfService.
 */
public interface GraniteShelfService {

  public void setUdaData(String udaGroupName, String udaName);

  public ShelfPojo getShelfByUDANameAndValue(String udaValue) throws Exception;
}
