set serveroutput on


declare

  bulkHeader stc_insertorder_bulkheader_cfg.header%type;
  newHeader  stc_insertorder_bulkheader_cfg.header%type;
  
  indexStart number(6);
  indexEnd   number(6);
  fieldName  varchar2(100);
  
begin
  dbms_output.enable(null);
  
  
  select header 
    into bulkHeader
    from stc_insertorder_bulkheader_cfg;
  
  -- REPLACING "Service Date"
  fieldName  := 'Service Date';
  indexStart := instr(bulkHeader, ','||fieldName);
  if(indexStart = 0) then
    indexStart := instr(bulkHeader, fieldName);
  end if;
  
  if(indexStart = 0) then
    -- not found; ignoring
    NULL;
  else 
    begin
      indexEnd := instr(bulkHeader, ',', indexStart+1);
      if(indexEnd = 0) then
        -- no ending comma, so just truncating the string
        newHeader := substr(bulkHeader, 0, indexStart-1);
      else 
        if(indexStart = 1) then
          newHeader := substr(bulkHeader, indexEnd+1);
        else
          newHeader := substr(bulkHeader, 0, indexStart-1) || substr(bulkHeader, indexEnd);
        end if;
        
      end if;
    end;
  end if;
 
  bulkHeader := newHeader;
 
  -- REPLACING "Reason Code"
  fieldName  := 'Reason Code';
  indexStart := instr(bulkHeader, ','||fieldName);
  if(indexStart = 0) then
    indexStart := instr(bulkHeader, fieldName);
  end if;
  
  if(indexStart = 0) then
    -- not found; ignoring
    NULL;
  else 
    begin
      indexEnd := instr(bulkHeader, ',', indexStart+1);
      if(indexEnd = 0) then
        -- no ending comma, so just truncating the string
        newHeader := substr(bulkHeader, 0, indexStart-1);
      else 
        if(indexStart = 1) then
          newHeader := substr(bulkHeader, indexEnd+1);
        else
          newHeader := substr(bulkHeader, 0, indexStart-1) || substr(bulkHeader, indexEnd);
        end if;
        
      end if;
    end;
  end if;
 
  bulkHeader := newHeader;
 
  dbms_output.put_line('NewHeader = '||bulkHeader); 
  
  update stc_insertorder_bulkheader_cfg set header = bulkHeader;
 
end;
/

commit;
