package com.ericsson.stc.c2f_association.graniteService.impl;


import com.ericsson.stc.c2f_association.graniteService.GraniteSiteService;
import com.ericsson.stc.c2f_association.graniteService.Mapper_DTO_To_Pojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.GisDataPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.clientview.Site;
import com.granite.asi.service.SiteService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;

import java.util.List;


/**
 * To manage all the API related to Site objects.
 */
public class SiteServiceWithASIImpl implements GraniteSiteService {

  private final Logger _log = Logger.getLogger(SiteServiceWithASIImpl.class);

  public SitePojo getSiteByCLLI(String siteCLLI) throws Exception {
    SitePojo foundSite = null;

    AsiServices asiServices = AsiServices.getInstance();
    SiteService siteService = asiServices.getSiteService();

    Site siteForQuery = asiServices.getNewSite();
    siteForQuery.setClli(siteCLLI);

    Query query = new Query();
    query.addQueryEntry(siteForQuery);

    DataObject[] queryResult = siteService.query(query);

    if (queryResult != null && queryResult.length > 0) {
      foundSite = Mapper_DTO_To_Pojo.mapToSitePojo((Site) queryResult[0]);
    }
    else {
      foundSite = new SitePojo();
      foundSite.setSiteInstId(new Long(-1));
    }

    return foundSite;
  }

  @Override
  public List<GisDataPojo> getGisData() {
    //no supported
    return null;
  }

  @Override
  public void updateGisResult(GisDataPojo gis) {
    //no supported
  }
}
