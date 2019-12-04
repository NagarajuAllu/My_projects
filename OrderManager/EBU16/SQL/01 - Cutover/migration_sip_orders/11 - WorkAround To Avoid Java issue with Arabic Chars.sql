-- BEFORE EXECUTING, CHECK THAT THERE IS ONLY 1 SERVICE FOR EACH ORDER

select cworderid, count(*)
  from stc_sp_home_sip
group by cworderid 
having count(*) > 1;

-- 2015-09-08: these are the orders with duplicated records:
9000000000016700  (removed service with cwdocid 9000000000016703);
9000000000016600  (removed service with cwdocid 9000000000016603);
9000000000025900  (removed service with cwdocid 9000000000025903);
-- remove the record with mio

set serveroutput on;

declare 

  cursor c_cworderid is
    select cworderid
      from stc_om_home_sip;

  limit    number;
  inserted number;
begin

dbms_output.enable(null);
  
  for i in c_cworderid loop
    begin  
dbms_output.put_line('Processing customername for order '||i.cworderid);

      limit    := 60;
      inserted := 0;
      while (inserted = 0) loop
        begin
          insert into stc_sip_workaround_data (cworderid, customername, customername_orig)
          select o.cworderid, substr(o.customername, 1, limit), o.customername
            from stc_om_home_sip o
           where o.cworderid = i.cworderid;
           
           inserted := 1;
        exception
          when others then 
            limit := limit - 1;
        end;
      end loop;

dbms_output.put_line('Processing servicedescription for order '||i.cworderid);
      inserted := 0;
      limit := 50;
      while (inserted = 0) loop
        begin
          update stc_sip_workaround_data w
             set w.servicedescription = (select substr(s.servicedescription, 1, limit)
                                           from stc_sp_home_sip s
                                          where s.cworderid = i.cworderid),
                 w.servicedescription_orig = (select s.servicedescription
                                                from stc_sp_home_sip s
                                               where s.cworderid = i.cworderid)
           where w.cworderid = i.cworderid;
           
           inserted := 1;
        exception
          when others then 
            limit := limit - 1;
        end;
      end loop;



    end;
  end loop;

end;
/


UPDATE stc_om_home_sip 
   SET customername = cworderid;
   
UPDATE stc_sp_home_sip 
   SET servicedescription = cworderid;

COMMIT;