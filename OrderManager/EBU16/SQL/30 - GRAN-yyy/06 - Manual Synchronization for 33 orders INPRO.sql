SET SERVEROUTPUT ON

DECLARE

  resource_name   VARCHAR2(255);
  service_number  stc_lineitem.servicenumber%TYPE;
  service_docid   stc_lineitem.cwdocid%TYPE;
  active_docid    stc_lineitem.cwdocid%TYPE;
  errorMsg        VARCHAR2(1000);
  errorFound      NUMBER(1);
  
  CURSOR orders_inpro IS
    SELECT h.cworderid, h.ordernumber, pli.lineitemidentifier
      FROM stc_bundleorder_header h, stc_lineitem pli
     WHERE pli.elementtypeinordertree = 'B'
       AND pli.cworderid = h.cworderid
       AND h.ordernumber IN ('03078543_INPRO',
                             '06668793_INPRO',
                             '03192666_INPRO',
                             '02609315_INPRO',
                             '03490151_INPRO',
                             '03832470_INPRO',
                             '03832470_INPRO',
                             '02166055_INPRO',
                             '06796364_INPRO',
                             '05465497_INPRO',
                             '03219986_INPRO',
                             '01319561_INPRO',
                             '01499044_INPRO',
                             '03962953_INPRO',
                             '03429474_INPRO',
                             '01639679_INPRO',
                             '02017214_INPRO',
                             '02156409_INPRO',
                             '02964284_INPRO',
                             '02837274_INPRO',
                             '02097259_INPRO',
                             '02909845_INPRO',
                             '06009540_INPRO',
                             '03242717_INPRO',
                             '02114696_INPRO',
                             '01283935_INPRO',
                             '03458749_INPRO',
                             '02030952_INPRO',
                             '04898398_INPRO',
                             '01236434_INPRO',
                             '01770211_INPRO',
                             '04513747_INPRO',
                             '02730914_INPRO');
       
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  errorFound := 0;
  
  FOR o IN orders_inpro LOOP
    BEGIN
    
      DBMS_OUTPUT.PUT_LINE('Processing order '||o.ordernumber||' - CWOrderId = '||o.cworderid);
      
      -- updating service and circuit lineitem info
      UPDATE stc_lineitem l
         SET lineitemstatus = 'COMPLETED',
             completiondate = (SELECT complete_by
                                 FROM work_order_inst@rms_prod_db_link
                                WHERE wo_name = l.workordernumber),
             alreadysenttogranite = 1,
             sentanytimetogranite = 1
       WHERE l.cworderid = o.cworderid
         AND l.elementtypeinordertree IN ('C', 'S');
     
      DBMS_OUTPUT.PUT_LINE('  update #1 (C and S) completed');
      
      -- checking if the servicename of the service is the same on granite
      SELECT ri.name, s.servicenumber, s.cwdocid
        INTO resource_name, service_number, service_docid
        FROM circ_path_inst@rms_prod_db_link cpi, resource_associations@rms_prod_db_link ra, resource_inst@rms_prod_db_link ri,
             stc_lineitem c, stc_lineitem s
       WHERE ra.target_inst_id = cpi.circ_path_inst_id
         AND ra.resource_inst_id = ri.resource_inst_id
         AND ra.target_type_id = 10
         AND ri.category like '%SIP%'
         AND cpi.circ_path_hum_id = c.servicenumber
         AND c.cworderid = o.cworderid
         AND c.elementtypeinordertree = 'C'
         AND s.cworderid = o.cworderid
         AND s.elementtypeinordertree = 'S';
      
      IF(service_number <> resource_name) THEN
        DBMS_OUTPUT.PUT_LINE('  serviceNumber <> resourceName: '||service_number||' vs '||resource_name);
        UPDATE stc_lineitem
           SET servicenumber = resource_name,
               lineitemidentifier = resource_name
         WHERE cwdocid = service_docid
           AND cworderid = o.cworderid;
        
        DBMS_OUTPUT.PUT_LINE('  update #2.1 (servicenumber) completed');
        
        UPDATE stc_order_orchestration
           SET lineitemidentifier = resource_name
         WHERE cwdocid = service_docid
           AND cworderid = o.cworderid;
        
        DBMS_OUTPUT.PUT_LINE('  update #2.2 (orchestration) completed');
      END IF;

      UPDATE stc_lineitem 
         SET provisioningFlag = 'OLD'
       WHERE provisioningFlag = 'ACTIVE'
         AND lineitemidentifier = o.lineitemidentifier;
         
      DBMS_OUTPUT.PUT_LINE('  update #4 (ACTIVE -> OLD) completed');

      UPDATE stc_lineitem l
         SET lineitemstatus = 'COMPLETED',
             completiondate = (SELECT MAX(x.completiondate)
                                 FROM stc_lineitem x
                                WHERE x.cworderid = o.cworderid
                                  AND x.elementtypeinordertree IN ('C', 'S')),
             alreadysenttogranite = 1,
             sentanytimetogranite = 1,
             provisioningFlag = 'ACTIVE'
       WHERE l.cworderid = o.cworderid
         AND l.elementtypeinordertree IN ('B');
      
      DBMS_OUTPUT.PUT_LINE('  update #5 (B) completed');
      
      UPDATE stc_bundleorder_header h
         SET orderstatus = 'COMPLETED',
             completiondate = (SELECT pli.completiondate
                                 FROM stc_lineitem pli
                                WHERE pli.cworderid = o.cworderid
                                  AND pli.elementtypeinordertree = 'B'),
             remarks = TO_CHAR(SYSDATE, 'yyyy-mm-dd')||' - Order _INPRO manually synchronized with Granite using procedure'||
                       CHR(10)||'-------------'||
                       DECODE(NVL(remarks, 'X'), 'X', CHR(10), CHR(10)||remarks),
             ismigrated = 1,
             ordernumber = SUBSTR(h.ordernumber, 1, INSTR(h.ordernumber, '_INPRO')-1)
       WHERE h.cworderid = o.cworderid;

      DBMS_OUTPUT.PUT_LINE('  update #6 (O) completed');
    
    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 999);
        DBMS_OUTPUT.PUT_LINE('  Caught ERROR '||errorMsg);
        errorFound := 1;
    END;
  END LOOP;
  
  
  IF(errorFound = 1) THEN
DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(10)||'---XX Caught at least 1 error while processing the orders; rolling back the procedure');
    ROLLBACK;
  ELSE
DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(10)||'---XX NO errors found; remember to commit!');
  END IF;
  
END;
/
        