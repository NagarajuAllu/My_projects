package com.ericsson.stc.dataMigration.graniteServiceTier;

import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.KeyPojo;
import com.ericsson.stc.dataMigration.graniteServiceTier.pojo.UdaPojo;
import com.granite.asi.dto.ASIList;
import com.granite.asi.dto.DataObject;
import com.granite.asi.dto.PathElementASIList;
import com.granite.asi.dto.UdaASIList;
import com.granite.asi.dto.clientview.Path;
import com.granite.asi.dto.clientview.PathElement;
import com.granite.asi.dto.clientview.PathLeg;
import com.granite.asi.dto.clientview.Uda;
import com.granite.asi.dto.generated.clientview.PathElementConnectType;
import com.granite.asi.dto.generated.clientview.PathElementType;
import com.granite.asi.key.Key;
import com.granite.asi.key.generated.BandwidthKey;
import com.granite.asi.key.generated.PathKey;
import com.granite.asi.service.LockService;
import com.granite.asi.service.PathService;
import com.granite.asi.util.Query;

import java.util.ArrayList;


public class GranitePathServiceImpl {

  public KeyPojo getPathKeyByName(String pathName) throws Exception {
    KeyPojo pathKeyPojo;
    Path foundPath = getPathByName(pathName);
    if(foundPath != null) {
      pathKeyPojo = Mapper_DTO_To_Pojo.mapToKeyPojo(foundPath.getPathKey());
    }
    else {
      throw new Exception("Unable to find path with name " + pathName);
    }

    return pathKeyPojo;
  }

  public boolean addUDAsToPath(long pathInstId, ArrayList<UdaPojo> udaToCreate) throws Exception {
    boolean success;

    Path foundPath = getPathByInstId(pathInstId);
    if(foundPath != null) {
      UdaASIList udaASIList = foundPath.getUdas();
      AsiServices asiServices = AsiServices.getInstance();
      PathService pathService = asiServices.getPathService();

      for(UdaPojo udaPojo: udaToCreate) {
        Uda newUda = asiServices.getNewUda();
        newUda.setGroupName(udaPojo.getUdaGroup());
        newUda.setUdaName(udaPojo.getUdaName());
        newUda.setUdaValue(udaPojo.getUdaValue());
        udaASIList.add(newUda);
      }

      LockService lockService = asiServices.getLockService();
      lockService.lock(foundPath.getPathKey());
      pathService.update(foundPath);
      lockService.unlock(foundPath.getPathKey());

      success = true;
    }
    else {
      throw new Exception("Unable to find path with instId " + pathInstId);
    }

    return success;
  }

  public KeyPojo routePathOnDynamicChannel(long childPathInstId, long parentPathInstId, int position) throws Exception {
    KeyPojo pathChannelKey;

    Path foundChildPath = getPathByInstId(childPathInstId);
    if(foundChildPath != null) {
      int sequenceNumber = position;
      if(position < 1) {
        sequenceNumber = 1;
      }

      ASIList legListOnPath = foundChildPath.getLegs();
      if(legListOnPath.size() == 0) {
        throw new Exception("Unable to find any leg for the path");
      }
      PathLeg pathLeg = (PathLeg) legListOnPath.get(0);
      PathElementASIList elementASIList = pathLeg.getElements();

      AsiServices asiServices = AsiServices.getInstance();
      PathService pathService = asiServices.getPathService();

      // create dynamic channel in parent
      Key channelKey = pathService.allocateDynamicChannel(new PathKey(parentPathInstId),
                                                          new PathKey(childPathInstId),
                                                          new BandwidthKey(foundChildPath.getBandwidthName()));

      if(channelKey.isComplete()) {
        // associate channel in child
        PathElement newPathElement = asiServices.getNewPathElement();
        newPathElement.setPathInstId(parentPathInstId);
        newPathElement.setConnectType(PathElementConnectType.THROUGH);
        newPathElement.setElementType(PathElementType.PARENT_CIRCUIT_PATH_CHANNEL);
        newPathElement.setChanInstId(channelKey.getInstId());

        elementASIList.addNonAggregateElement(sequenceNumber, newPathElement);

        LockService lockService = asiServices.getLockService();
        lockService.lock(foundChildPath.getPathKey());

        pathService.update(foundChildPath);
        lockService.unlock(foundChildPath.getPathKey());

        pathChannelKey = Mapper_DTO_To_Pojo.mapToKeyPojo(channelKey);
      }
      else {
        throw new Exception("Unable to create dynamic channel for <" + parentPathInstId + "," + childPathInstId + ">");
      }
    }
    else {
      throw new Exception("Unable to find path with instId " + childPathInstId);
    }

    return pathChannelKey;
  }

  private Path getPathByName(String pathName) throws Exception {
    Path foundPath = null;

    AsiServices asiServices = AsiServices.getInstance();
    PathService pathService = asiServices.getPathService();

    Path path = asiServices.getNewPath();
    path.setWildName(false);
    path.setName(pathName);

    Query query = new Query();
    query.addQueryEntry(path);

    DataObject[] queryResult = pathService.query(query);
    if (queryResult != null && queryResult.length > 0) {
      if(queryResult.length > 1) {
        throw new Exception("Too many path with name " + pathName + " found: " + queryResult.length);
      }
      foundPath = getPathByInstId(((Path)queryResult[0]).getCircPathInstId());
    }

    return foundPath;
  }


  private Path getPathByInstId(long pathInstId) throws Exception {
    Path foundPath;

    AsiServices asiServices = AsiServices.getInstance();
    PathService pathService = asiServices.getPathService();

    foundPath = (Path)pathService.get(new PathKey(pathInstId));

    return foundPath;
  }
}
