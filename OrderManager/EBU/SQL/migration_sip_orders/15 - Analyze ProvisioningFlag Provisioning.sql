/*****
  Archive lineItems whose WO is already decommissioned.
  2015-09-09: 0 rows updated
*****/
update stc_lineitem b
   set b.provisioningFlag = 'OLD' 
 where b.cworderid = (select c.cworderid 
                        from stc_lineItem c, del_work_order_inst@rms_prod_db_link w
                       where c.cworderid = b.cworderid
                         and c.elementTypeInOrderTree = 'C'
                         and c.workordernumber = w.wo_name)
   and b.cworderid in (select o.cworderid from stc_bundleorder_header o, stc_om_home_sip s where o.ordernumber  = s.parentordernumber) 
   and b.provisioningFlag = 'PROVISIONING';
commit;



/****
  Update the alreadysenttogranite flag if the WO is already in Granite
  2015-09-09: 0 rows updated
****/
update stc_lineitem c
   set c.alreadysenttogranite = 1 
 where c.alreadysenttogranite = 0 
   and c.workordernumber in (select wo_name from rms_prod.work_order_inst where wo_name = c.workordernumber)
   and c.cworderid in (select o.cworderid from stc_bundleorder_header o, stc_om_home_sip s where o.ordernumber  = s.parentordernumber);
commit;


/****
  Archive orders whose WO is not in Granite
  2015-09-09: 8 rows updated
****/
update stc_lineitem b
   set b.provisioningFlag = 'OLD' 
 where b.cworderid in (select c.cworderid
                         from stc_lineItem c
                        where c.workordernumber is not null
                          and c.cworderid = b.cworderid
                          and elementtypeinordertree = 'C'
                          and c.workordernumber not in (select wo_name from work_order_inst@rms_prod_db_link w))
   and b.provisioningFlag = 'PROVISIONING'
   and elementtypeinordertree = 'B'
   and b.cworderid in (select o.cworderid from stc_bundleorder_header o, stc_om_home_sip s where o.ordernumber  = s.parentordernumber);
commit;



/****
  The following query has to return no rows.
  If returns any row, it means that there are services with
  invalid provisioningFlag ... and probably invalid status.
  2015-09-09: 0 rows
****/
select b.lineItemIdentifier, count(*)
  from stc_lineitem b
 where b.provisioningFlag = 'PROVISIONING'
   and b.elementTypeInOrderTree = 'B'
   and b.cworderid in (select o.cworderid from stc_bundleorder_header o, stc_om_home_sip s where o.ordernumber  = s.parentordernumber)
group by b.lineItemIdentifier
having count(*) > 1;





/***
 * Check if the WO is in Granite; if not, the order is "archived", so provisioningFlag = "OLD".
 */ 
set serveroutput on

DECLARE

  CURSOR c_provisioning IS
    SELECT b.lineitemidentifier
      FROM stc_lineitem b
     WHERE b.provisioningFlag = 'PROVISIONING'
       AND b.elementTypeInOrderTree = 'B'
       AND b.cworderid IN (SELECT o.cworderid FROM stc_bundleorder_header o, stc_om_home_sip s WHERE o.ordernumber  = s.parentordernumber)
    GROUP BY b.lineItemIdentifier
    HAVING COUNT(*) > 1;
 
 
  CURSOR c_circuitLineItem (bundleLineItemId IN VARCHAR2) IS
      SELECT b.cwdocid, c.lineitemidentifier, c.workordernumber
        FROM stc_lineItem b, stc_lineitem c
       WHERE b.elementTypeInOrderTree = 'B'
         AND b.lineItemIdentifier = bundleLineItemId
         AND b.provisioningFlag = 'PROVISIONING'
         AND b.cworderid = c.cworderid
         AND c.elementtypeinordertree = 'C';
      
  errMsg                VARCHAR2(1000);
  countInGranite        NUMBER(1);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceCursor IN c_provisioning LOOP
    BEGIN
dbms_output.put_line('[INFO] Start lineItemIdentifier '||serviceCursor.lineitemidentifier);

      FOR circuitCursor IN c_circuitLineItem(serviceCursor.lineitemidentifier) LOOP
        BEGIN
dbms_output.put_line('[INFO] circuitCursor.workOrderNumber '||circuitCursor.workOrderNumber);

          SELECT COUNT(*)
            INTO countInGranite
            FROM rms_prod.work_order_inst@rms_prod_db_link woi, rms_prod.circ_path_inst@rms_prod_db_link cpi
           WHERE cpi.circ_path_hum_id = circuitCursor.lineitemidentifier
             AND woi.wo_name = circuitCursor.workordernumber
             AND cpi.circ_path_inst_id = woi.element_inst_id;
             
dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||circuitCursor.workOrderNumber || '; countInGranite = '||countInGranite);
                
          IF(countInGranite = 0) THEN
            UPDATE stc_lineitem 
               SET provisioningFlag = 'OLD'
             WHERE cwdocid = circuitCursor.cwdocid;
dbms_output.put_line('[INFO] lineItemCursor.workOrderNumber '||circuitCursor.workOrderNumber || ': OLD');
          END IF;
        
        EXCEPTION 
          WHEN others THEN
            errMsg := substr(sqlerrm, 1, 1000);
dbms_output.put_line('[ERR] Unexpected error while processing lineItemIdentifier '||serviceCursor.lineitemidentifier||'['||circuitCursor.cwdocid||']: '||errMsg);
        END;
      END LOOP;
  
dbms_output.put_line('[INFO] Completed lineItemIdentifier '||serviceCursor.lineitemidentifier);

    END;
  
  END LOOP;
END;
/



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
       AND elementTypeInOrderTree = 'B'
       AND cworderid IN (SELECT o.cworderid FROM stc_bundleorder_header o, stc_om_home_sip s WHERE o.ordernumber  = s.parentordernumber)
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
                 AND l.elementTypeInOrderTree = 'B'
                 AND l.provisioningFlag = 'PROVISIONING'
                 AND l.cworderid = h.cworderid
              ORDER BY NVL(h.receivedDate, to_date('01/01/1970', 'dd/mm/yyyy'))  DESC)
       WHERE rownum = 1;
  
      UPDATE stc_lineitem
         SET provisioningFlag = 'OLD'
       WHERE lineItemIdentifier = serviceCursor.lineitemidentifier
         AND elementTypeInOrderTree = 'B'
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

