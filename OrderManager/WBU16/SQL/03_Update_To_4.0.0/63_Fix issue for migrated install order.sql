update stcw_bundleorder_header set orderstatus = 'CANCELLED', completiondate = sysdate where ordernumber in ('MTP4', 'MTP5');
update stcw_lineitem set lineitemstatus = 'CANCELLED', completiondate = sysdate, provisioningFlag = 'CANCELLED', remarks = 'Set to CANCELLED during migration because the AssetNumber is missing in Granite' where cworderid in (select cworderid from stcw_bundleorder_header where ordernumber in ('MTP4', 'MTP5'));

update stcw_lineitem set servicenumber = 'D15I-2000028-A', remarks = 'Changed the serviceNumber from D15I-2000027-A to D15I-2000028-A during migration to be in sync with Granite.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-136852669');

update stcw_lineitem set servicenumber = 'DUBAI-RIYADH W-PLL2_WBU', remarks = 'Changed the serviceNumber from D020-0000075-A to DUBAI-RIYADH W-PLL2_WBU during migration to be in sync with Granite.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-374295736');

update stcw_lineitem set servicenumber = 'D15N-1000002-B', remarks = 'Changed the serviceNumber from D15N-0000001-A to D15N-1000002-B during migration to be in sync with Granite.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-9391127');

update stcw_lineitem set servicenumber = 'D016-0000031-A-BK', remarks = 'Changed the serviceNumber from D016-0000031-A to D016-0000031-A-BK during migration to be in sync with Granite.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-137502569');

update stcw_lineitem set servicenumber = 'D016-0000022-A-BK', remarks = 'Changed the serviceNumber from D016-0000022-A to D016-0000022-A-BK during migration to be in sync with Granite.'||chr(10)||remarks where  cworderid in (select cworderid from stcw_bundleorder_header where ordernumber = '1-137499039');

