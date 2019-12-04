insert into cwprivilege(privilege, description) values ('mobileErrorRes', 'Mobile Error Resolution');

insert into cwrole(roleid, role_name, calendar) select 'Mobile Error Resolution Group', 'Mobile Error Resolution Group', calendar from cwcalendars where rownum = 1;

insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('WGAvailable', 'Mobile Error Resolution Group', 'CWUP');
-- insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('WLAdmin', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('WReturn', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('CWApi', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('ShowError', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('WDelegate', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('mobileErrorRes', 'Mobile Error Resolution Group', 'CWUP');
insert into cwusergroupprivilege(privilege, usergroup, profileprovider) values ('WTakeOn', 'Mobile Error Resolution Group', 'CWUP');

commit;
