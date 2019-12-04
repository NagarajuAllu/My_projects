CREATE OR REPLACE PROCEDURE STC_Extract_Orders_Not_In_Sync 
AS

  wo_status_code NUMBER(1);
  wo_status_name VARCHAR2(20);
  
  CURSOR wd_orders IS
    SELECT h.ordernumber, h.orderstatus
      FROM stc_order_message_home h 
     WHERE h.cwordercreationdate >= TO_DATE('01/01/2016', 'DD/MM/YYYY') 
       AND h.orderstatus NOT IN ('COMPLETED', 'CANCELLED')
       AND h.parentordernumber IS NOT NULL
       AND h.ccttype <> 'SIP';

BEGIN
 
  FOR o IN wd_orders LOOP
    BEGIN
      SELECT woi.status, vts.status_name
        INTO wo_status_code, wo_status_name
        FROM work_order_inst@rms_prod_db_link woi, val_task_status@rms_prod_db_link vts 
       WHERE woi.wo_name = o.ordernumber
         AND vts.stat_code = woi.status;
  
      IF (wo_status_name IN ('COMPLETED', 'CANCELLED')) THEN
        
        INSERT INTO stc_orders_not_in_sync (id, ordernumber, gi_status_code, gi_status_name)
                                    VALUES (stc_orders_not_in_sync_seq.nextval, o.ordernumber, wo_status_code, wo_status_name);
                                    
      ELSIF (wo_status_name = 'ON-HOLD' AND o.orderstatus <> 'ON-HOLD') THEN
        
        INSERT INTO stc_orders_not_in_sync (id, ordernumber, gi_status_code, gi_status_name)
                                    VALUES (stc_orders_not_in_sync_seq.nextval, o.ordernumber, wo_status_code, wo_status_name);
      
      END IF;
  
    EXCEPTION
       WHEN others THEN
          NULL;
    END;
  END LOOP;
  
END;
/