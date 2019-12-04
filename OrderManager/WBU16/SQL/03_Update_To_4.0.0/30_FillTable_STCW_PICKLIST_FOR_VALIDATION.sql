prompt Importing table STCW_PICKLIST_FOR_VALIDATION...

declare
  currentValue STCW_PICKLIST_FOR_VALIDATION.CWDOCID%type;
  
begin
  
  select max(to_number(cwdocid)) 
    into currentValue
    from STCW_PICKLIST_FOR_VALIDATION;
  
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'feasibilityFor', 'INSTALL');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'feasibilityFor', 'CHANGE');
  
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', '2W');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', '4W');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', '6W');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', 'LC');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', 'MM');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', 'SM');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', 'N/A');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'wires', 'FO');
  
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'nvAction', 'Add');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'nvAction', 'Remove');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'nvAction', 'Modify');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'nvAction', 'No-Change');
  
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'lineItemType', 'Service');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'lineItemType', 'Root');
  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'lineItemType', 'Bundle');

  currentValue := currentValue + 1;
  insert into STCW_PICKLIST_FOR_VALIDATION (CWDOCID, DATATYPENAME, VALUE) values (currentValue, 'changeRequestType', 'OTHERS');

end;
/

commit;

prompt Done.