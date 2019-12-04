insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_DiscOrder', '[STC] Disconnect Order');
insert into CWROLE (ROLEID, ROLE_NAME, CALENDAR) values ('DisconnectOrderGroup', 'DisconnectOrderGroup', 'stc');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_DiscOrder', 'DisconnectOrderGroup');

commit;
