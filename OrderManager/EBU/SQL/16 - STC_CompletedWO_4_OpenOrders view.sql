CREATE OR REPLACE VIEW STC_COMPLETEDWO_4_OPENORDERS AS
SELECT p.process_id, l.cwDocId, l.serviceNumber, l.cwOrderId, l.workOrderNumber, l.elementTypeInOrderTree, h.orderNumber, w.element_type, w.element_inst_id, v.status_name
  FROM cwprocess p, cwmdtypes t, stc_lineitem l, stc_bundleorder_header h, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
 WHERE p.process_metadatype = t.typeid
   AND t.typename = 'processSTC.mainSTCProvisiongProcess'
   AND p.status = 1
   AND l.cwdocid = p.order_item_id
   AND l.cworderid = p.order_id
   AND h.cworderid = l.cworderid
   AND w.wo_name = l.workordernumber
   AND v.stat_code = w.status
   AND w.status in (7, 8);
