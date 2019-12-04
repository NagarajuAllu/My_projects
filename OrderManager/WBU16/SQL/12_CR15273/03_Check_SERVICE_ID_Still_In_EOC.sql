set serveroutput on

DECLARE

  CURSOR circuits_migrated IS
    SELECT *
      FROM stcw_circuits_migrated_frm_ebu;

  foundProvisioningFlag stcw_lineitem.provisioningFlag%TYPE;
  errorMsg              VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  FOR c IN circuits_migrated LOOP
    BEGIN
      SELECT provisioningFlag 
        INTO foundProvisioningFlag 
        FROM stcw_lineitem
       WHERE cworderid IN (SELECT cworderid FROM stcw_lineitem WHERE provisioningFlag in ('ACTIVE', 'PROVISIONING'))
         AND servicenumber = c.service_id;
    
    
      DBMS_OUTPUT.PUT_LINE('[ERR] Found an instance of the service with serviceNumber <'||c.service_id||'> and provisioningFlag <'||foundProvisioningFlag||'>');
    
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
      WHEN others THEN
        errorMsg := substr(sqlerrm, 1, 1000);
        DBMS_OUTPUT.PUT_LINE('[ERR] Found unexpected error while checking serviceNumber <'||c.service_id||'>: '||errorMsg);
    END;
  END LOOP;
END;
/
 
