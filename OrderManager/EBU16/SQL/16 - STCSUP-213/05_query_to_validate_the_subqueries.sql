    select h.ordernumber, h.orderstatus, h.cworderid,
           l.lineitemidentifier, l.servicenumber, l.servicetype, l.workordernumber, l.action, l.lineitemstatus, l.lineitemtype, l.issubmit, l.iscancel,
           (select pli.provisioningflag from stc_lineitem pli where pli.cworderid = h.cworderid and pli.elementtypeinordertree = 'B') pli_provisioningFlag,
           w.wo_name, w.element_name, w.elm_compl_status, w.status, w.actual_compl, v.status_name,
           (select count(*) from cwprocess_not_completed where order_id = h.cworderid and status not in (3,6)) count_processes
      from stc_bundleorder_header h, stc_lineitem l, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
     where l.lineitemstatus in ('FAILED_SUBMIT', 'SUBMIT_FAILED', 'FAILED')
       and h.cworderid = l.cworderid
       and l.workordernumber = w.wo_name
       and l.workordernumber is not null
       and w.status in (7, 8)
       and w.status = v.stat_code
       and l.cworderid in (select cworderid from stc_lineitem where provisioningflag = 'PROVISIONING')
       and h.ordernumber not in ('I4480416', 'I4481909', 'I4462763', 'I4527341') -- these order have the element cancelled in GI even if the cancel flow was not received in EOC

minus 
(
    select h.ordernumber, h.orderstatus, h.cworderid,
           l.lineitemidentifier, l.servicenumber, l.servicetype, l.workordernumber, l.action, l.lineitemstatus, l.lineitemtype, l.issubmit, l.iscancel, l.provisioningFlag,
           w.wo_name, w.element_name, w.elm_compl_status, w.status, w.actual_compl, v.status_name,
           (select count(*) from cwprocess_not_completed where order_id = h.cworderid and status not in (3,6)) count_processes
      from stc_bundleorder_header h, stc_lineitem l, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
     where l.lineitemstatus in ('FAILED_SUBMIT', 'SUBMIT_FAILED', 'FAILED')
       and h.cworderid = l.cworderid
       and l.workordernumber = w.wo_name
       and l.workordernumber is not null
       and w.status in (7, 8)
       and w.status = v.stat_code
       and l.cworderid in (select cworderid from stc_lineitem where provisioningflag = 'PROVISIONING')
       and l.iscancel = 0
       and l.lineitemtype = 'Root'
       and l.elementtypeinordertree = 'B'
       and h.ordernumber not in ('I4480416', 'I4481909', 'I4462763', 'I4527341')  -- these order have the element cancelled in GI even if the cancel flow was not received in EOC

union

    select h.ordernumber, h.orderstatus, h.cworderid,
           l.lineitemidentifier, l.servicenumber, l.servicetype, l.workordernumber, l.action, l.lineitemstatus, l.lineitemtype, l.issubmit, l.iscancel,  l.provisioningFlag,
           w.wo_name, w.element_name, w.elm_compl_status, w.status, w.actual_compl, v.status_name,
           (select count(*) from cwprocess_not_completed where order_id = h.cworderid and status not in (3,6)) count_processes
      from stc_bundleorder_header h, stc_lineitem l, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
     where l.lineitemstatus in ('FAILED_SUBMIT', 'SUBMIT_FAILED', 'FAILED')
       and h.cworderid = l.cworderid
       and l.workordernumber = w.wo_name
       and l.workordernumber is not null
       and w.status in (7, 8)
       and w.status = v.stat_code
       and l.cworderid in (select cworderid from stc_lineitem where provisioningflag = 'PROVISIONING')
       and l.iscancel = 1
       and l.lineitemtype = 'Root'
       and l.elementtypeinordertree = 'B'
       and h.ordernumber not in ('I4480416', 'I4481909', 'I4462763', 'I4527341') -- these order have the element cancelled in GI even if the cancel flow was not received in EOC

union
    select h.ordernumber, h.orderstatus, h.cworderid,
           l.lineitemidentifier, l.servicenumber, l.servicetype, l.workordernumber, l.action, l.lineitemstatus, l.lineitemtype, l.issubmit, l.iscancel,
           (select pli.provisioningflag from stc_lineitem pli where pli.cworderid = h.cworderid and pli.elementtypeinordertree = 'B') pli_provisioningFlag,
--           (select pli.lineitemidentifier from stc_lineitem pli where pli.cworderid = h.cworderid and pli.elementtypeinordertree = 'B') pli_identifier,
           w.wo_name, w.element_name, w.elm_compl_status, w.status, w.actual_compl, v.status_name,
           (select count(*) from cwprocess_not_completed where order_id = h.cworderid and status not in (3,6)) count_processes
      from stc_bundleorder_header h, stc_lineitem l, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
     where l.lineitemstatus in ('FAILED_SUBMIT', 'SUBMIT_FAILED', 'FAILED')
       and h.cworderid = l.cworderid
       and l.workordernumber = w.wo_name
       and l.workordernumber is not null
       and w.status in (7, 8)
       and w.status = v.stat_code
       and l.cworderid in (select cworderid from stc_lineitem where provisioningflag = 'PROVISIONING')
       and l.iscancel = 0
       and l.lineitemtype <> 'Root'
       and l.elementtypeinordertree <> 'B'
       and h.ordernumber not in ('I4480416', 'I4481909', 'I4462763', 'I4527341') -- these order have the element cancelled in GI even if the cancel flow was not received in EOC
)