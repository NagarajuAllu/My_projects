-- Provider
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F003', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F003', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F003', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F003', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F003', 'Provider' from stcw_nvnames_mandatory;

-- PrimaryPhoneNumber
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F003', 'TelephoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F003', 'TelephoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F003', 'TelephoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F003', 'TelephoneNumber' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F003', 'TelephoneNumber' from stcw_nvnames_mandatory;

commit;