create or replace trigger STC_BOH_AUDIT_TRG
  after update on STC_BUNDLEORDER_HEADER
  for each row
begin

  if(sys_context('userenv','host') not like 'AVM Node:%') then
    if(:new.ORDERSTATUS <> :old.ORDERSTATUS) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_BUNDLEORDER_HEADER', 'ORDERSTATUS', :old.ORDERSTATUS, :new.ORDERSTATUS, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.COMPLETIONDATE <> :old.COMPLETIONDATE) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_BUNDLEORDER_HEADER', 'COMPLETIONDATE', :old.COMPLETIONDATE, :new.COMPLETIONDATE, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
  end if;
end;
/

