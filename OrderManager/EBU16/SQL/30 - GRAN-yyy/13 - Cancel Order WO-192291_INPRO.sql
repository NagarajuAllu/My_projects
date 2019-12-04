update stc_lineitem
   set lineitemstatus = 'CANCELLED',
       completiondate = sysdate,
       remarks = to_char(sysdate, 'yyyy/mm/dd')||' - Order Cancelled manually using SQL procedure'||chr(10)||remarks,
       iscancel = 1,
       alreadyreceivedcancel = 1
 where cworderid in (select cworderid from stc_bundleorder_header where ordernumber = 'WO-192291_INPRO');

update stc_lineitem
   set provisioningFlag = 'CANCELLED'
 where cworderid in (select cworderid from stc_bundleorder_header where ordernumber = 'WO-192291_INPRO')
   and elementtypeinordertree = 'B';
       
update stc_bundleorder_header 
   set orderstatus = 'CANCELLED', 
       completiondate = sysdate,
       remarks = to_char(sysdate, 'yyyy/mm/dd')||' - Order Cancelled manually using SQL procedure'||chr(10)||remarks
 where ordernumber = 'WO-192291_INPRO';

commit;
