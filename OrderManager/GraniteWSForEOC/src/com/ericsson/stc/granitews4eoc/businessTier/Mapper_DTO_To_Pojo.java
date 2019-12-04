package com.ericsson.stc.granitews4eoc.businessTier;

import com.ericsson.stc.granitews4eoc.businessTier.pojo.*;
import com.granite.asi.dto.clientview.Shelf;
import com.granite.asi.key.Key;

/**
 * To map Granite objects into internal Pojo
 */
public class Mapper_DTO_To_Pojo {

  public static ShelfPojo mapToShelfPojo(Shelf shelfMT) {
    ShelfPojo shelfPojo = new ShelfPojo();
    shelfPojo.setEquipInstId(shelfMT.getEquipInstId());
    shelfPojo.setName(shelfMT.getName());
    shelfPojo.setType(shelfMT.getType());
    shelfPojo.setStatus(shelfMT.getStatus());

    shelfPojo.setSiteInstId(shelfMT.getSiteInstId());

    return shelfPojo;
  }

  public static KeyPojo mapToKeyPojo(Key keyMT) {
    KeyPojo keyPojo = new KeyPojo();
    keyPojo.setType(keyMT.getClass().getName());
    keyPojo.setInstId(keyMT.getInstId());

    return keyPojo;
  }
}
