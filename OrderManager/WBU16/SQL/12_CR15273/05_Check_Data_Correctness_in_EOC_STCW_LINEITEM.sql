set serveroutput on

DECLARE

  CURSOR circuits_migrated IS
    SELECT *
      FROM stcw_circuits_migrated_frm_ebu;
  
  
  CURSOR lineItems (circuit_name VARCHAR2) IS
    SELECT serviceType, productType, receivedServiceType, provisioningBU, provisioningFlag
      FROM stcw_lineitem
     WHERE serviceNumber = circuit_name
       AND provisioningFlag in ('ACTIVE', 'PROVISIONING'); 
       
  circuitFound          CHAR(1);
  originalServiceType   VARCHAR2(4);
  newProductType        VARCHAR2(4);
  newServiceType        stcw_lineitem.serviceType%TYPE; 
  errorMsg              VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  FOR c IN circuits_migrated LOOP
    BEGIN
      circuitFound        := 'N';
      originalServiceType := SUBSTR(c.service_id, 1, 4);
      
      SELECT DECODE (originalServiceType, 'D022', 'D053', 'D056')
        INTO newProductType
        FROM dual;
      
      SELECT gi_serviceType
        INTO newServiceType
        FROM stcw_servicetype_name_map
       WHERE com_serviceType = newProductType;
      
      FOR l IN lineItems(c.circuit_name) LOOP
        BEGIN
        
          circuitFound := 'Y';
          
          IF(l.serviceType <> newServiceType) THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found an instance of the service with serviceNumber <'||c.circuit_name||'> and provisioningFlag <'||l.provisioningFlag||'>; '||
                                 'it has the wrong serviceType: expected <'||newServiceType||'>; found <'||l.serviceType||'>');
          END IF;
    
          IF(l.productType <> newProductType) THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found an instance of the service with serviceNumber <'||c.circuit_name||'> and provisioningFlag <'||l.provisioningFlag||'>; '||
                                 'it has the wrong productType: expected <'||newProductType||'>; found <'||l.productType||'>');
          END IF;
            
          IF(l.receivedServiceType <> newProductType) THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found an instance of the service with serviceNumber <'||c.circuit_name||'> and provisioningFlag <'||l.provisioningFlag||'>; '||
                                 'it has the wrong receivedServiceType: expected <'||newProductType||'>; found <'||l.receivedServiceType||'>');
          END IF;
    
          IF(l.provisioningBU <> 'E') THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Found an instance of the service with serviceNumber <'||c.circuit_name||'> and provisioningFlag <'||l.provisioningFlag||'>; '||
                                 'it has the wrong provisioningBU: expected <E>; found <'||l.provisioningBU||'>');
          END IF;
        
        EXCEPTION
          WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('[ERR] Unable to find an instance of the service with serviceNumber <'||c.circuit_name||'>');
        END;
      END LOOP;  
      
      IF(circuitFound = 'N') THEN
        DBMS_OUTPUT.PUT_LINE('[ERR] Unable to find an instance of the service with serviceNumber <'||c.circuit_name||'>');
      END IF;
      
    EXCEPTION    
      WHEN others THEN
        errorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] Found unexpected error while checking serviceNumber <'||c.service_id||'>: '||errorMsg);
    END;
  END LOOP;
END;
/

