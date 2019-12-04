create or replace trigger STC_LI_AUDIT_TRG
  after update on STC_LINEITEM
  for each row
begin

  if(sys_context('userenv','host') not like 'AVM Node:%') then
    if(:new.ALREADYRECEIVEDCANCEL <> :old.ALREADYRECEIVEDCANCEL) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'ALREADYRECEIVEDCANCEL', :old.ALREADYRECEIVEDCANCEL, :new.ALREADYRECEIVEDCANCEL, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.ALREADYSENTTOGRANITE <> :old.ALREADYSENTTOGRANITE) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'ALREADYSENTTOGRANITE', :old.ALREADYSENTTOGRANITE, :new.ALREADYSENTTOGRANITE, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.PROVISIONINGFLAG <> :old.PROVISIONINGFLAG) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'PROVISIONINGFLAG', :old.PROVISIONINGFLAG, :new.PROVISIONINGFLAG, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.ISCANCEL <> :old.ISCANCEL) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'ISCANCEL', :old.ISCANCEL, :new.ISCANCEL, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.COMPLETIONDATE <> :old.COMPLETIONDATE) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'COMPLETIONDATE', :old.COMPLETIONDATE, :new.COMPLETIONDATE, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.WORKORDERNUMBER <> :old.WORKORDERNUMBER) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'WORKORDERNUMBER', :old.WORKORDERNUMBER, :new.WORKORDERNUMBER, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.SERVICENUMBER <> :old.SERVICENUMBER) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'SERVICENUMBER', :old.SERVICENUMBER, :new.SERVICENUMBER, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.LINEITEMSTATUS <> :old.LINEITEMSTATUS) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'LINEITEMSTATUS', :old.LINEITEMSTATUS, :new.LINEITEMSTATUS, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
    if(:new.LINEITEMIDENTIFIER <> :old.LINEITEMIDENTIFIER) then
      insert into STC_DATA_AUDIT(cworderid, cwdocid, object, fieldName, oldValue, newValue, username, sourceUsername, sourceHostname)
          values (:old.cworderid, :old.cwdocid, 'STC_LINEITEM', 'LINEITEMIDENTIFIER', :old.LINEITEMIDENTIFIER, :new.LINEITEMIDENTIFIER, user, sys_context('userenv','os_user'), sys_context('userenv','host'));
    end if;
  end if;
end;
/