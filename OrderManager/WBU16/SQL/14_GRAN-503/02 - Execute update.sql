set serveroutput on;


DECLARE

  CURSOR gran_503_rec IS
    SELECT * FROM stcw_gran503_data;

  eocOrderNumber   stcw_gran503_data.eoc_order_number%TYPE;
  eocAccountNumber stcw_gran503_data.eoc_account_number%TYPE;
  eocCWOrderId     stcw_bundleorder_header.cworderid%TYPE;
  xngOrderNumber   stcw_gran503_data.xng_order_number%TYPE;
  xngAccountNumber stcw_gran503_data.xng_account_number%TYPE;
  xngPathInstId    NUMBER(10);
    
  errorMsg         stcw_gran503_data.error_msg%TYPE;
  finalErrorMsg    VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  
  FOR r IN gran_503_rec LOOP
    eocOrderNumber   := NULL;
    eocAccountNumber := NULL;
    eocCWOrderId     := NULL;
    xngOrderNumber   := NULL;
    xngAccountNumber := NULL;
    xngPathInstId    := NULL;
    errorMsg         := NULL;
    finalErrorMsg    := NULL;
    
    BEGIN
      SELECT o.ordernumber, NVL(o.accountnumber, o.customerIdNumber), o.cworderId
        INTO eocOrderNumber, eocAccountNumber, eocCWOrderId
        FROM stcw_bundleorder_header o
       WHERE o.cworderid in (SELECT l.cworderid
                               FROM stcw_lineitem l
                              WHERE l.servicenumber = r.circuit_number
                                AND provisioningFlag = 'ACTIVE');
    
    
    EXCEPTION
      WHEN no_data_found THEN
        errorMsg := 'Unable to find an ACTIVE service in EOC for the provided path';
      WHEN others THEN
        errorMsg := 'Unexpected error while gathering data from EOC: '||SUBSTR(sqlerrm, 1, 900);
    END;
    
    IF(errorMsg IS NULL) THEN
      BEGIN
        SELECT order_num, customer_id, circ_path_inst_id
          INTO xngOrderNumber, xngAccountNumber, xngPathInstId
          FROM circ_path_inst@rms_prod_db_link
         WHERE circ_path_hum_id = r.circuit_number;

      EXCEPTION
        WHEN no_data_found THEN
          errorMsg := 'Unable to find the PATH in XNG';
        WHEN others THEN
          errorMsg := 'Unexpected error while gathering data from XNG: '||SUBSTR(sqlerrm, 1, 900);
      END;
    END IF;      
    
    IF(errorMsg IS NULL) THEN
      BEGIN
        UPDATE stcw_bundleorder_header
           SET --orderNumber      = r.new_order_number,
               customerIdNumber = r.new_account_number,
               accountNumber    = r.new_account_number
         WHERE cwOrderId = eocCWOrderId;
        
        /**
        UPDATE stcw_order_orchestration
           SET orderNumber      = r.eoc_order_number
         WHERE cwOrderId = eocCWOrderId;
        **/
        
      EXCEPTION
        WHEN others THEN
          errorMsg := 'Unexpected error while updating EOC: '||SUBSTR(sqlerrm, 1, 900);
      END;
    END IF;      

    IF(errorMsg IS NULL) THEN
      BEGIN
        UPDATE circ_path_inst@rms_prod_db_link
           SET order_num        = r.new_order_number,
               customer_id      = r.new_account_number
         WHERE circ_path_inst_id = xngPathInstId;
         
      EXCEPTION
        WHEN others THEN
          errorMsg := 'Unexpected error while updating XNG: '||SUBSTR(sqlerrm, 1, 900);
      END;
    END IF;      

    IF(errorMsg IS NULL) THEN
      COMMIT;
    ELSE
      ROLLBACK;
    END IF;
        
    BEGIN
      UPDATE stcw_gran503_data
         SET eoc_order_number   = eocOrderNumber,
             eoc_account_number = eocAccountNumber,
             xng_order_number   = xngOrderNumber,
             xng_account_number = xngAccountNumber,
             error_msg          = errorMsg
       WHERE circuit_number = r.circuit_number;
       
       COMMIT;
    EXCEPTION
      WHEN others THEN
        finalErrorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('Failed to update record in STCW_GRAN503_DATA for path '||r.circuit_number||'; error is:'||finalErrorMsg);
        DBMS_OUTPUT.PUT_LINE('  EOC_ORDER_NUMBER:  '||eocOrderNumber);
        DBMS_OUTPUT.PUT_LINE('  EOC_ACCOUNT_NUMBER:'||eocAccountNumber);
        DBMS_OUTPUT.PUT_LINE('  XNG_ORDER_NUMBER:  '||xngOrderNumber);
        DBMS_OUTPUT.PUT_LINE('  XNG_ACCOUNT_NUMBER:'||xngAccountNumber);
        DBMS_OUTPUT.PUT_LINE('  ERROR_MSG:         '||errorMsg);
    END;

    ROLLBACK;
    
  END LOOP;

END;
/