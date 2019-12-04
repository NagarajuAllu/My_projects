-- STCW_PRODUCTCODE
insert into STCW_PRODUCTCODE (PRODUCTCODE, SEND_DISCONNECT_FOR_CANCEL, FEAS_APPROACH, REQUIRE_VALIDATION_BOS) values ('C041', 0, 'ALL_OR_NOTHING', 0);

-- STCW_SERVICETYPE_NAME_MAP
insert into STCW_SERVICETYPE_NAME_MAP (COM_SERVICETYPE, GI_SERVICETYPE) values ('C041', 'GEF');

-- STCW_BU_PROVISIONING
insert into STCW_BU_PROVISIONING(SERVICETYPE, PRODUCTCODE, CIM) values ('C041', 'C041', 'E');

insert into STCW_STOREFORWARD_NVPAIR values ('Site_A_Customer_name');
insert into STCW_STOREFORWARD_NVPAIR values ('Submarine');
insert into STCW_STOREFORWARD_NVPAIR values ('LatitudeA');
insert into STCW_STOREFORWARD_NVPAIR values ('LongitudeA');
insert into STCW_STOREFORWARD_NVPAIR values ('Terminating Point');
insert into STCW_STOREFORWARD_NVPAIR values ('LatitudeB');
insert into STCW_STOREFORWARD_NVPAIR values ('LongitudeB');
insert into STCW_STOREFORWARD_NVPAIR values ('Customer Address');
insert into STCW_STOREFORWARD_NVPAIR values ('Originating Point');
insert into STCW_STOREFORWARD_NVPAIR values ('Interface_Capacity');
insert into STCW_STOREFORWARD_NVPAIR values ('Interface_Quantity');
insert into STCW_STOREFORWARD_NVPAIR values ('Agreement_Type');
insert into STCW_STOREFORWARD_NVPAIR values ('Business_Model');
insert into STCW_STOREFORWARD_NVPAIR values ('Agreement_Term');
insert into STCW_STOREFORWARD_NVPAIR values ('Payment_Model');
insert into STCW_STOREFORWARD_NVPAIR values ('Payment_Type');

commit;
