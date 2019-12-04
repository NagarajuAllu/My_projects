package com.ericsson.stc.granitews4eoc.businessTier.implementation;

import com.ericsson.stc.granitews4eoc.businessTier.GraniteShelfService;
import com.ericsson.stc.granitews4eoc.businessTier.Mapper_DTO_To_Pojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.UdaASIList;
import com.granite.asi.dto.clientview.*;
import com.granite.asi.key.PortKey;
import com.granite.asi.key.ShelfKey;
import com.granite.asi.service.*;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;


/**
 * To manage all the API related to Shelf and Port objects.
 */
public class GraniteShelfServiceImpl implements GraniteShelfService {

  private final Logger _logger = Logger.getLogger(GraniteShelfServiceImpl.class);

  public KeyPojo updateSerialNumberForShelf(long equipInstId, String serialNumber) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    Shelf shelf = null;
    ShelfKey shelfKey = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      ShelfService shelfService = asiServices.getShelfService();

      shelf = getShelfByInstId(equipInstId);
      if(shelf == null) {
        throw new Exception("Unable to find the shelf with id: " + equipInstId);
      }

      shelfKey = shelf.getShelfKey();

      shelf.setSerialNumber(serialNumber);

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(shelfKey);
      isLocked = true;

      shelfService.update(shelf);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateSerialNumberForShelf <" + equipInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(shelfKey);
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking Shelf with key " + shelfKey, exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(shelfKey);
  }

  public KeyPojo updateUDAsForPort(long portInstId, long equipInstId, UDAPojo[] udas) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    Shelf shelf = null;
    PortKey key = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      PortService portService = asiServices.getPortService();

      shelf = getShelfByInstId(equipInstId);
      if(shelf == null) {
        throw new Exception("Unable to find the shelf with id: " + equipInstId);
      }

      Port port = getPortByInstIdAndEquipInstId(portInstId, equipInstId);
      if(port == null) {
        throw new Exception("Unable to find the port with id: " + portInstId +
                            " in equipment with id: " + equipInstId);
      }

      key = new PortKey(port.getPortInstId());

      for(UDAPojo uda : udas) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(uda.getUdaGroup());
        newUda.setUdaName(uda.getUdaName());
        newUda.setUdaValue(uda.getUdaValue());

        UdaASIList udaASIList = port.getUdas();
        udaASIList.add(newUda);
      }

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(shelf.getShelfKey());
      isLocked = true;

      portService.update(port);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateUDAsForPort <" + portInstId + "," + equipInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(shelf.getShelfKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking Shelf with key " + shelf.getShelfKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(key);
  }

  public KeyPojo updateUDAsForShelf(long equipInstId, UDAPojo[] udas) throws Exception {
    Exception foundException = null;
    LockService lockService = null;
    Shelf shelf = null;
    ShelfKey key = null;
    boolean isLocked = false;

    try {
      AsiServices asiServices = AsiServices.getInstance();
      ShelfService shelfService = asiServices.getShelfService();

      shelf = getShelfByInstId(equipInstId);
      if(shelf == null) {
        throw new Exception("Unable to find the shelf with id: " + equipInstId);
      }

      key = shelf.getShelfKey();

      for(UDAPojo uda : udas) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(uda.getUdaGroup());
        newUda.setUdaName(uda.getUdaName());
        newUda.setUdaValue(uda.getUdaValue());

        UdaASIList udaASIList = shelf.getUdas();
        udaASIList.add(newUda);
      }

      lockService = asiServices.getLockService();
      lockService.lockInCurrentTransaction(shelf.getShelfKey());
      isLocked = true;

      shelfService.update(shelf);
    }
    catch(Exception exc) {
      foundException = exc;
      _logger.error("Unexpected Error in updateUDAsForShelf<" + equipInstId + ">", exc);
    }
    finally {
      try {
        if(lockService != null && isLocked) {
          lockService.unlockInCurrentTransaction(shelf.getShelfKey());
        }
      }
      catch (Exception exc) {
        _logger.error("Error in unlocking Shelf with key " + shelf.getShelfKey(), exc);
      }
    }

    if(foundException != null) {
      throw foundException;
    }

    return Mapper_DTO_To_Pojo.mapToKeyPojo(key);
  }


  private Shelf getShelfByInstId(long equipInstId) throws Exception {
    Shelf foundShelf;

    AsiServices asiServices = AsiServices.getInstance();
    ShelfService shelfService = asiServices.getShelfService();

    foundShelf = (Shelf) shelfService.get(new ShelfKey(equipInstId));

    return foundShelf;
  }

  private Port getPortByInstIdAndEquipInstId(long portInstId, long equipInstId) throws Exception {
    Port foundPort = null;

    AsiServices asiServices = AsiServices.getInstance();
    PortService portService = asiServices.getPortService();

    Port port = asiServices.getNewPort();
    port.setPortInstId(portInstId);
    port.setEquipInstId(equipInstId);

    Query query = new Query();
    query.addQueryEntry(port);

    DataObject[] queryResult = portService.query(query);

    if (queryResult != null && queryResult.length > 0) {
      foundPort = (Port)queryResult[0];
    }

    return foundPort;
  }

}
