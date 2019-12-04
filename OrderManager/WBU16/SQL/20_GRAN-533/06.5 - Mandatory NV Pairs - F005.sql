-- Provider
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'Provider' from stcw_nvnames_mandatory;

-- Serial_Number
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'ONT_SN' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'ONT_SN' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'ONT_SN' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'ONT_SN' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'ONT_SN' from stcw_nvnames_mandatory;

-- FaultyType
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'ONT_Faulty_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'ONT_Faulty_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'ONT_Faulty_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'ONT_Faulty_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'ONT_Faulty_Type' from stcw_nvnames_mandatory;

-- Model_Type
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'ONT_Model_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'ONT_Model_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'ONT_Model_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'ONT_Model_Type' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'ONT_Model_Type' from stcw_nvnames_mandatory;

-- MAC_Address
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'ONT_MAC_Address' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'ONT_MAC_Address' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'ONT_MAC_Address' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'ONT_MAC_Address' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'ONT_MAC_Address' from stcw_nvnames_mandatory;

-- In-Warranty
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F005', 'ONT_In-Warranty' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F005', 'ONT_In-Warranty' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F005', 'ONT_In-Warranty' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F005', 'ONT_In-Warranty' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F005', 'ONT_In-Warranty' from stcw_nvnames_mandatory;

commit;