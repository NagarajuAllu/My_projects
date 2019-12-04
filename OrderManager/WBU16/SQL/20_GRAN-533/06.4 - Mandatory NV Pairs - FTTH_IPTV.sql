-- Invision_Key
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F004', 'Invision_Key' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F004', 'Invision_Key' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F004', 'Invision_Key' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F004', 'Invision_Key' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F004', 'Invision_Key' from stcw_nvnames_mandatory;

-- Provider
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F004', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F004', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F004', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F004', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F004', 'Provider' from stcw_nvnames_mandatory;

-- Primary
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F004', 'Primary' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F004', 'Primary' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F004', 'Primary' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F004', 'Primary' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F004', 'Primary' from stcw_nvnames_mandatory;

commit;