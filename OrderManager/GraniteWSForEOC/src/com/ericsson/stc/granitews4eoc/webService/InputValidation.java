package com.ericsson.stc.granitews4eoc.webService;

import com.ericsson.stc.granitews4eoc.utility.PropertyReader;
import com.ericsson.stc.granitews4eoc.webService.pojo.*;

/**
 * To perform the validation on the incoming request.
 */
public class InputValidation {

  private PropertyReader _propertyReader = PropertyReader.getInstance();

  /**
   * To perform validation on the input parameter for ChangeTaskStatus operation.
   *
   * @param changeTaskStatusPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(ChangeTaskStatusPojo changeTaskStatusPojo) {
    ResultPojo validationResult = null;
    if(changeTaskStatusPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(changeTaskStatusPojo.getTaskInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'TaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(changeTaskStatusPojo.getNewStatusCode() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'NewStatusCode'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(changeTaskStatusPojo.getNewStatusCode() != 4 &&
            changeTaskStatusPojo.getNewStatusCode() != 7 &&
            changeTaskStatusPojo.getNewStatusCode() != 8 ) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE003");
      String[] values = {"'" + changeTaskStatusPojo.getNewStatusCode() + "'",
                         "(4,  7, 8)"};
      validationResult.setErrorDescription(getErrorDescription("WSE003", values));
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for CompleteTask operation.
   *
   * @param completeTaskPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(CompleteTaskPojo completeTaskPojo) {
    ResultPojo validationResult = null;
    if(completeTaskPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(completeTaskPojo.getTaskInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'TaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for CompleteBlockedTask operation.
   *
   * @param completeBlockedTaskPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(CompleteBlockedTaskPojo completeBlockedTaskPojo) {
    ResultPojo validationResult = null;
    if(completeBlockedTaskPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(completeBlockedTaskPojo.getBlockingTaskInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'BlockingTaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(completeBlockedTaskPojo.getSourceTaskInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'SourceTaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(isEmptyOrNull(completeBlockedTaskPojo.getNewQueueName())) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'NewQueueName'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for MoveTaskToNewQueue operation.
   *
   * @param moveTaskToNewQueuePojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(MoveTaskToNewQueuePojo moveTaskToNewQueuePojo) {
    ResultPojo validationResult = null;
    if(moveTaskToNewQueuePojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(moveTaskToNewQueuePojo.getTaskInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'TaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(isEmptyOrNull(moveTaskToNewQueuePojo.getNewQueueName())) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'NewQueueName'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }

    return validationResult;
  }


  /**
   * To perform validation on the input parameter for UpdateOLT_ONTInfo operation.
   *
   * @param updateOLT_ONTInfoPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(UpdateOLT_ONTInfoPojo updateOLT_ONTInfoPojo) {
    ResultPojo validationResult = null;
    if (updateOLT_ONTInfoPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(updateOLT_ONTInfoPojo.getUpdateOLTInfoPojo() == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UpdateOLTInfoPojo'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateOLT_ONTInfoPojo.getUpdateONTInfoPojo() == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UpdateONTInfoPojo'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else {
      validationResult = performValidation(updateOLT_ONTInfoPojo.getUpdateOLTInfoPojo());
      if(validationResult == null) {
        validationResult = performValidation(updateOLT_ONTInfoPojo.getUpdateONTInfoPojo());
      }
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for UpdateUDAsForTask operation.
   *
   * @param updateUDAsForTaskPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(UpdateUDAsForTaskPojo updateUDAsForTaskPojo) {
    ResultPojo validationResult = null;
    if (updateUDAsForTaskPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(updateUDAsForTaskPojo.getTaskInstId() <= 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'TaskInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateUDAsForTaskPojo.getUdaDetailsPojos() == null || updateUDAsForTaskPojo.getUdaDetailsPojos().length == 0 ) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDADetailsPojos'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else {
      for (UDADetailsPojo udaDetailsPojo : updateUDAsForTaskPojo.getUdaDetailsPojos()) {
        validationResult = performValidation(udaDetailsPojo);
        if (validationResult != null) {
          break;
        }
      }
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for UpdateUDAsForWorkOrder operation.
   *
   * @param updateUDAsForWorkOrderPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  public ResultPojo performValidation(UpdateUDAsForWorkOrderPojo updateUDAsForWorkOrderPojo) {
    ResultPojo validationResult = null;
    if (updateUDAsForWorkOrderPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(updateUDAsForWorkOrderPojo.getWorkOrderInstId() <= 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'WorkOrderInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateUDAsForWorkOrderPojo.getUdaDetailsPojos() == null || updateUDAsForWorkOrderPojo.getUdaDetailsPojos().length == 0 ) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDADetailsPojos'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else {
      for (UDADetailsPojo udaDetailsPojo : updateUDAsForWorkOrderPojo.getUdaDetailsPojos()) {
        validationResult = performValidation(udaDetailsPojo);
        if (validationResult != null) {
          break;
        }
      }
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for UpdateOLTInfo operation.
   *
   * @param updateOLTInfoPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  private ResultPojo performValidation(UpdateOLTInfoPojo updateOLTInfoPojo) {
    ResultPojo validationResult = null;
    if(updateOLTInfoPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(updateOLTInfoPojo.getPortInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'PortInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateOLTInfoPojo.getEquipInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'EquipInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateOLTInfoPojo.getUdaDetailsPojos() == null ||
            updateOLTInfoPojo.getUdaDetailsPojos().length == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDADetailsPojos'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else {
      for(UDADetailsPojo udaDetailsPojo: updateOLTInfoPojo.getUdaDetailsPojos()) {
        validationResult = performValidation(udaDetailsPojo);
        if(validationResult != null) {
          break;
        }
      }
    }

    return validationResult;
  }

  /**
   * To perform validation on the input parameter for UpdateOLTInfo operation.
   *
   * @param updateONTInfoPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  private ResultPojo performValidation(UpdateONTInfoPojo updateONTInfoPojo) {
    ResultPojo validationResult = null;
    if(updateONTInfoPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(updateONTInfoPojo.getEquipInstId() == 0) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'EquipInstId'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(updateONTInfoPojo.getUdaDetailsPojos() == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDADetailsPojos'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else {
      for(UDADetailsPojo udaDetailsPojo: updateONTInfoPojo.getUdaDetailsPojos()) {
        validationResult = performValidation(udaDetailsPojo);
        if(validationResult != null) {
          break;
        }
      }
    }

    return validationResult;
  }

  /**
   * To perform validation on the generic element .
   *
   * @param udaDetailsPojo the object to validate.
   * @return the error found or null if validation is passed successfully.
   */
  private ResultPojo performValidation(UDADetailsPojo udaDetailsPojo) {
    ResultPojo validationResult = null;
    if(udaDetailsPojo == null) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE001");
      validationResult.setErrorDescription(getErrorDescription("WSE001"));
    }
    else if(isEmptyOrNull(udaDetailsPojo.getUdaName())) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDA Name'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }
    else if(isEmptyOrNull(udaDetailsPojo.getUdaGroup())) {
      validationResult = new ResultPojo();
      validationResult.setResult("ERROR");
      validationResult.setErrorCode("WSE002");
      String[] values = {"'UDA Group'"};
      validationResult.setErrorDescription(getErrorDescription("WSE002", values));
    }

