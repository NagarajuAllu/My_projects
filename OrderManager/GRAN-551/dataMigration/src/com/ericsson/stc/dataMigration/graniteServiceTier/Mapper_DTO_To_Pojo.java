package com.ericsson.stc.dataMigration.graniteServiceTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.*;
import com.granite.asi.dto.clientview.AssociationInstance;
import com.granite.asi.dto.clientview.RoleInstance;
import com.granite.asi.dto.clientview.Shelf;
import com.granite.asi.dto.clientview.Site;
import com.granite.asi.key.Key;

/**
 * To map Granite objects into internal Pojo
 */
public class Mapper_DTO_To_Pojo {


  public static KeyPojo mapToKeyPojo(Key keyMT) {
    KeyPojo keyPojo = new KeyPojo();
    keyPojo.setType(keyMT.getClass().getName());
    keyPojo.setInstId(keyMT.getInstId());

    return keyPojo;
  }
}
