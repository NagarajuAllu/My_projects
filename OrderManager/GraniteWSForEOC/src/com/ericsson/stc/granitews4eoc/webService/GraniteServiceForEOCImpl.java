package com.ericsson.stc.granitews4eoc.webService;

// Import the standard JWS annotation interfaces
import com.ericsson.stc.granitews4eoc.businessTier.GraniteService;
import com.ericsson.stc.granitews4eoc.businessTier.implementation.GraniteServiceImpl;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.KeyPojo;
import com.ericsson.stc.granitews4eoc.businessTier.pojo.UDAPojo;
import com.ericsson.stc.granitews4eoc.utility.WoTaskStatusMgmt;
import com.ericsson.stc.granitews4eoc.webService.pojo.*;
import org.apache.log4j.Logger;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;


// Standard JWS annotation that specifies that the portType name of the Web
@WebService(name="GraniteServiceForEOCPortType", serviceName="GraniteServiceForEOC", targetNamespace="http://com.ericsson.stc.granitews4eoc")

// Standard JWS annotation that specifies the mapping of the service onto the
// SOAP message protocol. In particular, it specifies that the SOAP messages
// are document-literal-wrapped.
@SOAPBinding(style=SOAPBinding.Style.DOCUMENT, use=SOAPBinding.Use.LITERAL, parameterStyle=SOAPBinding.ParameterStyle.WRAPPED)

/**
 * This JWS file is the basis of Java-class implemented WebLogic Web Service to
 * allow EOC to interact with Granite
 */
public class GraniteServiceForEOCImpl {

  private Logger _logger = Logger.getLogger(getClass());
  private InputValidation _inputValidation = new InputValidation();
  private WoTaskStatusMgmt _woTaskStatusMgmt = new WoTaskStatusMgmt();

