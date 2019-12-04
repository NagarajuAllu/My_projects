prompt Filling table STC_ROUNDROBIN_MGMT....

insert into stc_roundrobin_mgmt values (1, 'upadmin', 0);

declare

  newCwDocId stc_roundrobin_mgmt.cwdocid%type;
  cursor userIds is 
    select userid from cwuser where userid <> 'upadmin';
    
begin
  
  for u in userIds loop

    SELECT TO_CHAR(MAX(TO_NUMBER(cwdocid)) + 1) 
      INTO newCwDocId
      FROM stc_roundrobin_mgmt;

    INSERT INTO stc_roundrobin_mgmt (cwdocid, user_id, token)
    VALUES (newCwDocId, u.userid, 0);
  end loop;
end;
/




commit;
