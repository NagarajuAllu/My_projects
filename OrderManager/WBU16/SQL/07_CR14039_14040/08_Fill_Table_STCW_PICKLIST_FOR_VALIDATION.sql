declare
  maxDocId stcw_picklist_for_validation.cwdocid%type;
begin
  select max(to_number(cwdocid)) + 1 
    into maxDocId
    from stcw_picklist_for_validation;
    
  insert into stcw_picklist_for_validation(cwdocid, datatypename, value) values (maxDocId, 'lineItemType', 'BoS');
  commit;
end;
/

