declare
  cursor users is
    select userid from cwuser where userid not in (select userid from cwuserrole where roleid = 'buGroup') and userid <> 'upadmin';
begin

  for u in users loop
    insert into cwuserrole(userid, roleid, active, manager) values (u.userid, 'buGroup', 1, 0);
  end loop;
end;
/  
  