/***
  Due to the request from STC to not migrate SIP "pending" orders, it:
  - checks if the SIP orders in PROVISIONING are COMPLETED in Granite:
    - if no, do nothing
    - else:
      - update status of orderHeader, Bundle, Circuit & Service
      - update provisioningFlag = 'OLD' for the service with the same lineItemIdentifier
      - update provisioningFlag = 'ACTIVE' for the "hidden" order/bundle.
***/

set serveroutput on 

DECLARE
  
  wo_status             CHAR(1);
  wo_completion_date    DATE;
  newCircuitStatus      stc_lineitem.lineItemStatus%TYPE;
  countCompleted        NUMBER(1);
  countNotCompleted     NUMBER(1);
  newBundleStatus       stc_lineitem.lineItemStatus%TYPE;
  newProvisioningFlag   stc_lineitem.provisioningFlag%TYPE;
  
  
  config_clob           CLOB;
  num_warning           NUMBER;
  config_blob           BLOB;
  src_offset            NUMBER;
  dest_offset           NUMBER;
  lang_context          NUMBER;
  not_supported_date    DATE;
  
  CURSOR c_sipOrdersProv IS 
    SELECT h.cwOrderId, om.parentOrderNumber, b.lineItemIdentifier, c.workOrderNumber, c.cwDocId, c.isCancel
      FROM stc_bundleorder_header h, stc_om_home_sip om, stc_lineItem b, stc_lineitem c
     WHERE h.ismigrated = 1
       AND b.elementTypeInOrderTree = 'B'
       AND b.provisioningFlag = 'PROVISIONING'
       AND c.elementTypeInOrderTree = 'C'
       AND h.orderNumber = om.parentOrderNumber||'_INPRO'
       AND b.cwOrderId = h.cwOrderId
       AND c.cwOrderId = h.cwOrderId
       AND b.productType in (SELECT crmProductType 
                               FROM stc_producttype_name_map 
                              WHERE internalProductType = 'Bundle SIP');
                                     


  CURSOR c_serviceElements(circuitDocId VARCHAR2, orderId VARCHAR2) IS
    SELECT cwDocId
      FROM stc_order_orchestration
     WHERE cwParentObjectId = circuitDocId
       AND elementTypeInOrchestration = 'S';
     
     
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);


  DBMS_LOB.CREATETEMPORARY(config_clob, TRUE);
  
  src_offset   := 1;
  dest_offset  := 1;
  lang_context := DBMS_LOB.DEFAULT_LANG_CTX;
  
  SELECT config
    INTO config_blob 
    FROM cwh.cwvminfo
   WHERE node_id = 'CLUSTER';
   
  DBMS_LOB.CONVERTTOCLOB(config_clob,
                         config_blob,
                         DBMS_LOB.getlength(config_blob),
                         src_offset,
                         dest_offset,
                         1,
                         lang_context,
                         num_warning);
                         
  SELECT TO_DATE(XMLTYPE(config_clob).EXTRACT('/*/configVarAsReference[name="SIP_NOT_SUPPORTED_DATE"]/value/text()').getStringVal(), 'YYYY/MM/DD')
    INTO not_supported_date
    FROM dual;

  
  IF(ADD_MONTHS(not_supported_date, 3) < sysdate) THEN
    dbms_output.put_line('[ERROR]   The procedure expired '||to_char(not_supported_date, 'DD/MM/YYYY'));
    RETURN;
  END IF;


    
  FOR itemCur in c_sipOrdersProv LOOP
    BEGIN
      
      SELECT status, actual_compl
        INTO wo_status, wo_completion_date
        FROM rms_prod.work_order_inst@rms_prod_db_link w
       WHERE w.wo_name = itemCur.workOrderNumber;
      
      IF(wo_status IN (7, 8)) THEN 
        -- wo completed
        SELECT DECODE(itemCur.isCancel, 1, 'CANCELLED', 
                                           'COMPLETED')
          INTO newCircuitStatus 
          FROM dual;
        
        FOR serviceCur IN c_serviceElements(itemCur.cwDocId, itemCur.cwOrderId) LOOP
          BEGIN
            -- updating service
            UPDATE stc_lineItem s
               SET s.lineItemStatus =  newCircuitStatus, 
                   s.completionDate = wo_completion_date
             WHERE s.cwDocId = serviceCur.cwDocId
               AND s.lineItemStatus NOT IN ('CANCELLED', 'COMPLETED');
          
          EXCEPTION
            WHEN no_data_found THEN
              NULL;          
          END;
        END LOOP;
        
               
        -- updating circuit
        UPDATE stc_lineItem c
           SET c.lineItemStatus =  newCircuitStatus, 
               c.completionDate = wo_completion_date
         WHERE c.elementTypeInOrderTree = 'C'
           AND c.cwOrderId = itemCur.cwOrderId
           AND c.cwDocId = itemCur.cwDocId
           AND c.lineItemStatus NOT IN ('CANCELLED', 'COMPLETED');
       
        -- check if all elements in order are 'COMPLETED'
        SELECT COUNT(*)
          INTO countNotCompleted
          FROM stc_lineItem
         WHERE cwOrderId = itemCur.cwOrderId
           AND elementTypeInOrderTree IN ('C', 'S')
           AND lineItemStatus NOT IN ('CANCELLED', 'COMPLETED');
        
        IF(countNotCompleted = 0) THEN
          newBundleStatus := 'COMPLETED';
          newProvisioningFlag := 'ACTIVE';
          
          -- it means that all the lineItems
          SELECT COUNT(*)
            INTO countCompleted
            FROM stc_lineItem
           WHERE cwOrderId = itemCur.cwOrderId
             AND elementTypeInOrderTree IN ('C', 'S')
             AND lineItemStatus IN ('COMPLETED');
          
          IF(countCompleted = 0) THEN
            -- all elements are CANCELLED
            newBundleStatus := 'CANCELLED';
            newProvisioningFlag := 'CANCELLED';
          END IF;
          
          IF(newProvisioningFlag = 'ACTIVE') THEN
            BEGIN
              -- update "active" bundle setting it to old
              
              UPDATE stc_lineItem b
                 SET b.provisioningFlag = 'OLD'
               WHERE b.provisioningFlag = 'ACTIVE'
                 AND b.lineItemIdentifier = itemCur.lineItemIdentifier;

