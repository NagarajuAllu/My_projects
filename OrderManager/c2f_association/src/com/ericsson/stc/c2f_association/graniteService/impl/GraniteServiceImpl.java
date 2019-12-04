package com.ericsson.stc.c2f_association.graniteService.impl;

import com.ericsson.stc.c2f_association.graniteService.GraniteService;


import com.ericsson.stc.c2f_association.graniteService.GraniteShelfService;
import com.ericsson.stc.c2f_association.graniteService.GraniteSiteService;
import com.ericsson.stc.c2f_association.graniteService.impl.persistence.ShelfServiceWithDBImpl;
import com.ericsson.stc.c2f_association.graniteService.impl.persistence.SiteServiceWithDBImpl;
import com.ericsson.stc.c2f_association.graniteService.pojo.GisDataPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.ShelfPojo;
import com.ericsson.stc.c2f_association.graniteService.pojo.SitePojo;
import com.ericsson.stc.c2f_association.utility.PropertyReader;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;

public class GraniteServiceImpl implements GraniteService {

  private static final boolean USE_ASI = false;

  private final Logger _log = Logger.getLogger(GraniteServiceImpl.class);
  private final PropertyReader _propertyReader = PropertyReader.getInstance();

  private HashMap<String, SitePojo> _sitePojoByFiberPlateIdMap = new HashMap<>();
  private HashMap<String, Long>     _siteByCopperPlateIdMap    = new HashMap<>();

  private GraniteShelfService _shelfServiceImpl = null;
  private GraniteSiteService _siteServiceImpl = null;


  public GraniteServiceImpl() {
    String defaultUDAPlateId = "Copper terminal attributes#Copper Plate ID";
    String udaPlateIdForCopperSite = _propertyReader.getProperty("udaPlateIdForCopperSite", defaultUDAPlateId);

    int indexPound = udaPlateIdForCopperSite.indexOf("#");
    if (indexPound < 1) {
      _log.error("Invalid value for configuration parameter '" + udaPlateIdForCopperSite + "'; using " + defaultUDAPlateId);
      udaPlateIdForCopperSite = defaultUDAPlateId;
      indexPound = udaPlateIdForCopperSite.indexOf("#");
    }

    if(USE_ASI) {
      _shelfServiceImpl = new ShelfServiceWithASIImpl();
      _siteServiceImpl = new SiteServiceWithASIImpl();
    }
    else {
      _shelfServiceImpl = new ShelfServiceWithDBImpl();
        _log.info("Loading configuration UDA data...");
      _shelfServiceImpl.setUdaData(udaPlateIdForCopperSite.substring(0, indexPound), udaPlateIdForCopperSite.substring(indexPound + 1));

      _siteServiceImpl = new SiteServiceWithDBImpl();
    }
  }

