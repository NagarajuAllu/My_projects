package com.ericsson.stc.c2f_association.graniteService.impl.persistence;

import com.ericsson.stc.c2f_association.graniteService.GraniteSiteService;
import com.ericsson.stc.c2f_association.graniteService.pojo.GisDataPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;
import org.apache.log4j.Logger;

import java.util.List;

/**
 * To manage all the API related to Shelf objects.
 */
public class SiteServiceWithDBImpl implements GraniteSiteService {

  private final Logger _log = Logger.getLogger(SiteServiceWithDBImpl.class);

  @Override
  public SitePojo getSiteByCLLI(String siteCLLI) throws Exception {
    SitePojo foundSite = DBConnectionManager.getInstance().getSitePojoByCLLI(siteCLLI);

    return foundSite;
  }

  @Override
  public List<GisDataPojo> getGisData() {
    return DBConnectionManager.getInstance().getGisData();
  }

  @Override
  public void updateGisResult(GisDataPojo gis) {
    DBConnectionManager.getInstance().updateGisResult(gis);
  }
}
