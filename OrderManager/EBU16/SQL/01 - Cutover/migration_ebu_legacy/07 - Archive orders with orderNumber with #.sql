/**
 * These records have orderNumber = #, so it means they received an update; so they are "OLD"
 */
update stc_lineItem set provisioningFlag = 'OLD' where cworderid in (select cworderid from stc_bundleorder_header where ordernumber like '%#%' and length(substr(ordernumber, instr(ordernumber, '#')+1)) = 19);
update stc_lineItem set provisioningFlag = 'OLD' where cworderid in (select cworderid from stc_bundleorder_header where ordernumber like '%_OLD');

commit;