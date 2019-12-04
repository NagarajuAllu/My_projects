package com.ericsson.stc.c2f_association.graniteService;

import com.ericsson.stc.c2f_association.graniteService.pojo.GisDataPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;

import java.util.List;

/**
 * The generic interface for Granite SiteService.
 */
public interface GraniteSiteService {

  public SitePojo getSiteByCLLI(String siteCLLI) throws Exception;

  List<GisDataPojo> getGisData();

  void updateGisResult(GisDataPojo gis);
}