  public void startupASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiStartup();
    }
    catch(Exception exc) {
      _log.error("Unexpected error in starting up the ASI Factory", exc);
      throw exc;
    }
  }

  public String createAssociationFromCopperToFiber(String associationName,
                                                   String copperPlateId,
                                                   String fiberPlateId) throws Exception {
    String resultMsg = null;

    AsiServices asiServices = AsiServices.getInstance();
    Exception foundException = null;

    try {
      /***
      if(USE_ASI) {
        asiServices.asiStartup();
      }
      **/

      Long copperSiteInstId = getSiteInstIdForShelfForCopperPlateId(copperPlateId);
      if(copperSiteInstId != null) {
        SitePojo fiberSite = getSitePojoForFiberPlateId(fiberPlateId);
        if(fiberSite != null) {
          String fiberSiteType = fiberSite.getType();
          if(isValidTypeForFiberSite(fiberSiteType)) {
            long fiberSiteInstId = fiberSite.getSiteInstId();

            /***
            if(!USE_ASI) {
              asiServices.asiStartup();
            }
            ***/
            AssociationServiceImpl associationServiceImpl = AssociationServiceImpl.getInstance();
            resultMsg = associationServiceImpl.createAssociationBetweenSites(associationName,
                                                                             copperSiteInstId,
                                                                             fiberSiteInstId);
          }
          else {
            resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_fiberSiteTypeNotValid");
          }
        }
        else {
          resultMsg = _propertyReader.getProperty("RESPONSE_MSG#FiberPlateIDNotFound");
        }
      }
      else {
        resultMsg = _propertyReader.getProperty("RESPONSE_MSG#CopperPlateIDNotFound");
      }
    }
    catch(Exception exc) {
      _log.error("Unexpected error in executing createAssociationFromCopperToFiber(" +
                 copperPlateId + "," + fiberPlateId + ")",
                 exc);
      foundException = exc;
    }

    if (foundException != null) {
      throw foundException;
    }

    return resultMsg;
  }

  public void shutdownASIFactory() throws Exception {
    try {
      AsiServices asiServices = AsiServices.getInstance();
      asiServices.asiShutdown();
    }
    catch(Exception exc) {
      _log.error("Unexpected error in shutting down the ASI Factory", exc);
      throw exc;
    }
  }

  private Long getSiteInstIdForShelfForCopperPlateId(String copperPlateId) throws Exception {
    Long copperSiteInstId = null;

    try {
      Long foundInMap = _siteByCopperPlateIdMap.get(copperPlateId);
      if(foundInMap != null) {
        if(foundInMap != -1) {
          _log.info("CopperPlateId <" + copperPlateId + "> found in map with value: " + foundInMap);
          copperSiteInstId = foundInMap;
        }
        else {
          _log.info("CopperPlateId <" + copperPlateId + "> found in map with value -1 so it's null");
        }
      }
      else {

        ShelfPojo copperShelf = _shelfServiceImpl.getShelfByUDANameAndValue(copperPlateId);
        if (copperShelf != null) {
          copperSiteInstId = copperShelf.getSiteInstId();
        }

        addSiteInstToCopperMap(copperPlateId, copperSiteInstId);
      }
    }
    catch (Exception exc) {
      _log.error("Unexpected error in executing getSiteInstIdForShelfForCopperPlateId(" + copperPlateId + ")", exc);
      throw exc;
    }

    return copperSiteInstId;
  }

  private SitePojo getSitePojoForFiberPlateId(String fiberPlateId) throws Exception {
    SitePojo fiberSitePojo = null;

    try {
      SitePojo foundInMap = _sitePojoByFiberPlateIdMap.get(fiberPlateId);
      if(foundInMap != null) {
        if(foundInMap.getSiteInstId() != -1) {
          _log.info("FiberPlateId <" + fiberPlateId + "> found in map with value: " + foundInMap);
          fiberSitePojo = foundInMap;
        }
        else {
          _log.info("FiberPlateId <" + fiberPlateId + "> found in map with value -1 so it's null");
        }
      }
      else {
        SitePojo fiberSite = _siteServiceImpl.getSiteByCLLI(fiberPlateId);

        if(fiberSite != null && fiberSite.getSiteInstId() != -1) {
          // real site
          fiberSitePojo = fiberSite;
        }

        addSitePojoToFiberMap(fiberPlateId, (fiberSite != null ? fiberSite.getSiteInstId() : null), (fiberSite != null ? fiberSite.getType() : null));
      }
    }
    catch (Exception exc) {
      _log.error("Unexpected error in executing getSiteForFiberPlateId(" + fiberPlateId + ")", exc);
      throw exc;
    }

    return fiberSitePojo;
  }

  private boolean isValidTypeForFiberSite(String siteType) {
    String configuredFiberSiteTypeString = _propertyReader.getProperty("fiberSiteType", "FIBER");
    String[] configuredFiberSiteTypes = configuredFiberSiteTypeString.split(",");

    boolean valid = false;
    for (String s : configuredFiberSiteTypes) {
      if(s.equalsIgnoreCase(siteType)) {
        valid = true;
      }
    }

    return valid;
  }

  private void addSiteInstToCopperMap(String copperPlateId, Long foundSiteInstId) throws Exception {
    if (_siteByCopperPlateIdMap == null) {
      _siteByCopperPlateIdMap = new HashMap<>();
    }

    if (foundSiteInstId != null) {
      _siteByCopperPlateIdMap.put(copperPlateId, foundSiteInstId);
    }
    else {
      _siteByCopperPlateIdMap.put(copperPlateId, new Long(-1));
    }
    _log.info("CopperPlateId <" + copperPlateId + "> added to map with value: " + (foundSiteInstId == null ? "'NULL'" : foundSiteInstId));
  }

  private void addSitePojoToFiberMap(String fiberPlateId, Long foundSiteInstId, String foundSiteType) throws Exception {
    if (_sitePojoByFiberPlateIdMap == null) {
      _sitePojoByFiberPlateIdMap = new HashMap<>();
    }

    SitePojo sitePojo = new SitePojo();
    if (foundSiteInstId != null) {
      sitePojo.setSiteInstId(foundSiteInstId);
      sitePojo.setType(foundSiteType);
    }
    else {
      sitePojo.setSiteInstId(new Long(-1));
    }

    _sitePojoByFiberPlateIdMap.put(fiberPlateId, sitePojo);
    _log.info("FiberPlateId <" + fiberPlateId + "> added to map with value: " + (foundSiteInstId == null ?
                                                                                 "'NULL'" :
                                                                                 "<" + foundSiteInstId + "," + foundSiteType + ">"));
  }

  public void processGis() {
      String associationName = _propertyReader.getProperty("associationName", "Copper to Fiber");

      _log.info("Loading GIS data...");
      List<GisDataPojo> gisList = _siteServiceImpl.getGisData();
      if (gisList.isEmpty()) {
          _log.warn("Input GIS data list is empty. Nothing to process");
          return;
      }
      _log.info("Loaded " + gisList.size() + " entries");

      try {
          startupASIFactory();

          for (int row = 1; row <= gisList.size(); row++) {
              _log.info("--> ROW#" + row + " processing...");
              GisDataPojo gis = gisList.get(row - 1);
              String c = gis.getCopperPlateId();
              String f = gis.getFiberPlateId();
              String result = createAssociationFromCopperToFiber(associationName, c, f);

              String status = StringUtils.equalsIgnoreCase(result, "success") ? "Processed" : "Failed";
              gis.setStatus(status);
              gis.setExecutionDate(new Date(System.currentTimeMillis()));
              if (StringUtils.equals("Failed", status)) {
                  gis.setError(result);
              }
              _log.info("\n  ROW#" + row + " is ready: " + gis);
              _log.info("ROW#" + row + " updating...");
              _siteServiceImpl.updateGisResult(gis);
              _log.info("ROW#" + row + " updated!");
          }

      } catch (Exception e) {
          _log.error("Unexpected error while processing GIS data");
      } finally {
          try {
              shutdownASIFactory();
          } catch (Exception e) {
              _log.error("Error in shutting down ASI Factory", e);
          }
      }
  }

}
