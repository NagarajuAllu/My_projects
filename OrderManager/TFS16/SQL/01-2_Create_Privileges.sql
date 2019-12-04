-- Any new privilege added here has to be reported also in:
--   06-1_Create_Trigger_stc_cwPrivilegeDelete.sql

insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_IOrdInitPriv', '[STC] Install Order Initiator Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_IntegPriv', '[STC] Integration Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_NetwDesPriv', '[STC] Network Design Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_FacilityDes', '[STC] Facility Design Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_XCPriv', '[STC] XC Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_SwchActvPriv', '[STC] Switch Activation Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_QualityPriv', '[STC] Quality Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_SitePriv', '[STC] Site Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_VerificPriv', '[STC] Verification Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_BIPriv', '[STC] BI Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_ASBuiltPriv', '[STC] AS Built Team Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_TransMapPriv', '[STC] Transport Mapping Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_BBTransPriv', '[STC] BB Transport Design Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_FATxPriv', '[STC] FA-Tx Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_TFAModSqPriv', '[STC] TFA ModSquad Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_TFAPriv', '[STC] TFA Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_ASPriv', '[STC] Access Solution Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_FNIPriv', '[STC] Fixed Network Implementation Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_ConfigPriv', '[STC] Configuration Privilege');
insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_GroupMgrPriv', '[STC] Group Manager Privilege');
commit;
