prompt Importing table STC_NVNAMES_MANDATORY...

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('16', 'C', 'ATMMVPN', 'APN Name');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('17', 'C', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('18', 'C', 'ATMMVPN', 'Change SIM');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('19', 'C', 'ATMMVPN', 'EQOSID');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('20', 'C', 'ATMMVPN', 'PROFILE_ID');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('21', 'D', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('22', 'E', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('23', 'I', 'ATMMVPN', 'APN Name');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('24', 'I', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('25', 'I', 'ATMMVPN', 'EQOSID');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('26', 'I', 'ATMMVPN', 'PROFILE_ID');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('27', 'O', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('28', 'T', 'ATMMVPN', 'APN Name');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('29', 'T', 'ATMMVPN', 'Bandwidth');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('30', 'T', 'ATMMVPN', 'EQOSID');

insert into stc_nvnames_mandatory (CWDOCID, ORDERTYPE, SERVICETYPE, NAMENVPAIR)
values ('31', 'T', 'ATMMVPN', 'PROFILE_ID');

commit;

prompt Done.


-- MR: setting up serviceType Behavior to send permanent disconnect for cancel

prompt Importing table STC_SERVICETYPE_BEHAVIORCONFIG...

insert into stc_servicetype_behaviorconfig (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL)
values ('MATM', 1, 1, 1, 0);

insert into stc_servicetype_behaviorconfig (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL)
values ('IP', 1, 1, 1, 0);

insert into stc_servicetype_behaviorconfig (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL)
values ('SKY', 1, 1, 1, 0);

insert into stc_servicetype_behaviorconfig (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL)
values ('ATMMVPN', 1, 1, 1, 1);

commit;

prompt Done.


-- MR: setting up ProductType Name Map

prompt Importing table STC_PRODUCTTYPE_NAME_MAP...

insert into STC_PRODUCTTYPE_NAME_MAP (CWDOCID, INTERNALPRODUCTTYPE, CRMPRODUCTTYPE) values (2, 'Bundle MATM', 'MATM');

commit;

prompt Done.

-- MR: setting up ServiceType Name Map

prompt Importing table STC_SERVICETYPE_NAME_MAP...

insert into STC_SERVICETYPE_NAME_MAP (INTERNALSERVICETYPE, CRMSERVICETYPE) values ('MATM/IPVPN', 'IP');
insert into STC_SERVICETYPE_NAME_MAP (INTERNALSERVICETYPE, CRMSERVICETYPE) values ('MATM/VSAT', 'SKY');
insert into STC_SERVICETYPE_NAME_MAP (INTERNALSERVICETYPE, CRMSERVICETYPE) values ('MATM/MOBILE', 'ATMMVPN');

commit;

prompt Done.
