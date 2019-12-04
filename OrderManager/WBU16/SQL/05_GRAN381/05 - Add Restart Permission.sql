insert into CWPRIVILEGE (PRIVILEGE, DESCRIPTION) values ('stcwRestartProc', 'STCW Restart Process');
insert into CWROLE (ROLEID, ROLE_NAME, CALENDAR) values ('Restart Process Group', 'Restart Process Group', 'stc');
insert into CWUSERGROUPPRIVILEGE (PRIVILEGE, USERGROUP) values ('stcwRestartProc', 'Restart Process Group');

commit;
