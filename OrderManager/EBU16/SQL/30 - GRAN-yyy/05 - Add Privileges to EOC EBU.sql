insert into CWPRIVILEGE(PRIVILEGE, DESCRIPTION) values ('STC_CancelOrder', '[STC] Cancel Order');

insert into CWROLE(ROLEID, ROLE_NAME, CALENDAR) select 'cancelOrderGroup', 'STC_CancelOrder', CALENDAR from CWCALENDARS;

insert into CWUSERGROUPPRIVILEGE(PRIVILEGE, USERGROUP, PROFILEPROVIDER) values ('STC_CancelOrder', 'cancelOrderGroup', 'CWUP');

commit;
