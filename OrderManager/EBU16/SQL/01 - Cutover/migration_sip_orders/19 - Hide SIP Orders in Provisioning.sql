/***
  Due to the request from STC to not migrate SIP "pending" orders, it:
  - changes the ordernumber from XXXX to XXXX_INPRO
  - provisioningFlag from PROVISIONING to SKIP
***/

set serveroutput on 

DECLARE
  
  CURSOR c_bundleProv IS 
    SELECT b.cworderid, b.cwdocid, h.ordernumber
      FROM stc_lineItem b, stc_bundleorder_header h, stc_om_home_sip om
     WHERE b.elementTypeInOrderTree = 'B'
       AND b.provisioningFlag = 'PROVISIONING'
       AND b.cworderid = h.cworderid
       AND h.ordernumber = om.parentordernumber;
       
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
    
  FOR i in c_bundleProv LOOP
    BEGIN
      
      UPDATE stc_bundleorder_header
         SET ordernumber = i.ordernumber || '_INPRO'
       WHERE cworderid = i.cworderid;
       
       
      UPDATE stc_lineItem
         SET provisioningFlag = 'SKIP'
       WHERE cwdocid = i.cwdocid;
      
dbms_output.put_line('[INFO]   Updated stc_bundleorder_header['||i.cworderid||']');

    EXCEPTION
      WHEN others THEN
dbms_output.put_line('[ERROR]   Unexpected error while hidding the order['||i.cworderid||']:'||substr(sqlerrm, 1, 100));
    END;
  END LOOP;
END;
/
