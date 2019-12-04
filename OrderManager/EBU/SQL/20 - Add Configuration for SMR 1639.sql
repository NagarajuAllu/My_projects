-- mapping between internal name and crm name of the new product
insert into STC_PRODUCTTYPE_NAME_MAP (CWDOCID, INTERNALPRODUCTTYPE, CRMPRODUCTTYPE) values (3, 'Bundle SIPMW', 'SIPBMW');

-- mapping between internal name and crm name of the circuits of the new product
insert into STC_SERVICETYPE_NAME_MAP (INTERNALSERVICETYPE, CRMSERVICETYPE) values ('SIPMW/Primary SIPMW', 'SIPMW');
insert into STC_SERVICETYPE_NAME_MAP (INTERNALSERVICETYPE, CRMSERVICETYPE) values ('SIPMW/Backup SIPMW', 'BSIPMW');

-- describe the behavior of the new servicetypes
insert into STC_SERVICETYPE_BEHAVIORCONFIG (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL, DISCONNECT_4_NVP_EXISTCIRCUIT) 
   values ('SIPMW', 1, 0, 1, 1, 1);
insert into STC_SERVICETYPE_BEHAVIORCONFIG (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL, DISCONNECT_4_NVP_EXISTCIRCUIT) 
   values ('BSIPMW', 1, 0, 1, 1, 0);

-- configure SIP to support disconnect
insert into STC_SERVICETYPE_BEHAVIORCONFIG (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL, DISCONNECT_4_NVP_EXISTCIRCUIT) 
   values ('SIP', 1, 0, 1, 1, 1);
insert into STC_SERVICETYPE_BEHAVIORCONFIG (SERVICETYPE, EXTERNAL_VALIDATION_REQUIRED, SEND_DISCONNECT_FOR_CANCEL, SUPPORT_PROVISIONING, SUPPORT_PARTIAL_CANCEL, DISCONNECT_4_NVP_EXISTCIRCUIT) 
   values ('BSIP', 1, 0, 1, 1, 0);

-- 
update STC_SERVICETYPE_BEHAVIORCONFIG 
   set DISCONNECT_4_NVP_EXISTCIRCUIT = 1
 where SERVICETYPE = 'SIP';

-- added the possible values for the NVPair 'Sub Order Type' when linked to serviceType 'SIPMW' or 'SIP'
-- removed according to the email shared by Dharvesh the 18th Feb
-- insert into STC_NVPAIR_SERVTYPE_PICKLIST (SERVICETYPE, NVPAIR_NAME, VALUE) values('SIPMW', 'Sub Order Type', 'Migration');
-- insert into STC_NVPAIR_SERVTYPE_PICKLIST (SERVICETYPE, NVPAIR_NAME, VALUE) values('SIPMW', 'Sub Order Type', 'Transfer');
-- insert into STC_NVPAIR_SERVTYPE_PICKLIST (SERVICETYPE, NVPAIR_NAME, VALUE) values('SIP', 'Sub Order Type', 'Migration');
-- insert into STC_NVPAIR_SERVTYPE_PICKLIST (SERVICETYPE, NVPAIR_NAME, VALUE) values('SIP', 'Sub Order Type', 'Transfer');

-- registered new bundle ProductType
insert into STC_BUNDLE_PRODUCTTYPE values('SIPBMW');

-- removing the 2 nv pair from the SKIP list to avoid any wrong behavior in case of updateOrder
delete from STC_SKIP_NVPAIR where name = 'Existing Circuit';
delete from STC_SKIP_NVPAIR where name = 'Sub Order Type';

-- according to the email shared by Vural the 10th Feb, automatic disconnect has to be disabled
update STC_SERVICETYPE_BEHAVIORCONFIG 
   set DISCONNECT_4_NVP_EXISTCIRCUIT = 0;
   
commit;
