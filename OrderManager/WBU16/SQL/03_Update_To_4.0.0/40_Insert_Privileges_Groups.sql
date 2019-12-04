-- Privileges
insert into cwprivilege (privilege, description) values ('stcwMigrateMgmt', 'STCW Migration Management');
insert into cwprivilege (privilege, description) values ('stcwConfigMgmt', 'STCW Configuration Management');

declare
  calendarName cwcalendars.calendar%type;
begin
  
  select calendar
    into calendarName
    from cwcalendars;
    
  -- Groups
  insert into cwrole(roleid, role_name, calendar) values('Configuration Management Group', 'Group to manage configuration of WBU', calendarName);

  -- Privileges to Groups
  insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('stcwConfigMgmt', 'Configuration Management Group', 'CWUP');

  -- UPADMIN in Groups
  insert into cwuserrole(userid, roleid, active, manager) values ('upadmin', 'Configuration Management Group', 1, 0);
end;
/


commit;