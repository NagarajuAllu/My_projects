package com.ericsson.stc.c2f_association.graniteService.impl.persistence;

import com.ericsson.stc.c2f_association.graniteService.GraniteShelfService;
import com.ericsson.stc.c2f_association.graniteService.Mapper_DTO_To_Pojo;
import com.ericsson.stc.c2f_association.graniteService.impl.AsiServices;
import com.ericsson.stc.c2f_association.graniteService.pojo.ShelfPojo;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.UdaASIList;
import com.granite.asi.dto.clientview.Shelf;
import com.granite.asi.dto.clientview.Uda;
import com.granite.asi.service.ShelfService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;

/**
 * To manage all the API related to Shelf objects.
 */
public class ShelfServiceWithDBImpl implements GraniteShelfService {

  private final Logger _log = Logger.getLogger(ShelfServiceWithDBImpl.class);

  private static Long _udaInstId = null;

  @Override
  public void setUdaData(String udaGroupName, String udaName) {
    _udaInstId = DBConnectionManager.getInstance().getUDAInstId(udaGroupName, udaName);
  }


  public ShelfPojo getShelfByUDANameAndValue(String udaValue) throws Exception {
    ShelfPojo foundShelf = DBConnectionManager.getInstance().getShelfPojoByShelfUDA(_udaInstId, udaValue);

    return foundShelf;

  }
}
