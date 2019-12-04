insert into stcw_productcode select distinct productcode from stcw_order_header;
insert into stcw_servicetype_name_map select productcode, productcode from  stcw_productcode;
insert into stcw_bu_provisioning select productcode, productcode, 'W' from stcw_productcode;
commit;