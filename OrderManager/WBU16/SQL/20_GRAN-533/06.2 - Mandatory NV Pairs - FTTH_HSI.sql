-- Provider
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F002', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F002', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F002', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F002', 'Provider' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F002', 'Provider' from stcw_nvnames_mandatory;

-- BBUserID
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F002', 'BBUserID' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F002', 'BBUserID' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F002', 'BBUserID' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F002', 'BBUserID' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F002', 'BBUserID' from stcw_nvnames_mandatory;

-- BBPassword
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'I', 'F002', 'BBPassword' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'C', 'F002', 'BBPassword' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'F', 'F002', 'BBPassword' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'D', 'F002', 'BBPassword' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair) select max(to_number(cwdocid)) + 1, 'E', 'F002', 'BBPassword' from stcw_nvnames_mandatory;

-- DownstreamBandwidth
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair, datatype) select max(to_number(cwdocid)) + 1, 'I', 'F002', 'DownstreamBandwidth', 'Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair, datatype) select max(to_number(cwdocid)) + 1, 'C', 'F002', 'DownstreamBandwidth', 'Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair, datatype) select max(to_number(cwdocid)) + 1, 'F', 'F002', 'DownstreamBandwidth', 'Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair, datatype) select max(to_number(cwdocid)) + 1, 'D', 'F002', 'DownstreamBandwidth', 'Number' from stcw_nvnames_mandatory;
insert into stcw_nvnames_mandatory(cwdocid, orderType, serviceType, nameNVPair, datatype) select max(to_number(cwdocid)) + 1, 'E', 'F002', 'DownstreamBandwidth', 'Number' from stcw_nvnames_mandatory;

commit;