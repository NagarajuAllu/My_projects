package com.ericsson.stc.c2f_association.graniteService.impl;

import com.ericsson.stc.c2f_association.graniteService.GraniteShelfService;
import com.ericsson.stc.c2f_association.graniteService.Mapper_DTO_To_Pojo;
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
public class ShelfServiceWithASIImpl implements GraniteShelfService {

  private final Logger _log = Logger.getLogger(ShelfServiceWithASIImpl.class);

  private String _udaGroup = null;
  private String _udaName = null;

  @Override
  public void setUdaData(String udaGroupName, String udaName) {
    _udaGroup = udaGroupName;
    _udaName = udaName;
  }

  public ShelfPojo getShelfByUDANameAndValue(String udaValue) throws Exception {
    ShelfPojo foundShelf = null;

    AsiServices asiServices = AsiServices.getInstance();
    ShelfService shelfService = asiServices.getShelfService();

    Uda udaForQuery = asiServices.getNewUda();
    udaForQuery.setGroupName(_udaGroup);
    udaForQuery.setUdaName(_udaName);
    udaForQuery.setUdaValue(udaValue);

    Shelf shelf = asiServices.getNewShelf();
    UdaASIList udaASIList = shelf.getUdas();
    udaASIList.add(udaForQuery);

    Query query = new Query();
    query.addQueryEntry(shelf);

    DataObject[] queryResult = shelfService.query(query);

    if (queryResult != null && queryResult.length > 0) {
      foundShelf = Mapper_DTO_To_Pojo.mapToShelfPojo((Shelf) queryResult[0]);
    }

    return foundShelf;

  }
}
