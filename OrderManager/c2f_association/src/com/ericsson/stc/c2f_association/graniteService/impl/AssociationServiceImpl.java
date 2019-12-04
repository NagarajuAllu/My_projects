package com.ericsson.stc.c2f_association.graniteService.impl;

import com.ericsson.stc.c2f_association.utility.PropertyReader;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.clientview.AssociationDefinition;
import com.granite.asi.dto.clientview.AssociationInstance;
import com.granite.asi.key.AssociationDefinitionKey;
import com.granite.asi.key.AssociationInstanceKey;
import com.granite.asi.key.Key;
import com.granite.asi.key.generated.SiteKey;
import com.granite.asi.service.AssociationDefinitionService;
import com.granite.asi.service.generated.AssociationInstanceService;
import com.granite.asi.util.Query;
import org.apache.log4j.Logger;

import java.util.HashMap;

/**
 * To manage all the API related to Site objects.
 */
public class AssociationServiceImpl {

  private final  Logger                                    _log            = Logger.getLogger(AssociationServiceImpl.class);
  private static AssociationServiceImpl                    _instance       = null;

  private        PropertyReader                            _propertyReader = PropertyReader.getInstance();
  private        HashMap<String, AssociationDefinitionKey> _associationMap = new HashMap<>();

  private AssociationServiceImpl() {

  }

  public static AssociationServiceImpl getInstance() {
    if(_instance == null) {
      _instance = new AssociationServiceImpl();
    }
    return _instance;
  }

  String createAssociationBetweenSites(String associationName, long siteFromInstId, long siteToInstId) throws Exception {
    String logHeader = "createAssociationBetweenSites<" + siteFromInstId + "," + siteToInstId + ">: ";
    String resultMsg;

    AssociationDefinitionKey associationDefinitionKey = getKeyForAssociationDefinition(associationName);
    if(associationDefinitionKey.getInstId() == -1) {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_noAssociationDefFound");
      _log.info(logHeader + resultMsg);
      return resultMsg;
    }

    AssociationInstance existingAssociationInstance = getAssociationBetweenSites(associationDefinitionKey,
                                                                                 siteFromInstId,
                                                                                 siteToInstId);
    if(existingAssociationInstance != null) {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#AssociationAlreadyExist");
      _log.info(logHeader + resultMsg);
      return resultMsg;
    }
    else {
      _log.info(logHeader + "No association found");
    }

    existingAssociationInstance = getAssociationBetweenSites(associationDefinitionKey,
                                                             siteToInstId,
                                                             siteFromInstId);
    if(existingAssociationInstance != null) {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_associationInverseFound");
      _log.info(logHeader + resultMsg);
      return resultMsg;
    }
    else {
      _log.info(logHeader + "No association inverse found");
    }

    AssociationInstanceKey associationInstanceKey = createAssociationBetweenSites(associationDefinitionKey,
                                                                                  siteFromInstId,
                                                                                  siteToInstId);

    if(associationInstanceKey != null) {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Success");
    }
    else {
      resultMsg = _propertyReader.getProperty("RESPONSE_MSG#Other_unexpectedErrorWhileCreatingAssociation");
    }

    _log.info(logHeader + resultMsg);
    return resultMsg;
  }




  private AssociationDefinitionKey getKeyForAssociationDefinition(String associationName) throws Exception {
    AssociationDefinitionKey associationDefinitionKey = _associationMap.get(associationName);
    if(associationDefinitionKey != null) {
      _log.debug("Association '" + associationName + "' found in map; key = " + associationDefinitionKey);
      return associationDefinitionKey;
    }

    AsiServices asiServices = AsiServices.getInstance();

    AssociationDefinitionService associationDefinitionService = asiServices.getAssociationDefinitionService();
    AssociationDefinition associationDefinition = asiServices.getNewAssociationDefinition();
    associationDefinition.setName(associationName);

    Query query = new Query();
    query.addQueryEntry(associationDefinition);

    DataObject[] queryResult = associationDefinitionService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      associationDefinitionKey = ((AssociationDefinition) queryResult[0]).getAssociationDefinitionKey();
      _log.debug("Association '" + associationName + "' found in DB; key = " + associationDefinitionKey);
    }
    else {
      _log.error("Association '" + associationName + "' NOT FOUND in DB");
      associationDefinitionKey = new AssociationDefinitionKey();
      associationDefinitionKey.setInstid(-1);
    }

    _associationMap.put(associationName, associationDefinitionKey);

    return associationDefinitionKey;
  }

  private AssociationInstance getAssociationBetweenSites(AssociationDefinitionKey associationDefinitionKey,
                                                         long siteFromInstId,
                                                         long siteToInstId) throws Exception {
    AsiServices asiServices = AsiServices.getInstance();

    AssociationInstanceService associationInstanceService = asiServices.getAssociationInstanceService();
    AssociationInstance associationInstance = asiServices.getNewAssociationInstance();
    associationInstance.setType(associationDefinitionKey);
    associationInstance.setRoleData(AssociationInstance.LEFT_ROLE,
                                    new SiteKey(siteFromInstId),
                                    new SiteKey(siteToInstId));

    AssociationInstance foundAssociationInstance = null;

    Query query = new Query();
    query.addQueryEntry(associationInstance);

    DataObject[] queryResult = associationInstanceService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      foundAssociationInstance = (AssociationInstance) queryResult[0];
    }

    return foundAssociationInstance;
  }

  private AssociationInstanceKey createAssociationBetweenSites(AssociationDefinitionKey associationDefinitionKey,
                                                               long siteFromInstId,
                                                               long siteToInstId) throws Exception {
    AsiServices asiServices = AsiServices.getInstance();

    AssociationInstanceService associationInstanceService = asiServices.getAssociationInstanceService();

    AssociationInstance associationInstance = asiServices.getNewAssociationInstance();
    associationInstance.setType(associationDefinitionKey);
    associationInstance.setRoleData(AssociationInstance.LEFT_ROLE,
                                    new SiteKey(siteFromInstId),
                                    new SiteKey(siteToInstId));

    Key savedAssociationInstanceKey = associationInstanceService.insert(associationInstance);
    AssociationInstance associationInstanceInserted = (AssociationInstance)associationInstanceService.get(savedAssociationInstanceKey);
    AssociationInstanceKey keyForDoubleCheck = associationInstanceInserted.getAssociationInstanceKey();
    return keyForDoubleCheck;
  }
}