dbms_output.put_line('[INFO]   Archived previous instance of the lineitem ['||itemCur.lineItemIdentifier||']');
                 
            EXCEPTION
              WHEN no_data_found THEN
                NULL; -- do nothing
            END;
          END IF;            
          
          -- update bundle
          UPDATE stc_lineItem 
             SET lineItemStatus = newBundleStatus, 
                 provisioningFlag = newProvisioningFlag,
                 completionDate = sysdate
           WHERE elementTypeInOrderTree = 'B'
             AND cwOrderId = itemCur.cwOrderId;
             
          -- update orderHeader
          UPDATE stc_bundleOrder_header 
             SET orderStatus = newBundleStatus, 
                 completionDate = sysdate,
                 orderNumber = itemCur.parentOrderNumber
           WHERE cwOrderId = itemCur.cwOrderId;
      
dbms_output.put_line('[INFO]   Completed Order ['||itemCur.parentOrderNumber||']');
        
        END IF; -- match: IF(countNotCompleted = 0)
      
dbms_output.put_line('[INFO]   Completed LineItem ['||itemCur.workOrderNumber||']');

      END IF; -- match: IF(wo_status IN (7, 8))
      
    EXCEPTION
      WHEN others THEN
dbms_output.put_line('[ERROR]   Unexpected error while hidding the order['||itemCur.cworderid||']:'||substr(sqlerrm, 1, 100));
    END;
  END LOOP;
END;
/
