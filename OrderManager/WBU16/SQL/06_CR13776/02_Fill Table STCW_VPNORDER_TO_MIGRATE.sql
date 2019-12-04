INSERT INTO stcw_vpnorder_to_migrate(ordernumber, ordertype, orderstatus, lineitemidentifier, producttype, servicetype, receivedservicetype, servicenumber, lineitemstatus, 
                                     is_bundle, elementtypeinordertree, provisioningflag, provisioningflag_order, count_process_running, cworderid, lineitemdocid, result_process)
SELECT h.ordernumber, h.ordertype, h.orderstatus,
       l.lineitemidentifier, l.producttype, l.servicetype, l.receivedservicetype, l.servicenumber, l.lineitemstatus,
       DECODE((SELECT COUNT(*) FROM stcw_lineitem WHERE cworderid = h.cworderid), 0, 0,
                                                                                  1, 0,
                                                                                     1) is_bundle,
       l.elementtypeinordertree, l.provisioningflag,
       DECODE(l.elementtypeinordertree, 'B', NULL,
                                             (SELECT x.provisioningflag FROM stcw_lineitem x WHERE x.cworderid = l.cworderid AND x.elementtypeinordertree = 'B') ) provisioningflag_order,
       (SELECT COUNT(*) FROM cwprocess_not_completed WHERE order_id = h.cworderid AND status NOT IN (3, 6)) count_process_running,
       h.cworderid, l.cwdocid, 0
  FROM stcw_bundleorder_header h, stcw_lineitem l
 WHERE h.cworderid = l.cworderid
   AND ((l.producttype IN ('D100', 'D101') AND l.lineitemType = 'Bundle') OR (l.producttype IN ('D054', 'D055', 'D058')))
   AND l.cworderid IN (SELECT cworderid FROM stcw_lineitem WHERE provisioningflag in ('ACTIVE', 'PROVISIONING'))
   ;
COMMIT;