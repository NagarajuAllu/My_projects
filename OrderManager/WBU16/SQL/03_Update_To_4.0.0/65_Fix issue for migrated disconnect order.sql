update stcw_lineitem set lineitemidentifier = '1-286748475', remarks = 'Changed the lineItemIdentifier from 1-255155246 to 1-286748475 during migration to link the cancelled order to the real disconnection.'||chr(10)||remarks where lineitemidentifier = '1-255155246';

update stcw_lineitem set lineitemidentifier = '1-350098849', remarks = 'Changed the lineItemIdentifier from 1-322749220 to 1-350098849 during migration to link the cancelled order to the real disconnection.'||chr(10)||remarks where lineitemidentifier = '1-322749220';

update stcw_lineitem set lineitemidentifier = '1-269082336', remarks = 'Changed the lineItemIdentifier from 1-306041390 to 1-269082336 during migration to link the cancelled order to the latest active order.'||chr(10)||remarks where lineitemidentifier = '1-306041390';

update stcw_lineitem set lineitemidentifier = '1-358806536', remarks = 'Changed the lineItemIdentifier from 1-160003851 to 1-358806536 during migration to link the cancelled order to the real disconnection.'||chr(10)||remarks where lineitemidentifier = '1-160003851';
update stcw_lineitem set lineitemstatus = 'CANCELLED', provisioningFlag = 'CANCELLED' where cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-160003851');
update stcw_bundleorder_header set orderstatus = 'CANCELLED' where ordernumber = '1-160003851';

update stcw_lineitem set lineitemidentifier = '1-286750099', remarks = 'Changed the lineItemIdentifier from 1-255582870 to 1-286750099 during migration to link the cancelled order to the latest active order.'||chr(10)||remarks where lineitemidentifier = '1-255582870';
