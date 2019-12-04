CREATE OR REPLACE PACKAGE VALIDATE_EOC_EBU_DATA IS

  TYPE validation_response_arr IS TABLE OF VARCHAR2(2000);

  /***
    It checks that there is max 1 record for each lineItemIdentifier with the given provisioningFlag.
    The function should return null otherwise an array with all the records not matching the condition.
   ***/
  FUNCTION check_count_provisioningFlag(provisioningFlag IN VARCHAR2) RETURN validation_response_arr;

  /***
    It checks that the orderStatus for all the not migrated orders should be valid.
    Valid values are: CANCELLED, COMPLETED, FAILED_SUBMIT, IN-PROGRESS, ON-HOLD, ORDERED
    If they are not valid, they should be associated to cancelled or revised versions of the order itself.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_order_status RETURN validation_response_arr;

  /***
    It checks that the lineItemStatus for all the not migrated orders should be valid.
    Valid values are: ACTIVATE CIRCUIT, CANCELLED, COMPLETED, DESIGN CREATED, FAILED, FAILED_SUBMIT, IN-HELD, IN-PROCESS, IN-PROGRESS, ON-HOLD, ORDERED, READY, REJECTED.
    If they are not valid, they should be associated to cancelled or revised versions of the order itself.
    Hold and NEW status are questionable statuses:
    Hold is a valid status only if it’s related to a service whose parent circuit is still in provisioning or
    to a circuit whose child service is still in provisioning in case of Disconnect or Suspend order.
    NEW is a valid status only in case the provisioning process for the order is still in execution.

    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_lineitem_status RETURN validation_response_arr;

  /***
    It checks that that are no orders revised or cancelled in EOC with provisioningFlag different from OLD.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_updated_order_pf RETURN validation_response_arr;

  /***
    It checks that there are no orders revised or cancelled in EOC whose provisioning process is still in execution.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_updated_order_pr RETURN validation_response_arr;

  /***
    It checks that the provisioningFlag for all the not migrated orders should be valid.
    Valid values are: OLD, ACTIVE, PROVISIONING, CANCELLED or null.
    Null value is acceptable only in case the lineItem has elementTypeInOrderTree equals to 'C' or 'S'.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_provisioningFlag RETURN validation_response_arr;

  /***
    It checks that there are no orders (not revised or cancelled) in status "CANCELLED" in EOC for
    which the flag "isCancel" on lineItem is not set.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_fake_cancelled RETURN validation_response_arr;

  /***
    It checks that all the SIP circuits in Granite are also in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_circuits RETURN validation_response_arr;

  /***
    It checks that, for all the SIP circuits in Granite and in EOC, the UDA "Parent Bundle Id" is set.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_bundleId_missing RETURN validation_response_arr;

  /***
    It checks that, for all the SIP circuits in Granite, the UDA "Parent Bundle Id" is set with the same
    value of the serviceNumber of the ParentLineItem in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_bundleId RETURN validation_response_arr;

  /***
    It checks that, for all the SIP circuits in Granite, the SIP parent services in Granite are also in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_services_GI RETURN validation_response_arr;

  /***
    It checks that, for all the SIP circuits in Granite, there are no services in EOC that are not in Granite, too.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_services_EOC RETURN validation_response_arr;

  /***
    To log messages. It insert into the log table.
  ***/
  PROCEDURE log_validation_failed(errorCode IN VARCHAR2, errorDescription IN VARCHAR2);

  /***
    To initialize or extend the response array
  ***/
  PROCEDURE extend_result(response IN OUT validation_response_arr);

  /***
    The MAIN!
    It invokes all the validation functions and, in case of errors, it dumps the errors found in the table using the procedure "log".
   ***/
  PROCEDURE perform_all_checks;

END VALIDATE_EOC_EBU_DATA;
/