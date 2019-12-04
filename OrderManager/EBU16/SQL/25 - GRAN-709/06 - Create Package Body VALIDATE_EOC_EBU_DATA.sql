CREATE OR REPLACE PACKAGE BODY VALIDATE_EOC_EBU_DATA IS

  /***
    It checks that there is max 1 record for each lineItemIdentifier with the given provisioningFlag.
    The function should return null otherwise an array with all the records not matching the condition.
   ***/
  FUNCTION check_count_provisioningFlag(provisioningFlag IN VARCHAR2) RETURN validation_response_arr IS
    CURSOR count_provisioning(provFlag VARCHAR2) IS
      SELECT l.lineitemidentifier, COUNT(*) tot
        FROM stc_lineitem l
       WHERE l.provisioningflag = provFlag
      GROUP BY l.lineitemidentifier
      HAVING COUNT(*)> 1;

    response validation_response_arr;
    position NUMBER;
  BEGIN
    position := 1;
    FOR c IN count_provisioning(provisioningFlag) LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found '||c.tot||' records with provisioningFlag '''||provisioningFlag||''' for '''||c.lineItemIdentifier||'''';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_count_provisioningFlag;


  /***
    It checks that the orderStatus for all the not migrated orders should be valid.
    Valid values are: CANCELLED, COMPLETED, FAILED_SUBMIT, IN-PROGRESS, ON-HOLD, ORDERED
    If they are not valid, they should be associated to cancelled or revised versions of the order itself.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_order_status RETURN validation_response_arr IS
    CURSOR wrong_order_status IS
      SELECT orderNumber, orderStatus
        FROM stc_bundleorder_header
       WHERE ismigrated = 0
         AND orderStatus NOT IN ('CANCELLED', 'COMPLETED', 'FAILED_SUBMIT', 'IN-PROGRESS', 'ON-HOLD', 'ORDERED')
         AND orderNumber NOT LIKE '%_REVI_%'
         AND ordernumber NOT LIKE '%_CANC_%'
      ORDER BY orderstatus;

    response validation_response_arr;
    position NUMBER;
  BEGIN
    position := 1;
    FOR c IN wrong_order_status LOOP
      BEGIN
        extend_result(response);
        -- found an order with wrong status
        response(position) := 'Found a record (orderNumber: '||c.orderNumber||') with wrong orderStatus: '''||c.orderStatus||'''';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_order_status;

  /***
    It checks that the lineItemStatus for all the not migrated orders should be valid.
    Valid values are: ACTIVATE CIRCUIT, CANCELLED, COMPLETED, DESIGN CREATED, FAILED, FAILED_SUBMIT, IN-HELD, IN-PROCESS,
                      IN-PROGRESS, ON-HOLD, ORDERED, READY, REJECTED.
    If they are not valid, they should be associated to cancelled or revised versions of the order itself.
    Hold and NEW status are questionable statuses:
    Hold is a valid status only if it’s related to a service whose parent circuit is still in provisioning
    or to a circuit whose child service is still in provisioning in case of Disconnect or Suspend order.
    NEW is a valid status only in case the provisioning process for the order is still in execution.

    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_lineitem_status RETURN validation_response_arr IS
    CURSOR wrong_lineitem_status IS
      SELECT h.orderNumber, h.orderStatus, l.lineItemIdentifier, l.lineItemStatus,
             (SELECT COUNT(*) FROM cwprocess p WHERE p.order_id = h.cworderid AND status IN (1, 2, 4, 5)) proc_exec,
             (SELECT COUNT(*) FROM cwprocess p WHERE p.process_id = o.provisioningprocessid AND status IN (1, 2, 4, 5)) proc_exec_li
        FROM stc_bundleorder_header h, stc_lineitem l, stc_order_orchestration o
       WHERE h.ismigrated = 0
         AND l.lineItemStatus NOT IN ('ACTIVATE CIRCUIT', 'CANCELLED', 'COMPLETED', 'DESIGN CREATED', 'FAILED', 'FAILED_SUBMIT', 'IN-HELD',
                                      'IN-PROCESS', 'IN-PROGRESS', 'ON-HOLD', 'ORDERED', 'READY', 'REJECTED')
         AND h.orderNumber NOT LIKE '%_REVI_%'
         AND h.ordernumber NOT LIKE '%_CANC_%'
         AND h.cworderid = l.cworderid
         AND o.cwdocid = l.cwdocid
      ORDER BY l.lineItemStatus;

    response validation_response_arr;
    position NUMBER;
    isRealError CHAR(1);
  BEGIN
    position := 1;
    FOR c IN wrong_lineitem_status LOOP
      BEGIN
        isRealError := 'N';
        IF(c.lineItemStatus = 'Hold') THEN
          BEGIN
            -- check if it's one of the allowed cases for "Hold"
            IF(c.proc_exec_li > 0 or c.proc_exec > 0) THEN
              isRealError := 'N';
            ELSE
              isRealError := 'Y';
            END IF;
          END;
        ELSIF (c.lineItemStatus = 'NEW') THEN
          BEGIN
            -- not an issue if there is at least a process linked to the lineitem in execution
            IF(c.proc_exec_li > 0) THEN
              isRealError := 'N';
            ELSE
              isRealError := 'Y';
            END IF;
          END;
        ELSE
          isRealError := 'Y';
        END IF;

        IF(isRealError = 'Y') THEN
          -- found a lineItem with wrong status
          extend_result(response);
          response(position) := 'Found a record (orderNumber: '||c.orderNumber||', lineItemId: <'||c.lineItemIdentifier||'>) with wrong lineItemStatus: '''||c.lineItemStatus||'''';
          position := position + 1;
        END IF;
      END;
    END LOOP;

    RETURN response;
  END check_lineitem_status;

  /***
    It checks that that are no orders revised or cancelled in EOC with provisioningFlag different from OLD.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_updated_order_pf RETURN validation_response_arr IS
    CURSOR wrong_provisioningFlag IS
      SELECT h.orderNumber, l.lineItemIdentifier, l.cwdocid, l.provisioningFlag
        FROM stc_bundleorder_header h, stc_lineitem l
       WHERE h.cworderid = l.cworderid
         AND l.elementtypeinordertree = 'B'
         AND (h.ordernumber like '%_REVI_%' or h.ordernumber like '%_CANC_%')
         AND l.provisioningflag <> 'OLD';

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN wrong_provisioningFlag LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a lineItem ('||c.lineItemIdentifier||', '||c.cwdocid||') for a revised order ('||c.orderNumber||') with invalid provisioningFlag: : '||c.provisioningFlag;
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_updated_order_pf;

  /***
    It checks that there are no orders revised or cancelled in EOC whose provisioning process is still in execution.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_updated_order_pr RETURN validation_response_arr IS
    CURSOR wrong_provisioningFlag IS
      SELECT h.orderNumber, l.provisioningFlag
        FROM stc_bundleorder_header h, stc_lineitem l
       WHERE h.cworderid = l.cworderid
         AND l.elementtypeinordertree = 'B'
         AND (h.ordernumber like '%_REVI_%' or h.ordernumber like '%_CANC_%')
         AND (SELECT COUNT(*) FROM cwprocess p WHERE p.order_id = h.cworderid AND status IN (1, 2, 4, 5)) > 0;

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN wrong_provisioningFlag LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found at least a process still in execution for a revised order: '||c.orderNumber||') with invalid provisioningFlag: '||c.provisioningFlag;
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_updated_order_pr;

  /***
    It checks that the provisioningFlag for all the not migrated orders should be valid.
    Valid values are: OLD, ACTIVE, PROVISIONING, CANCELLED or null.
    Null value is acceptable only in case the lineItem has elementTypeInOrderTree equals to 'C' or 'S'.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_provisioningFlag RETURN validation_response_arr IS
    CURSOR wrong_provisioningFlag IS
      -- PLI NOT NULL BUT WRONG
      SELECT provisioningFlag, lineItemIdentifier, elementTypeInOrderTree, cwdocid
        FROM stc_lineitem
       WHERE elementTypeInOrderTree = 'B'
         AND provisioningFlag NOT IN ('ACTIVE', 'OLD', 'PROVISIONING', 'CANCELLED')
      UNION
      -- PLI NULL
      SELECT provisioningFlag, lineItemIdentifier, elementTypeInOrderTree, cwdocid
        FROM stc_lineitem
       WHERE elementTypeInOrderTree = 'B'
         AND provisioningFlag IS NULL
      UNION
      -- CIRCUIT & SERVICE
      SELECT provisioningFlag, lineItemIdentifier, elementTypeInOrderTree, cwdocid
        FROM stc_lineitem
       WHERE elementTypeInOrderTree in ('C', 'S')
         AND (provisioningFlag IS NOT NULL)
      ORDER BY 1, 3;

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN wrong_provisioningFlag LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a lineItem ('||c.lineItemIdentifier||'; '||c.cwdocid||'; '||c.elementTypeInOrderTree||') with invalid provisioningFlag: '||NVL(c.provisioningFlag, '''NULL''');
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_provisioningFlag;

  /***
    It checks that there are no orders (not revised or cancelled) in status "CANCELLED" in EOC for
    which the flag "isCancel" on lineItem is not set.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_fake_cancelled RETURN validation_response_arr IS
    CURSOR wrong_cancelled IS
      SELECT h.ordernumber, l.lineitemidentifier
        FROM stc_bundleorder_header h, stc_lineitem l
       WHERE l.iscancel = 0
         AND (provisioningflag = 'CANCELLED' OR orderStatus = 'CANCELLED')
         AND l.cworderid = h.cworderid
         AND h.ismigrated = 0
         AND h.ordernumber not like '%_CANC_%'
         AND h.ordernumber not like '%_REVI_%';

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN wrong_cancelled LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a record (orderNumber: '||c.orderNumber||', lineItemId: '||c.lineItemIdentifier||') with orderStatus or provisioningFlag CANCELLED and isCancel = 0';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_fake_cancelled;

  /***
    It checks that all the SIP circuits in Granite are also in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_circuits RETURN validation_response_arr IS
    CURSOR missing_SIP IS
      SELECT cpi.circ_path_hum_id serviceNumber
        FROM circ_path_inst@rms_prod_db_link cpi, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
       WHERE cpi.circ_path_inst_id = ra.target_inst_id
         AND ra.resource_inst_id = ri.resource_inst_id
         AND ri.category like '%SIP%'
         AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
         AND ra.target_type_id = 10
      MINUS
      SELECT c.serviceNumber
        FROM stc_lineitem b, stc_lineitem c
       WHERE b.elementtypeinordertree = 'B'
         AND c.elementtypeinordertree = 'C'
         AND c.cworderid = b.cworderid
         AND b.provisioningflag in ('ACTIVE', 'PROVISIONING');
    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN missing_SIP LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a SIP circuit that is in Granite but not in EOC: '||c.serviceNumber;
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_SIP_circuits;

  /***
    It checks that, for all the SIP circuits in Granite and in EOC, the UDA "Parent Bundle Id" is set.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_bundleId_missing RETURN validation_response_arr IS
    CURSOR missing_SIP_bundleId IS
      SELECT cpi.circ_path_hum_id serviceNumber,
             (SELECT DISTINCT b.serviceNumber
                FROM stc_lineitem b, stc_lineitem c
               WHERE b.elementtypeinordertree = 'B'
                 AND c.elementtypeinordertree = 'C'
                 AND c.cworderid = b.cworderid
                 AND b.provisioningflag in ('ACTIVE', 'PROVISIONING')
                 AND c.serviceNumber = cpi.circ_path_hum_id) bundleId_EOC
        FROM circ_path_inst@rms_prod_db_link cpi, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
       WHERE cpi.circ_path_inst_id = ra.target_inst_id
         AND ra.resource_inst_id = ri.resource_inst_id
         AND ri.category like '%SIP%'
         AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
         AND ra.target_type_id = 10
         AND cpi.circ_path_inst_id NOT IN (SELECT cpas.circ_path_inst_id
                                             FROM circ_path_attr_settings@rms_prod_db_link cpas
                                            WHERE cpas.val_attr_inst_id = 8987);

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN missing_SIP_bundleId LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a SIP circuit ('||c.serviceNumber||') in Granite without bundleParentId but set in EOC ('||NVL(c.bundleId_EOC, '<PLI ''ACTIVE'' or ''PROVISIONING'' not found>')||')';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_SIP_bundleId_missing;

  /***
    It checks that, for all the SIP circuits in Granite, the UDA "Parent Bundle Id" is set with the same
    value of the serviceNumber of the ParentLineItem in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_bundleId RETURN validation_response_arr IS
    CURSOR gi_sip IS
      SELECT DISTINCT serviceNumber, bundleParentId, bundleId_EOC
        FROM (
              SELECT cpi.circ_path_hum_id serviceNumber,
                     cpas.attr_value bundleParentId,
                     (SELECT DISTINCT b.serviceNumber
                        FROM stc_lineitem b, stc_lineitem c
                       WHERE b.elementtypeinordertree = 'B'
                         AND c.elementtypeinordertree = 'C'
                         AND c.cworderid = b.cworderid
                         AND b.provisioningflag in ('ACTIVE', 'PROVISIONING')
                         AND c.serviceNumber = cpi.circ_path_hum_id) bundleId_EOC
                FROM circ_path_inst@rms_prod_db_link cpi, circ_path_attr_settings@rms_prod_db_link cpas,
                     resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
               WHERE cpi.circ_path_inst_id = ra.target_inst_id
                 AND ra.resource_inst_id = ri.resource_inst_id
                 AND ri.category like '%SIP%'
                 AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
                 AND ra.target_type_id = 10
                 AND cpas.val_attr_inst_id = 8987
                 AND cpi.circ_path_inst_id = cpas.circ_path_inst_id)
       WHERE bundleParentId <> bundleId_EOC;

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN gi_sip LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a SIP circuit ('||c.serviceNumber||') in Granite with parentBundleId ('||c.bundleParentId||') but different from EOC ('||c.bundleId_EOC||')';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_SIP_bundleId;

  /***
    It checks that, for all the SIP circuits in Granite, the SIP parent services in Granite are also in EOC.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_services_GI RETURN validation_response_arr IS
    CURSOR gi_sip_services IS
      SELECT cpi.circ_path_hum_id serviceNumber,
             ri.name,
             ri.category
        FROM circ_path_inst@rms_prod_db_link cpi, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
       WHERE cpi.circ_path_inst_id = ra.target_inst_id
         AND ra.resource_inst_id = ri.resource_inst_id
         AND ri.category like '%SIP%'
         AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
         AND ra.target_type_id = 10
      MINUS
      SELECT c.serviceNumber,
             s.serviceNumber name,
             s.serviceType category
        FROM stc_lineitem b, stc_lineitem c, stc_lineitem s
       WHERE b.elementtypeinordertree = 'B'
         AND c.elementtypeinordertree = 'C'
         AND s.elementtypeinordertree = 'S'
         AND c.cworderid = b.cworderid
         AND s.cworderid = c.cworderid
         AND b.provisioningflag in ('ACTIVE', 'PROVISIONING');

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN gi_sip_services LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a '||c.category||' parent service ('||c.name||') in Granite for the SIP circuit ('||c.serviceNumber||') that is not in EOC';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;
  END check_SIP_services_GI;

  /***
    It checks that, for all the SIP circuits in Granite, there are no services in EOC that are not in Granite, too.
    The function should return null otherwise an array with all the records not matching the condition
   ***/
  FUNCTION check_SIP_services_EOC RETURN validation_response_arr IS
    CURSOR eoc_sip_services IS
      SELECT c.serviceNumber,
             s.serviceNumber name,
             s.serviceType category
        FROM stc_lineitem b, stc_lineitem c, stc_lineitem s, stc_order_orchestration o
       WHERE b.elementtypeinordertree = 'B'
         AND c.elementtypeinordertree = 'C'
         AND s.elementtypeinordertree = 'S'
         AND c.cworderid = b.cworderid
         AND s.cworderid = c.cworderid
         AND o.cwdocid = s.cwdocid
         AND o.cwparentobjectid = c.cwdocid
         AND b.provisioningflag in ('ACTIVE', 'PROVISIONING')
         AND s.lineitemstatus <> 'Hold'
      MINUS
      (
       SELECT cpi.circ_path_hum_id serviceNumber,
              ri.name,
              ri.category
         FROM circ_path_inst@rms_prod_db_link cpi, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri
        WHERE cpi.circ_path_inst_id = ra.target_inst_id
          AND ra.resource_inst_id = ri.resource_inst_id
          AND ri.category like '%SIP%'
          AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
          AND ra.target_type_id = 10
        UNION
       SELECT cpi.circ_path_hum_id serviceNumber,
              ri.name,
              ri.category
         FROM del_circ_path_inst@rms_prod_db_link cpi, del_resource_associations@rms_prod_db_link ra, del_resource_inst@rms_prod_db_link ri
        WHERE cpi.circ_path_inst_id = ra.target_inst_id
          AND ra.resource_inst_id = ri.resource_inst_id
          AND ri.category like '%SIP%'
          AND cpi.type in ('SIP', 'BSIP', 'SIPMW', 'BSIPMW')
          AND ra.target_type_id = 10);

    response validation_response_arr;
    position NUMBER;

  BEGIN
    position := 1;
    FOR c IN eoc_sip_services LOOP
      BEGIN
        extend_result(response);
        response(position) := 'Found a '||c.category||' service ('||c.name||') in EOC for the SIP circuit ('||c.serviceNumber||') that is not in Granite';
        position := position + 1;
      END;
    END LOOP;

    RETURN response;

  END check_SIP_services_EOC;


  /***
    To log messages. It insert into the log table.
  ***/
  PROCEDURE log_validation_failed(errorCode IN VARCHAR2, errorDescription IN VARCHAR2) IS
    tot_rows NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO tot_rows
      FROM stc_data_validation_failed
     WHERE rownum < 3;

    IF(tot_rows = 0) THEN
      INSERT INTO stc_data_validation_failed(id, when, error_code, error_descr)
      VALUES (1, TRUNC(SYSDATE), errorCode, errorDescription);
    ELSE
      INSERT INTO stc_data_validation_failed(id, when, error_code, error_descr)
      SELECT MAX(id) + 1, TRUNC(SYSDATE), errorCode, errorDescription
        FROM stc_data_validation_failed;
    END IF;
  END log_validation_failed;

  /***
    To initialize or extend the response array
  ***/
  PROCEDURE extend_result(response IN OUT validation_response_arr) IS
  BEGIN
    IF(response IS NULL) THEN
      response := validation_response_arr();
      response.extend(1);
    ELSE
      response.extend(1);
    END IF;
  END extend_result;

  /***
    The MAIN!
    It invokes all the validation functions and, in case of errors, it dumps the errors found in the table using the procedure "log".
   ***/
  PROCEDURE perform_all_checks IS
    resultCheck validation_response_arr;
    mailText    VARCHAR2(4000);
  BEGIN

    dbms_output.enable(NULL);
    mailText := NULL;

    -- checking count provisioningFlag='ACTIVE'
    resultCheck := check_count_provisioningFlag('ACTIVE');
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('001', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with multiple provisioningFlag "ACTIVE"';
    END IF;

    -- checking count provisioningFlag='PROVISIONING'
    resultCheck := check_count_provisioningFlag('PROVISIONING');
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('001', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with multiple provisioningFlag "PROVISIONING"';
    END IF;

    -- checking valid order status
    resultCheck := check_order_status();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('002', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with wrong orderStatus';
    END IF;

    -- checking valid lineItem status
    resultCheck := check_lineitem_status();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('003', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with wrong lineItemStatus';
    END IF;

    -- checking revised or cancelled order with wrong provisioningFlag
    resultCheck := check_updated_order_pf();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('010', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with order revised or cancelled and wrong provisioningFlag';
    END IF;

    -- checking revised or cancelled order with process still running
    resultCheck := check_updated_order_pr();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('011', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with order revised or cancelled and provisioning process still running';
    END IF;

    -- checking valid provisioningFlag values
    resultCheck := check_provisioningFlag();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('009', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with order with wrong provisioningFlag';
    END IF;

    -- checking fake cancelled
    resultCheck := check_fake_cancelled();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('004', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' cases with orderStatus "CANCELLED" but not really cancelled';
    END IF;

    -- checking SIP circuits between Granite and EOC
    resultCheck := check_SIP_circuits();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('012', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' SIP circuits in Granite that are not in EOC';
    END IF;

    -- checking SIP bundleId between Granite and EOC
    resultCheck := check_SIP_bundleId_missing();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('005', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' SIP circuits in Granite that don''t have the UDA "Parent Bundle Id"';
    END IF;


    -- checking SIP bundleId between Granite and EOC
    resultCheck := check_SIP_bundleId();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('006', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' SIP circuits in Granite that have "Parent Bundle Id" different from the value in EOC';
    END IF;

    -- checking SIP services in Granite are in EOC
    resultCheck := check_SIP_services_GI();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('007', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' SIP services in Granite that don''t exist in EOC';
    END IF;

    -- checking SIP services in EOC are in GI
    resultCheck := check_SIP_services_EOC();
    IF(resultCheck IS NOT NULL) THEN
      FOR i in 1 .. resultCheck.COUNT LOOP
        BEGIN
          log_validation_failed('008', resultCheck(i));
        END;
      END LOOP;

      mailText := nvl(mailText, '')||chr(10)||'Found '||resultCheck.COUNT||' SIP services in EOC that don''t exist in Granite';
    END IF;

    IF(mailText IS NOT NULL) THEN
      mailText := 'Hi All, '||chr(10)||chr(10)||
                  'Please find below list of issues found in data validation on '||to_char(sysdate, 'dd/mm/yyyy')||':'||chr(10)||chr(10)||
                  mailText||chr(10)||chr(10)||
                  'Please, don''t reply to this email because generated automatically by the system';
/*
      utl_mail.send@rms_prod_db_link( sender => 'Granite@stc.com.sa',
                                      recipients => 'dkkhan.c@stc.com.sa;s.kishore@ericsson.com',
                                      subject => 'EOC Data Validation Report For PT Dated: '||to_char(sysdate, 'dd/mm/yyyy'),
                                      message => mailText);
*/
    END IF;

    COMMIT;

  END;


END VALIDATE_EOC_EBU_DATA;
/