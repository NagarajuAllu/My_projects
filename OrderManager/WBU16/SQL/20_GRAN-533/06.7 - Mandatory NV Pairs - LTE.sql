-- PrimaryPhoneNumber
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'LTE', 'PrimaryPhoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'LTE', 'PrimaryPhoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'LTE', 'PrimaryPhoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'LTE', 'PrimaryPhoneNumber' from stcw_nvnames_mandatory;

-- SIM Number
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'LTE', 'SIM Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'LTE', 'SIM Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'LTE', 'SIM Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'LTE', 'SIM Number' from stcw_nvnames_mandatory;

-- IMSI Number
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'LTE', 'IMSI Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'LTE', 'IMSI Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'LTE', 'IMSI Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'LTE', 'IMSI Number' from stcw_nvnames_mandatory;

-- Speed Profile
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'LTE', 'Speed Profile' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'LTE', 'Speed Profile' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'LTE', 'Speed Profile' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'LTE', 'Speed Profile' from stcw_nvnames_mandatory;

-- Provider
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'LTE', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'LTE', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'LTE', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'LTE', 'Provider' from stcw_nvnames_mandatory;

commit;