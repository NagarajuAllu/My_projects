/*****
  Archive lineItems whose WO is already decommissioned.
  2017-07-10: found  7
*****/
update stcw_lineitem 
   set provisioningFlag = 'OLD' 
 where workordernumber in (select wo_name from del_work_order_inst@rms_prod_db_link where wo_name = workordernumber) 
   and provisioningFlag = 'PROVISIONING';
commit;



/****
  Update the alreadysenttogranite flag if the WO is already in Granite
  2017-07-10: found 0
****/
update stcw_lineitem 
   set alreadysenttogranite = 1, sentanytimetogranite = 1
 where alreadysenttogranite = 0 
   and workordernumber in (select wo_name from rms_prod.work_order_inst@rms_prod_db_link where wo_name = workordernumber
                           union
                           select wo_name from rms_prod.del_work_order_inst@rms_prod_db_link where wo_name = workordernumber);
commit;



/****
  The following query has to return no rows.
  If returns any row, it means that there are services with
  invalid provisioningFlag ... and probably invalid status.
  
  2017-07-10: found 0
****/
select lineItemIdentifier, count(*)
  from stcw_lineitem
 where provisioningFlag = 'PROVISIONING'
group by lineItemIdentifier
having count(*) > 1;




/***
  Check if the WO is in Granite; if not, the order is "archived", so provisioningFlag = "OLD".
  
  2017-07-10: found 36
 */ 
set serveroutput on

DECLARE

  CURSOR c_provisioning IS
    SELECT l.lineitemidentifier
      FROM stcw_lineitem l, stcw_bundleorder_header h
     WHERE l.provisioningFlag = 'PROVISIONING'
       AND h.ismigrated = 1
       AND h.cworderid = l.cworderid
    GROUP BY l.lineItemIdentifier
    HAVING COUNT(*) >= 1;
 
 
  CURSOR c_provisioning_cwdocid(currentLineItemId IN VARCHAR2) IS
    SELECT cwdocid, workOrderNumber
      FROM stcw_lineitem
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
            FROM work_order_inst@rms_prod_db_link woi
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
            UPDATE stcw_lineitem 
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



/***
 * To identify all the lineitems in PROVISIONING that have the flag "sent to granite" disabled.
 * 2017-07-10: found 0
 */ 
select * 
  from stcw_lineitem l, stcw_bundleorder_header h
 where l.cworderid = h.cworderid
   and h.ismigrated = 1
   and l.provisioningFlag = 'PROVISIONING'
   and (l.alreadysenttogranite = 0 and l.sentanytimetogranite = 0);