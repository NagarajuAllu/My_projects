insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('STC_RestartProc', '[STC] Restart Process');
insert into CWROLE (ROLEID, ROLE_NAME, CALENDAR) values ('Restart Process Group', 'Restart Process Group', 'stc');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('STC_RestartProc', 'Restart Process Group');

commit;
