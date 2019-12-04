update stcw_lineitem set lineItemIdentifier = '1-314863306', remarks = 'Changed the lineItemIdentifier from 1-340533900#1 to 1-314863306 during migration to link the quote to the order.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-340533900#1');