    return validationResult;
  }












  /**
   * To get the error description linked to the provided error code without replacing any values in the string.
   *
   * @param errorCode the error code.
   * @return the error description linked to the error code provided.
   */
  private String getErrorDescription(String errorCode) {
    return getErrorDescription(errorCode, null);
  }

  /**
   * To get the error description linked to the provided error code replacing any values in the string
   * with the provided values.
   *
   * @param errorCode the error code.
   * @param replaceValues the values that will be put in the description instead of the placeholders.
   * @return the error description linked to the error code provided.
   */
  private String getErrorDescription(String errorCode, String[] replaceValues) {
    String errorDescription = _propertyReader.getProperty(errorCode);
    if(errorDescription != null) {
      if(replaceValues != null) {
        for (int i = 0; i < replaceValues.length; i++) {
          errorDescription = errorDescription.replace("{" + i + "}", replaceValues[i]);
        }
      }
    }
    else {
      errorDescription = errorCode;
      if(replaceValues != null) {
        errorDescription = errorDescription + "[";
        for(int i=0; i<replaceValues.length; i++) {

          errorDescription = errorDescription + (i == 0 ? "" : ",") + replaceValues[i];
        }
      }
    }

    return errorDescription;
  }

  private boolean isEmptyOrNull(String toBeChecked) {
    return (toBeChecked == null || toBeChecked.trim().length() == 0);
  }
}
