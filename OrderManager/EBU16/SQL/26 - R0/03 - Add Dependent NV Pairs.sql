insert into stc_nvpair_dependencies (cwdocid, ordertype, servicetype, source_nvpair, source_nvpair_value, depend_nvpair) values (1, 'I', '*', 'AgreeToHeld', 'Yes', 'HeldReasonCode');
insert into stc_nvpair_dependencies (cwdocid, ordertype, servicetype, source_nvpair, source_nvpair_value, depend_nvpair) select max(to_number(cwdocid)) + 1, 'I', '*', 'AgreeToHeld', 'Yes', 'HeldReasonDescription' from stc_nvpair_dependencies;
insert into stc_nvpair_dependencies (cwdocid, ordertype, servicetype, source_nvpair, source_nvpair_value, depend_nvpair) select max(to_number(cwdocid)) + 1, 'C', '*', 'AgreeToHeld', 'Yes', 'HeldReasonCode' from stc_nvpair_dependencies;
insert into stc_nvpair_dependencies (cwdocid, ordertype, servicetype, source_nvpair, source_nvpair_value, depend_nvpair) select max(to_number(cwdocid)) + 1, 'C', '*', 'AgreeToHeld', 'Yes', 'HeldReasonDescription' from stc_nvpair_dependencies;

commit;
