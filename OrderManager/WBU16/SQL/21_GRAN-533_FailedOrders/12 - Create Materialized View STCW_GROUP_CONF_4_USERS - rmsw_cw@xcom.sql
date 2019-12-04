drop materialized view STCW_GROUP_CONF_4_USERS;

create materialized view STCW_GROUP_CONF_4_USERS
refresh complete
as 
select g.*, ur.userid 
  from stcw_group_configuration@cww_eoc16_link g, cwuserrole@cww_eoc16_link ur
 where g.groupname = ur.roleid;


alter materialized view STCW_GROUP_CONF_4_USERS
refresh
start with sysdate 
next (sysdate)+5/1440;
