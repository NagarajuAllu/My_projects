set serveroutput on

DECLARE

  CURSOR c_crm_data IS
    SELECT circuitnumber, ordercustomernumber, orderaccountnumber, bundleid, bundlefictb#, circuitfictb#,  childcircuitid, childservicenumber, childequivalentservicenumber, childfictb#
      FROM stc_sip_crm_data
     WHERE used = 'N';

  CURSOR c_cworderid(circuitnumber IN VARCHAR2) IS
    SELECT cworderid
      FROM stc_lineitem c
     WHERE c.servicenumber = circuitnumber
       AND c.elementtypeinordertree = 'C';
  
  CURSOR c_services(cw_orderid IN VARCHAR2) IS
    SELECT s.servicenumber, s.lineitemidentifier, s.cwdocid
      FROM stc_lineitem s
     WHERE s.cworderid = cw_orderid
       AND s.elementtypeinordertree = 'S';
  
  found CHAR(1);
  did_servicenumber stc_lineitem.servicenumber%TYPE;
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
dbms_output.put_line('[INFO] Starting');  

  FOR crmDataCursor IN c_crm_data LOOP
    BEGIN
      found := 'N';
      
dbms_output.put_line('[INFO] Process serviceNumber ['||crmDataCursor.circuitnumber||']');

      FOR cwOrderCursor IN c_cworderid(crmDataCursor.circuitnumber) LOOP
        BEGIN
          found := 'Y';
  
          UPDATE stc_bundleorder_header 
             SET customernumber = crmDataCursor.ordercustomernumber,
                 accountnumber = crmDataCursor.orderaccountnumber
           WHERE cworderid = cwOrderCursor.cworderid;
dbms_output.put_line('[INFO]   Updated stc_bundleorder_header['||cwOrderCursor.cworderid||']');
  
  
          UPDATE stc_lineitem
             SET lineitemidentifier = crmDataCursor.bundleid,
                 servicenumber = crmDataCursor.bundleid
           WHERE cworderid = cwOrderCursor.cworderid
             AND elementtypeinordertree = 'B';

          UPDATE stc_order_orchestration
             SET lineitemidentifier = crmDataCursor.bundleid
           WHERE cworderid = cwOrderCursor.cworderid
             AND cwdocid = (SELECT cwdocid
                              FROM stc_lineitem
                             WHERE cworderid = cwOrderCursor.cworderid
                               AND elementtypeinordertree = 'B'
                               AND lineitemidentifier = crmDataCursor.bundleid);

          IF(crmDataCursor.bundlefictb# IS NOT NULL) THEN
            UPDATE stc_lineitem
               SET fictbillingnumber = crmDataCursor.bundlefictb#
             WHERE cworderid = cwOrderCursor.cworderid
               AND elementtypeinordertree = 'B';
          END IF;
dbms_output.put_line('[INFO]   Updated parent lineitem['||cwOrderCursor.cworderid||']');
  
  
          UPDATE stc_lineitem
             SET fictbillingnumber = crmDataCursor.circuitfictb#
           WHERE cworderid = cwOrderCursor.cworderid
             AND elementtypeinordertree = 'C'
             AND servicenumber = crmDataCursor.circuitnumber;
dbms_output.put_line('[INFO]   Updated circuit lineitem['||cwOrderCursor.cworderid||']');

          
          FOR serviceCursor IN c_services(cwOrderCursor.cworderid) LOOP
            BEGIN
              INSERT INTO stc_amo_name_bck (old_service#, old_identifier, new_service#, new_identifier, cwdocid)
              VALUES (serviceCursor.servicenumber, 
                      serviceCursor.lineitemidentifier,
                      crmDataCursor.childcircuitid,
                      crmDataCursor.childcircuitid,
                      serviceCursor.cwdocid);
              
              UPDATE stc_lineitem
                 SET lineitemidentifier = crmDataCursor.childcircuitid,
                     servicenumber = crmDataCursor.childcircuitid,
                     fictbillingnumber = crmDataCursor.childfictb#
               WHERE cworderid = cwOrderCursor.cworderid
                 AND cwdocid = serviceCursor.cwdocid;

              UPDATE stc_order_orchestration
                 SET lineitemidentifier = crmDataCursor.childcircuitid
               WHERE cworderid = cwOrderCursor.cworderid
                 AND cwdocid = serviceCursor.cwdocid; 
             
            END;
          END LOOP;
          
        END;
      END LOOP;
      
      IF(found = 'N') THEN
dbms_output.put_line('[ERROR]   Unable to find order with serviceNumber['||crmDataCursor.circuitnumber||']');       
      ELSE  
        found := 'M';
      END IF;
      
      UPDATE stc_sip_crm_data
         SET used = found
       WHERE circuitnumber = crmDataCursor.circuitnumber;
      
    END;
  
  END LOOP;

END;
/
  