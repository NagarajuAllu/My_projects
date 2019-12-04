/****
  It would be great if the following query returns no rows: it identifies all the lineItems 
  with provisioningFlag = 'ACTIVE' having count(*) > 1;
  If returns any row, it means that the next procedure has to be executed.
  Such procedure identifies which is the newest lineItem and 
  updates the provisioningFlag of all other records to 'OLD'
****/
select lineItemIdentifier, count(*)
  from stc_lineitem
 where provisioningFlag = 'ACTIVE'
group by lineItemIdentifier
having count(*) > 1;


/************************************************


  IMPORTANT NOTE: 
  These 2 SQL procedures have to be executed in a sqlplus session
  on the WD DB box with the following settings:
  - set pages 10000
  - set lines 300
  
  and spooling the log on different files.


**************************************************/


/***
 * If there is a record completed with OrderType = 'O', it is surely the ACTIVE one.
 * And all the others have to be archived ('OLD')
 */ 
set serveroutput on

DECLARE

  CURSOR c_active IS
    SELECT lineitemidentifier
      FROM stc_lineitem
     WHERE provisioningFlag = 'ACTIVE'
    GROUP BY lineItemIdentifier
    HAVING COUNT(*) > 1;
 
  
  realActiveDocId stc_lineItem.cwDocId%TYPE;
  errMsg          VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceCursor IN c_active LOOP
    BEGIN
dbms_output.put_line('[INFO] Start lineItemIdentifier '||serviceCursor.lineitemidentifier);
      
      BEGIN
        SELECT cwdocid
          INTO realActiveDocId
          FROM (
            SELECT l.cwdocid
              FROM stc_bundleorder_header o, stc_lineitem l
             WHERE o.orderType = 'O'
               AND o.cworderid = l.cworderid
               AND l.provisioningFlag = 'ACTIVE'
               AND l.lineItemIdentifier = serviceCursor.lineitemidentifier
            ORDER BY NVL(o.receivedDate, to_date('01/01/1970', 'dd/mm/yyyy')) DESC)
         WHERE rownum < 2;

        IF(realActiveDocId IS NOT NULL) THEN
          UPDATE stc_lineitem
             SET provisioningFlag = 'OLD'
           WHERE lineItemIdentifier = serviceCursor.lineitemidentifier
             AND provisioningFlag = 'ACTIVE'
             AND cwdocid <> realActiveDocId;
        END IF;
      
      EXCEPTION
        WHEN no_data_found THEN
dbms_output.put_line('[INFO]    NO ''O'' order found for lineItemIdentifier '||serviceCursor.lineitemidentifier);
      END;
  
dbms_output.put_line('[INFO] Analized lineItemIdentifier '||serviceCursor.lineitemidentifier);

    EXCEPTION 
      WHEN others THEN
        errMsg := substr(sqlerrm, 1, 1000);
dbms_output.put_line('[ERR] Unexpected error while processing lineItemIdentifier '||serviceCursor.lineitemidentifier||': '||errMsg);

    END;
  
  END LOOP;
END;
/






/***
 * According to the receivedDate, it sets the provisioningFlag = "OLD" for the oldest records.
 * So at the end, only one record will have provisioningFlag = "ACTIVE"
 */ 
set serveroutput on

DECLARE

  CURSOR c_active IS
    SELECT lineitemidentifier
      FROM stc_lineitem
     WHERE provisioningFlag = 'ACTIVE'
    GROUP BY lineItemIdentifier
    HAVING COUNT(*) > 1;
 
  realActiveDocId stc_lineItem.cwDocId%TYPE;
  errMsg          VARCHAR2(1000);
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
  FOR serviceCursor IN c_active LOOP
    BEGIN
dbms_output.put_line('[INFO] Start lineItemIdentifier '||serviceCursor.lineitemidentifier);
      SELECT cwdocid
        INTO realActiveDocId
        FROM (SELECT l.cwdocid, h.receivedDate
                FROM stc_lineitem l, stc_bundleorder_header h
               WHERE l.lineItemIdentifier = serviceCursor.lineitemidentifier
                 AND l.provisioningFlag = 'ACTIVE'
                 AND l.cworderid = h.cworderid
              ORDER BY NVL(h.receivedDate, to_date('01/01/1970', 'dd/mm/yyyy')) DESC)
       WHERE rownum = 1;
  
      UPDATE stc_lineitem
         SET provisioningFlag = 'OLD'
       WHERE lineItemIdentifier = serviceCursor.lineitemidentifier
         AND provisioningFlag = 'ACTIVE'
         AND cwdocid <> realActiveDocId;
  
dbms_output.put_line('[INFO] Completed lineItemIdentifier '||serviceCursor.lineitemidentifier);

    EXCEPTION 
      WHEN others THEN
        errMsg := substr(sqlerrm, 1, 1000);
dbms_output.put_line('[ERR] Unexpected error while processing lineItemIdentifier '||serviceCursor.lineitemidentifier||': '||errMsg);

    END;
  
  END LOOP;
END;
/
