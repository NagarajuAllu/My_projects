-- UPADMIN
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('AddFavorite', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('CWAdminApp', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('CWApi', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('DelFavorite', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('Everyone', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('PMAdmin', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('PRPriority', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('RTAdmin', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('ShowError', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('UPAdmin', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WDelegate', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WGAvailable', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WGManager', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WGSelect', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WLAdmin', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WReturn', 'User Profile Administrators');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('WTakeOn', 'User Profile Administrators');
commit;

-- GROUP MANAGER TEAM
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_GroupMgrPriv', 'Group Managers Team');
commit;



declare
  cursor GROUPS is
    select ROLEID
      from CWROLE
     where ROLEID <> 'User Profile Administrators';

  TYPE PrivilegeList IS TABLE OF VARCHAR2(16);
  PRIVILEGES PrivilegeList;
begin
  
  PRIVILEGES := PrivilegeList('CWApi',
                              'ShowError',
                              'WDelegate',
                              'WGAvailable',
                              'WGSelect',
                              'WReturn',
                              'WTakeOn');
  
  for G in GROUPS loop
    begin
      
      for R in PRIVILEGES.first .. PRIVILEGES.last loop
        begin
          insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values (PRIVILEGES(R), G.ROLEID);
        end;
      end loop;
      
    end;
  end loop;
end;
/


insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_IOrdInitPriv', 'Network Implementation Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_IOrdInitPriv', 'BU-EBU Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_IOrdInitPriv', 'BU-WBU Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_IOrdInitPriv', 'Jawal Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_IntegPriv', 'Integration Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_NetwDesPriv', 'Network Design Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_FacilityDes', 'Facility Design Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_XCPriv', 'CrossConnection Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_SwchActvPriv', 'Switch Activation Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_QualityPriv', 'Quality Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_SitePriv', 'Site Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_VerificPriv', 'Verification Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_BIPriv', 'BI Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_ASBuiltPriv', 'AS-Built Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_TransMapPriv', 'Transport Mapping Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_BBTransPriv', 'BB Transport Design Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_FATxPriv', 'FA-Tx Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_TFAModSqPriv', 'TFA ModSquad Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_TFAPriv', 'TFA Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_ASPriv', 'Access Solution Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_FNIPriv', 'Fixed Network Implementation Team');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_ConfigPriv', 'Configuration Team');
commit;

