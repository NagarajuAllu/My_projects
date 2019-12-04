CREATE OR REPLACE VIEW STCW_COMPLETEDWO_4_OPENORDERS AS
SELECT p.process_id, 
       l.cwDocId, l.serviceNumber, l.cwOrderId, l.workOrderNumber, l.elementTypeInOrderTree, l.provisioningBU, l.orderRowItemId, l.reservationNumber,
       h.orderNumber, h.ordertype,
       w.wo_inst_id, w.element_type, w.element_inst_id, v.status_name
  FROM cwprocess_not_completed p, cwmdtypes t, stcw_lineitem l, stcw_bundleorder_header h, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
 WHERE p.process_metadatype = t.typeid
   AND t.typename in ('stcw.mainSTCWProvisiongProcess', 'stcw.mainSTCWProvisiongProcess_2', 'stcw.mainSTCWProvisiongProcess_3', 'stcw.mainSTCWProvisiongProcess_4', 
                      'stcw.mainSTCWQuoteProvisioningProcess', 'stcw.mainSTCWQuoteProvisioningProcess_2', 'stcw.mainSTCWQuoteProvisioningProcess_3')
   AND p.status = 1
   AND l.cwdocid = p.order_item_id
   AND l.cworderid = p.order_id
   AND h.cworderid = l.cworderid
   AND w.wo_name = l.workordernumber
   AND v.stat_code = w.status
   AND w.status in (7, 8)
   AND h.ordernumber not like '%_CANC_201%'
   AND h.ordernumber not like '%_REVI_201%';
