package com.ericsson.stc.c2f_association.graniteService;

import com.ericsson.stc.c2f_association.graniteService.pojo.ShelfPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;
import com.granite.asi.dto.clientview.Shelf;
import com.granite.asi.dto.clientview.Site;

/**
 * To map Granite objects into internal Pojo
 */
public class Mapper_DTO_To_Pojo {

    public static final SitePojo mapToSitePojo(Site siteMT) {
      SitePojo sitePojo = new SitePojo();
      sitePojo.setSiteInstId(siteMT.getSiteInstId());
      sitePojo.setType(siteMT.getType());
      return sitePojo;
    }

    public static final ShelfPojo mapToShelfPojo(Shelf shelfMT) {
      ShelfPojo shelfPojo = new ShelfPojo();
      shelfPojo.setEquipInstId(shelfMT.getEquipInstId());
      shelfPojo.setSiteInstId(shelfMT.getSiteInstId());
      shelfPojo.setName(shelfMT.getName());

      shelfPojo.setSiteInstId(shelfMT.getSiteInstId());

      return shelfPojo;
    }
}
