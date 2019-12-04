insert into STCW_PICKLIST_FOR_VALIDATION(CWDOCID, DATATYPENAME, VALUE)
  select max(to_number(CWDOCID) + 1) , 'lineItemType', 'Device'
    from STCW_PICKLIST_FOR_VALIDATION;
