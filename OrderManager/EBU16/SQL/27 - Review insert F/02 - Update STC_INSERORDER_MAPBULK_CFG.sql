declare

  positionInTable  stc_insertorder_mapbulk_cfg.position%type;
  fieldName        stc_insertorder_mapbulk_cfg.columnName%type;
  
begin
 
  fieldName := 'serviceDate';

  select position
    into positionInTable
    from stc_insertorder_mapbulk_cfg
   where columnName = fieldName;
   
  delete from stc_insertorder_mapbulk_cfg where columnName = fieldName;
  
  update stc_insertorder_mapbulk_cfg
     set position = position - 1
   where position >= positionInTable;

  fieldName := 'reasonCodeForInsertOrder';

  select position
    into positionInTable
    from stc_insertorder_mapbulk_cfg
   where columnName = fieldName;
   
  delete from stc_insertorder_mapbulk_cfg where columnName = fieldName;
  
  update stc_insertorder_mapbulk_cfg
     set position = position - 1
   where position >= positionInTable;

   
  update stc_insertorder_mapbulk_cfg
     set columnName = 'serviceTypeReference'
   where columnName = 'circuitTypeReferenceInGranite';

  update stc_insertorder_mapbulk_cfg
     set columnName = 'circuitBWReference'
   where columnName = 'circuitBWReferenceInGranite';   

  update stc_insertorder_mapbulk_cfg
     set columnName = 'siteAReference'
   where columnName = 'siteAReferenceInGranite';      

  update stc_insertorder_mapbulk_cfg
     set columnName = 'siteZReference'
   where columnName = 'siteZReferenceInGranite';   

end;
/

commit;
