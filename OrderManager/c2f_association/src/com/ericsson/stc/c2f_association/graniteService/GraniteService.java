package com.ericsson.stc.c2f_association.graniteService;


public interface GraniteService {

  public void startupASIFactory() throws Exception;

  public String createAssociationFromCopperToFiber(String associationName,
                                                   String copperPlateId,
                                                   String fiberPlateId) throws Exception;

  public void shutdownASIFactory() throws Exception;

  void processGis();

}

