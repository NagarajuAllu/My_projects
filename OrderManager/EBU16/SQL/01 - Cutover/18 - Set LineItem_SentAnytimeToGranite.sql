UPDATE stc_lineItem
   SET sentAnytimeToGranite = alreadySentToGranite;


UPDATE stc_lineItem
   SET sentAnytimeToGranite = 1
 WHERE (sentAnytimeToGranite IS NULL or sentAnytimeToGranite = 0)
   AND workOrderNumber IS NOT NULL
   AND workOrderNumber = (SELECT wo_name
                            FROM rms_prod.work_order_inst@rms_prod_db_link
                           WHERE wo_name = workOrderNumber);

COMMIT;
