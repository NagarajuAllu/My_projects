/*****
  Archive lineItems whose WO is already decommissioned.
  2015-09-09: found 2
*****/
update stc_lineitem set provisioningFlag = 'OLD' where workordernumber in (select wo_name from del_work_order_inst@rms_prod_db_link where wo_name = workordernumber) and provisioningFlag = 'PROVISIONING';
commit;



/****
  Update the alreadysenttogranite flag if the WO is already in Granite
  2015-09-09: found 665
****/
update stc_lineitem 
   set alreadysenttogranite = 1 
 where alreadysenttogranite = 0 
   and workordernumber in (select wo_name from rms_prod.work_order_inst@rms_prod_db_link where wo_name = workordernumber
                           union
                           select wo_name from rms_prod.del_work_order_inst@rms_prod_db_link where wo_name = workordernumber);
commit;



/****
  The following query has to return no rows.
  If returns any row, it means that there are services with
  invalid provisioningFlag ... and probably invalid status.
****/
select lineItemIdentifier, count(*)
  from stc_lineitem
 where provisioningFlag = 'PROVISIONING'
group by lineItemIdentifier
having count(*) > 1;




/****

  2015-09-09: found these records during migration

DMAM04_00_203_01-RYAD06_44 DIA1  2   ==> don't care which has to be maintained; both of them (C4325392 & C4321594) are not in Granite; put them in OLD
JEDDAH-RIYADH PLL224             2   ==> C4465552 is completed in Granite - put it to ACTIVE, C4468598 is still in provisioning
RIYADH-RIYADH IP3578             2   ==> C4460395 is completed in Granite (better, path is LIVE in Granite!) - put it to ACTIVE, C4469339 is still in provisioning
TAYM97-TAYM97 IP37               2   ==> C4393672 exists in Granite, C4393372 is missing in Granite, so put this to OLD
DAMMAM-DAMMAM DIA96              3   ==> C4304066 & C4346907 don't exist in Granite, so put them in OLD; I4394237 is still in provisioning in Granite



/***
 * Check if the WO is in Granite; if not, the order is "archived", so provisioningFlag = "OLD".
 */ 
set serveroutput on

DECLARE

  CURSOR c_provisioning IS
    SELECT lineitemidentifier
      FROM stc_lineitem
     WHERE provisioningFlag = 'PROVISIONING'
    GROUP BY lineItemIdentifier
    HAVING COUNT(*) > 1;
 
 
  CURSOR c_provisioning_cwdocid(currentLineItemId IN VARCHAR2) IS
    SELECT cwdocid, workOrderNumber
      FROM stc_lineitem
     WHERE provisioningFlag = 'PROVISIONING'
       AND lineitemidentifier = currentLineItemId;
      
  errMsg                VARCHAR2(1000);
  countInGranite        NUMBER(1);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceCursor IN c_provisioning LOOP
    BEGIN
dbms_output.put_line('[INFO] Start lineItemIdentifier '||serviceCursor.lineitemidentifier);

      FOR lineItemCursor IN c_provisioning_cwdocid(serviceCursor.lineitemidentifier) LOOP
        BEGIN
dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||lineItemCursor.workOrderNumber);

          SELECT COUNT(*)
            INTO countInGranite
            FROM rms_prod.work_order_inst woi
           WHERE woi.wo_name = lineItemCursor.workOrderNumber;

dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||lineItemCursor.workOrderNumber || '; countInGranite = '||countInGranite);
        
          IF(countInGranite = 0) THEN
            SELECT COUNT(*)
              INTO countInGranite
              FROM del_work_order_inst@rms_prod_db_link woi
             WHERE woi.wo_name = lineItemCursor.workOrderNumber;
          END IF;
  
dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||lineItemCursor.workOrderNumber || '; countInGranite = '||countInGranite);
        
          IF(countInGranite = 0) THEN
            UPDATE stc_lineitem 
               SET provisioningFlag = 'OLD'
             WHERE cwdocid = lineItemCursor.cwdocid;
dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||lineItemCursor.workOrderNumber || ': OLD');
          END IF;
        
        EXCEPTION 
          WHEN others THEN
            errMsg := substr(sqlerrm, 1, 1000);
dbms_output.put_line('[ERR] Unexpected error while processing lineItemIdentifier '||serviceCursor.lineitemidentifier||'['||lineItemCursor.cwdocid||']: '||errMsg);
        END;
      END LOOP;
  
dbms_output.put_line('[INFO] Completed lineItemIdentifier '||serviceCursor.lineitemidentifier);

    END;
  
  END LOOP;
END;
/



/**************

  CHECK THE CORRECTNESS OF THE STATUS OF THE WORKORDER COMPARED TO THE STATUS OF THE PATH
  FOR EXAMPLE: WO I4227618 has path completed but the status of the WO is 4!

**************/









/***
 * According to the receivedDate, it sets the provisioningFlag = "OLD" for the oldest records.
 * So at the end, only one record will have provisioningFlag = "PROVISIONING"
 */ 
set serveroutput on

DECLARE

  CURSOR c_provisioning IS
    SELECT lineitemidentifier
      FROM stc_lineitem
     WHERE provisioningFlag = 'PROVISIONING'
    GROUP BY lineItemIdentifier
    HAVING COUNT(*) > 1;
 
  realProvisioningDocId stc_lineItem.cwDocId%TYPE;
  errMsg                VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceCursor IN c_provisioning LOOP
    BEGIN
dbms_output.put_line('[INFO] Start lineItemIdentifier '||serviceCursor.lineitemidentifier);
      SELECT cwdocid
        INTO realProvisioningDocId
        FROM (SELECT l.cwdocid, h.receivedDate
                FROM stc_lineitem l, stc_bundleorder_header h
               WHERE l.lineItemIdentifier = serviceCursor.lineitemidentifier
                 AND l.provisioningFlag = 'PROVISIONING'
                 AND l.cworderid = h.cworderid
              ORDER BY NVL(h.receivedDate, to_date('01/01/1970', 'dd/mm/yyyy'))  DESC)
       WHERE rownum = 1;
  
      UPDATE stc_lineitem
         SET provisioningFlag = 'OLD'
       WHERE lineItemIdentifier = serviceCursor.lineitemidentifier
         AND cwdocid <> realProvisioningDocId;
  
dbms_output.put_line('[INFO] Completed lineItemIdentifier '||serviceCursor.lineitemidentifier);

    EXCEPTION 
      WHEN others THEN
        errMsg := substr(sqlerrm, 1, 1000);
dbms_output.put_line('[ERR] Unexpected error while processing lineItemIdentifier '||serviceCursor.lineitemidentifier||': '||errMsg);

    END;
  
  END LOOP;
END;
/

