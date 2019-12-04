set define OFF


insert into CWPRIVILEGE(PRIVILEGE, DESCRIPTION) values ('foActive', 'FO Active');

insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'foActiveUsersGroup', 'FO Active Users Group', CALENDAR from CWCALENDARS;

insert into CWUSERGROUPPRIVILEGE(PRIVILEGE, USERGROUP, PROFILEPROVIDER) values ('foActive', 'foActiveUsersGroup', 'CWUP');

-- the groups for technician
insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'CSDD_ESP_FTTx_OLO', 'FO Pre Technician Users Group', CALENDAR from CWCALENDARS;
insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'CSDD_Pioneers_C&E_FTTx_OLO', 'FO Central and East Users Group', CALENDAR from CWCALENDARS;
insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'CSDD_Pioneers_W&S_FTTx_OLO', 'FO West and South Users Group', CALENDAR from CWCALENDARS;
insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'TECH_FAILURE', 'FO Technical Failure Users Group', CALENDAR from CWCALENDARS;



commit;
