DEFINE HEADER_SEPARATOR = ';';
-- Add values to Store and Forward:
--SMR 9837
insert into STC_STOREFORWARD_NVPAIR(NAME) values('MRC');
insert into STC_STOREFORWARD_NVPAIR(NAME) values('NRC');
insert into STC_STOREFORWARD_NVPAIR(NAME) values('Disconnect percentage');

--Added config to STC_NVPAIR_4_GUI_CONFIG, SMR 9837
insert into STC_NVPAIR_4_GUI_CONFIG(NAME, MANDATORY,VALUE_TYPE) values ('MRC', 0, 'Text');
insert into STC_NVPAIR_4_GUI_CONFIG(NAME, MANDATORY,VALUE_TYPE) values ('NRC', 0, 'Text');
insert into STC_NVPAIR_4_GUI_CONFIG(NAME, MANDATORY,VALUE_TYPE) values ('Disconnect percentage', 0, 'Text');

commit;

set serveroutput on;

declare
  count_in_header number(3);
  count_in_table  number(3);
  position        number(9);
begin
  DBMS_OUTPUT.ENABLE(null);
  
  select instr(HEADER,'Disconnect percentage')
    into position
    from STC_INSERTORDER_BULKHEADER_CFG;
    
  if (position < 1) then
    select regexp_count(header, '&HEADER_SEPARATOR', 1, 'i')
      into count_in_header
      from STC_INSERTORDER_BULKHEADER_CFG;
    
    select max(position) 
      into count_in_table
      from STC_INSERTORDER_MAPBULK_CFG;
      
    if(count_in_header <> count_in_table) then
      DBMS_OUTPUT.PUT_LINE('Configuration for Insert Order in Bulk mode is wrong; columns in header = '||(count_in_header + 1)||'; records in map = '||(count_in_table + 1));
    else
      begin    
        --Update config to STC_INSERTORDER_BULKHEADER_CFG, SMR 9837
        update STC_INSERTORDER_BULKHEADER_CFG set HEADER=HEADER||'&HEADER_SEPARATOR'||'MRC'||'&HEADER_SEPARATOR'||'NRC'||'&HEADER_SEPARATOR'||'Disconnect percentage';

        --Update STC_INSERTORDER_MAPBULK_CFG SMR9837
        count_in_table := count_in_table + 1;
        insert into STC_INSERTORDER_MAPBULK_CFG(POSITION, COLUMNNAME) values (count_in_table, 'NV_pair');
        count_in_table := count_in_table + 1;
        insert into STC_INSERTORDER_MAPBULK_CFG(POSITION, COLUMNNAME) values (count_in_table, 'NV_pair');
        count_in_table := count_in_table + 1;
        insert into STC_INSERTORDER_MAPBULK_CFG(POSITION, COLUMNNAME) values (count_in_table, 'NV_pair');
        DBMS_OUTPUT.PUT_LINE('Configuration for Insert Order in Bulk mode done');
      end;
    end if;
  else
    DBMS_OUTPUT.PUT_LINE('Configuration for Insert Order in Bulk mode already done');
  end if;
end;
