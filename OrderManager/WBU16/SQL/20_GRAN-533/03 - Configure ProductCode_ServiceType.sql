insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F100', 0, 'ALL_OR_NOTHING', 0, 0, 0);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F001', 0, 'DEFAULT', 0, 0, 0);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F002', 0, 'DEFAULT', 0, 0, 1);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F003', 0, 'DEFAULT', 0, 0, 1);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F004', 0, 'DEFAULT', 0, 0, 1);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F005', 0, 'DEFAULT', 0, 0, 0);
insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('F006', 0, 'DEFAULT', 0, 0, 0);

insert into stcw_productcode (productcode, send_disconnect_for_cancel, feas_approach, require_validation_bos, is_vpn, is_provisionable) values ('LTE', 0, 'DEFAULT', 0, 0, 1);


insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F100', 'F100', null); -- the PLI for FTTH
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F001', 'F001', 'FTTH_LINK'); -- FTTH_LINK
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F002', 'FTTH_HSI', 'FTTH_HSI');
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F003', 'FTTH_VOIP', 'FTTH_VOIP');
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F004', 'FTTH_IPTV', 'FTTH_IPTV');
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F005', 'F005', 'ONT'); -- ONT
insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('F006', 'F006', 'STB'); -- STB

insert into stcw_servicetype_name_map(com_servicetype, gi_servicetype, som_internalname) values ('LTE', 'LTE', null); -- LTE


insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F100', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F001', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F002', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F003', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F004', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F005', 'F100', 'H');
insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('F006', 'F100', 'H');

insert into stcw_bu_provisioning(servicetype, productcode, cim) values ('LTE', 'LTE', 'M');

commit;