  // Standard JWS annotation that specifies that the method should be exposed as a public operation.
  // Because the annotation does not include the member-value "operationName", the public name of
  // the operation is the same as the method name.
  @WebMethod(operationName="changeTaskStatus", action="changeTaskStatus")
  @WebResult(name="ResultMessage")
  public ResultPojo changeTaskStatus(@WebParam(name="ChangeTaskStatusInputMessage")
                                     ChangeTaskStatusPojo inputMessage) {
    _logger.info("ChangeTaskStatus# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      KeyPojo taskKey = impl.changeTaskStatus(inputMessage.getTaskInstId(),
                                              _woTaskStatusMgmt.getNameForCode(inputMessage.getNewStatusCode()),
                                              inputMessage.getUserId());

      if(taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("ChangeTaskStatus# received: " + inputMessage + "; response: " + result);

    return result;
  }


  @WebMethod(operationName="completeTask", action="completeTask")
  @WebResult(name="ResultMessage")
  public ResultPojo completeTask(@WebParam(name="CompleteTaskInputMessage")
                                 CompleteTaskPojo inputMessage) {
    _logger.info("CompleteTask# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      KeyPojo taskKey = impl.changeTaskStatus(inputMessage.getTaskInstId(),
                                              _woTaskStatusMgmt.getNameForCode(7),
                                              inputMessage.getUserId());

      if(taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("CompleteTask# received: " + inputMessage + "; response: " + result);

    return result;
  }



  @WebMethod(operationName="completeBlockedTask", action="completeBlockedTask")
  @WebResult(name="ResultMessage")
  public ResultPojo completeBlockedTask(@WebParam(name="CompleteBlockedTaskInputMessage")
                                        CompleteBlockedTaskPojo inputMessage) {
    _logger.info("completeBlockedTask# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      KeyPojo taskKey = impl.completeBlockedTask(inputMessage.getSourceTaskInstId(),
                                                 inputMessage.getBlockingTaskInstId(),
                                                 inputMessage.getNewQueueName(),
                                                 inputMessage.getUserId());

      if(taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("completeBlockedTask# received: " + inputMessage + "; response: " + result);

    return result;
  }


  @WebMethod(operationName="moveTaskToNewQueue", action="moveTaskToNewQueue")
  @WebResult(name="ResultMessage")
  public ResultPojo moveTaskToNewQueue(@WebParam(name="MoveTaskToNewQueueInputMessage")
                                       MoveTaskToNewQueuePojo inputMessage) {
    _logger.info("moveTaskOnNewQueue# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      KeyPojo taskKey = impl.moveTaskToNewQueue(inputMessage.getTaskInstId(),
                                                inputMessage.getNewQueueName(),
                                                inputMessage.getUserId());

      if(taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("moveTaskToNewQueue# received: " + inputMessage + "; response: " + result);

    return result;
  }




  @WebMethod(operationName="updateOLT_ONTInfo", action="updateOLT_ONTInfo")
  @WebResult(name="ResultMessage")
  public ResultPojo updateOLT_ONTInfo(@WebParam(name="UpdateOLT_ONTInfoInputMessage")
                                      UpdateOLT_ONTInfoPojo inputMessage) {
    _logger.info("updateOLT_ONTInfo# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      // managing OLT update
      UpdateOLTInfoPojo oltInfoPojo = inputMessage.getUpdateOLTInfoPojo();
      UDAPojo[] udaPojoArrayList = new UDAPojo[oltInfoPojo.getUdaDetailsPojos().length];

      for(int i=0; i<oltInfoPojo.getUdaDetailsPojos().length; i++) {
        UDADetailsPojo udaDetailsPojo = oltInfoPojo.getUdaDetailsPojos()[i];

        udaPojoArrayList[i] = new UDAPojo();
        udaPojoArrayList[i].setUdaName(udaDetailsPojo.getUdaName());
        udaPojoArrayList[i].setUdaGroup(udaDetailsPojo.getUdaGroup());
        udaPojoArrayList[i].setUdaValue(udaDetailsPojo.getUdaValue());
      }

      KeyPojo taskKey = impl.updateOLTInfo(oltInfoPojo.getPortInstId(),
                                           oltInfoPojo.getEquipInstId(),
                                           udaPojoArrayList);

      if(taskKey != null) {
        // previous operation was success so performing the update of the ONT
        UpdateONTInfoPojo ontInfoPojo = inputMessage.getUpdateONTInfoPojo();
        UDAPojo[] udaPojoArrayListForONT = new UDAPojo[ontInfoPojo.getUdaDetailsPojos().length];

        for(int i=0; i<ontInfoPojo.getUdaDetailsPojos().length; i++) {
          UDADetailsPojo udaDetailsPojo = ontInfoPojo.getUdaDetailsPojos()[i];

          udaPojoArrayListForONT[i] = new UDAPojo();
          udaPojoArrayListForONT[i].setUdaName(udaDetailsPojo.getUdaName());
          udaPojoArrayListForONT[i].setUdaGroup(udaDetailsPojo.getUdaGroup());
          udaPojoArrayListForONT[i].setUdaValue(udaDetailsPojo.getUdaValue());
        }
        taskKey = impl.updateONTInfo(ontInfoPojo.getEquipInstId(),
                                     ontInfoPojo.getSerialNo(),
                                     ontInfoPojo.getTaskInstId(),
                                     ontInfoPojo.getUserId(),
                                     udaPojoArrayListForONT);

        if (taskKey != null) {
          result = generateSuccessResult();
        }
      }

      if(result == null) {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("updateOLT_ONTInfo# received: " + inputMessage + "; response: " + result);

    return result;
  }

  @WebMethod(operationName="updateUDAsForTask", action="updateUDAsForTask")
  @WebResult(name="ResultMessage")
  public ResultPojo updateUDAsForTask(@WebParam(name="UpdateUDAsForTaskInputMessage")
                                          UpdateUDAsForTaskPojo inputMessage) {
    _logger.info("updateUDAsForTask# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      UDAPojo[] udaPojos = new UDAPojo[inputMessage.getUdaDetailsPojos().length];
      for(int i=0; i<udaPojos.length; i++) {
        udaPojos[i] = new UDAPojo();
        udaPojos[i].setUdaName(inputMessage.getUdaDetailsPojos()[i].getUdaName());
        udaPojos[i].setUdaGroup(inputMessage.getUdaDetailsPojos()[i].getUdaGroup());
        udaPojos[i].setUdaValue(inputMessage.getUdaDetailsPojos()[i].getUdaValue());
      }
      KeyPojo taskKey = impl.updateUDAsForTask(inputMessage.getTaskInstId(),
                                               udaPojos,
                                               inputMessage.getUserId());

      if (taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("updateUDAsForTask# received: " + inputMessage + "; response: " + result);

    return result;
  }

  @WebMethod(operationName="updateUDAsForWorkOrder", action="updateUDAsForWorkOrder")
  @WebResult(name="ResultMessage")
  public ResultPojo updateUDAsForWorkOrder(@WebParam(name="UpdateUDAsForWorkOrderInputMessage")
                                                 UpdateUDAsForWorkOrderPojo inputMessage) {
    _logger.info("updateUDAsForWorkOrder# received: " + inputMessage);

    ResultPojo result = _inputValidation.performValidation(inputMessage);
    if(result != null) {
      return result;
    }

    GraniteService impl = null;

    try {
      impl = new GraniteServiceImpl();
      impl.startupASIFactory();

      UDAPojo[] udaPojos = new UDAPojo[inputMessage.getUdaDetailsPojos().length];
      for(int i=0; i<udaPojos.length; i++) {
        udaPojos[i] = new UDAPojo();
        udaPojos[i].setUdaName(inputMessage.getUdaDetailsPojos()[i].getUdaName());
        udaPojos[i].setUdaGroup(inputMessage.getUdaDetailsPojos()[i].getUdaGroup());
        udaPojos[i].setUdaValue(inputMessage.getUdaDetailsPojos()[i].getUdaValue());
      }
      KeyPojo taskKey = impl.updateUDAsForWorkOrder(inputMessage.getWorkOrderInstId(),
                                                    udaPojos,
                                                    inputMessage.getUserId());

      if (taskKey != null) {
        result = generateSuccessResult();
      }
      else {
        result = generateErrorResult(null);
      }
    }
    catch(Exception exc) {
      _logger.error(exc);
      result = generateErrorResult(exc);
    }
    finally {
      if(impl != null) {
        try {
          impl.shutdownASIFactory();
        }
        catch (Throwable t) {
          _logger.error(t);
        }
      }
    }

    _logger.info("updateUDAsForWorkOrder# received: " + inputMessage + "; response: " + result);

    return result;
  }

  private ResultPojo generateSuccessResult() {
    ResultPojo resultPojo = new ResultPojo();
    resultPojo.setResult("SUCCESS");

    return resultPojo;
  }

  private ResultPojo generateErrorResult(Exception exc) {
    ResultPojo resultPojo = new ResultPojo();
    resultPojo.setResult("ERROR");
    resultPojo.setErrorCode("GRANITE_ASI_ERROR");
    resultPojo.setErrorDescription(exc == null ? "Unexpected error" : exc.getMessage());
    return resultPojo;
  }


  public static void main(String[] args) {
    GraniteServiceForEOCImpl wsImpl = new GraniteServiceForEOCImpl();
    ChangeTaskStatusPojo input = new ChangeTaskStatusPojo();
    input.setTaskInstId(1864790);
    input.setNewStatusCode(7);
    ResultPojo resultPojo = wsImpl.changeTaskStatus(input);

    /*
    CompleteTaskPojo input = new CompleteTaskPojo();
    input.setTaskInstId(20779758);
    input.setUserId("User Id");
    ResultPojo resultPojo = wsImpl.completeTask(input);
    System.out.println("Result = " + resultPojo);
    */

    /*
    CompleteBlockedTaskPojo completeBlockedTaskPojo = new CompleteBlockedTaskPojo();
    completeBlockedTaskPojo.setSourceTaskInstId(1864815);
    completeBlockedTaskPojo.setBlockingTaskInstId(1864813);
    completeBlockedTaskPojo.setNewQueueName("GLOXBAL SIGNALLING");

    ResultPojo resultPojo = wsImpl.completeBlockedTask(completeBlockedTaskPojo);
    System.out.println("Result = " + resultPojo);
    */

    /*
    MoveTaskToNewQueuePojo moveTaskToNewQueuePojo = new MoveTaskToNewQueuePojo();
    moveTaskToNewQueuePojo.setTaskInstId(1864815);
    moveTaskToNewQueuePojo.setNewQueueName("GLOXBAL SIGNALLING");
    ResultPojo resultPojo = wsImpl.moveTaskToNewQueue(moveTaskToNewQueuePojo);
    */


    /*
    UpdateOLTInfoPojo updateOLTInfoPojo = new UpdateOLTInfoPojo();
    updateOLTInfoPojo.setEquipInstId(313923);
    updateOLTInfoPojo.setPortInstId(21367499);

    UDADetailsPojo[] udaDetailsPojo = new UDADetailsPojo[3];
    udaDetailsPojo[0] = new UDADetailsPojo();
    udaDetailsPojo[0].setUdaGroup("OLT Attributes Information");
    udaDetailsPojo[0].setUdaName("OLT Name");
    udaDetailsPojo[0].setUdaValue("102-00_DBATRD00OL0");

    udaDetailsPojo[1] = new UDADetailsPojo();
    udaDetailsPojo[1].setUdaGroup("OLT Attributes Information");
    udaDetailsPojo[1].setUdaName("OLT Physical Slot");
    udaDetailsPojo[1].setUdaValue("08");

    udaDetailsPojo[2] = new UDADetailsPojo();
    udaDetailsPojo[2].setUdaGroup("OLT Attributes Information");
    udaDetailsPojo[2].setUdaName("OLT Physical Port");
    udaDetailsPojo[2].setUdaValue("5");

    updateOLTInfoPojo.setUdaDetailsPojos(udaDetailsPojo);


    UpdateONTInfoPojo updateONTInfoPojo = new UpdateONTInfoPojo();
    updateONTInfoPojo.setEquipInstId(2045662);
    updateONTInfoPojo.setSerialNo("485709932XXX901AP12");
    updateONTInfoPojo.setTaskInstId(21629266);
    updateONTInfoPojo.setUserId("GINO");
    UDADetailsPojo[] udaDetailsPojoForONT = new UDADetailsPojo[1];
    udaDetailsPojoForONT[0] = new UDADetailsPojo();
    udaDetailsPojoForONT[0].setUdaGroup("ONT/Customer Details");
    udaDetailsPojoForONT[0].setUdaName("ONT ID");
    udaDetailsPojoForONT[0].setUdaValue("90");
    updateONTInfoPojo.setUdaDetailsPojos(udaDetailsPojoForONT);


    UpdateOLT_ONTInfoPojo updateOLT_ONTInfoPojo = new UpdateOLT_ONTInfoPojo();
    updateOLT_ONTInfoPojo.setUpdateOLTInfoPojo(updateOLTInfoPojo);
    updateOLT_ONTInfoPojo.setUpdateONTInfoPojo(updateONTInfoPojo);

    ResultPojo resultPojo = wsImpl.updateOLT_ONTInfo(updateOLT_ONTInfoPojo);

    */

    /*
    UpdateUDAsForTaskPojo updateUDAsForTaskPojo = new UpdateUDAsForTaskPojo();
    updateUDAsForTaskPojo.setTaskInstId(1676636);
    UDADetailsPojo[] udaDetailsPojos = new UDADetailsPojo[1];
    udaDetailsPojos[0] = new UDADetailsPojo();
    udaDetailsPojos[0].setUdaName("FO Group Name");
    udaDetailsPojos[0].setUdaGroup("Task Info");
    udaDetailsPojos[0].setUdaValue("GINO");
    updateUDAsForTaskPojo.setUdaDetailsPojos(udaDetailsPojos);
    updateUDAsForTaskPojo.setUserId("userId");

    ResultPojo resultPojo = wsImpl.updateUDAsForTask(updateUDAsForTaskPojo);
    */

    System.out.println("Result = " + resultPojo);

  }
}
