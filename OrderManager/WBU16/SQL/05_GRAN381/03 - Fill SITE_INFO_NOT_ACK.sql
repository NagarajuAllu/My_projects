set serveroutput on


declare
  siu_msg        long;
  siu_msg_string varchar2(2000);
  plate_id       varchar2(50);
  startIndex     number(4);
  endIndex       number(4);
  counter        number(10);
  record_found   number(2);

  cursor siu is
    select s.processid process_id, s.siteid
      from cwprocess_not_completed p, cwmdtypes t, stcw_siteinfoupdate_data s
     where p.PROCESS_METADATYPE = t.typeid
       and t.typename = 'stcw.siteInformationUpdate'
       and p.STATUS not in (3, 6)
       and p.STARTTIME < trunc(sysdate)
       and s.processid = p.PROCESS_ID;

begin
dbms_output.enable(NULL);
  counter := 0;
  
  for s in siu loop
    begin
      counter      := counter+1;
      record_found := 0;
      
      select receivedmsg
        into siu_msg
        from stcw_received_msg
       where processid = s.process_id
         and activityname = 'GRANITE_REQUEST';
      
      siu_msg_string := substr(siu_msg, 1, 2000);
      startIndex     := instr(siu_msg_string, '<ccliCode>');
      endIndex       := instr(siu_msg_string, '</ccliCode>');
      
      plate_id        := substr(siu_msg, startIndex + 10, endIndex - (startIndex + 10));
      
dbms_output.put_line('Inserting in report.site_info_not_ack values <'||s.siteid||','||plate_id||'>');

      select count(*) 
        into record_found
        from report.site_info_not_ack@rms_prod_db_link
       where siteid = s.siteid
         and plateid = plate_id;
      
      if(record_found = 0) then
        insert into report.site_info_not_ack@rms_prod_db_link(cwdocid, siteid, plateid, evt_date, bu) 
        values (counter, s.siteid, plate_id, sysdate, 'WBU');
      end if;
      
    end;
  end loop;
end;
/