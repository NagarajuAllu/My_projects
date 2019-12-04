set serveroutput on;

declare 

  cursor c_cworderid is
    select cworderid
      from stc_om_home_sip;


  cursor c_cwdocid(orderid VARCHAR2) is
    select cwdocid
      from stc_sp_home_sip
     where cworderid = orderid;
     
     
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


      for x in c_cwdocid(i.cworderid) loop
        begin
dbms_output.put_line('Processing servicedescription for order '||i.cworderid||', service '||x.cwdocid);

          inserted := 0;
          limit := 50;
          while (inserted = 0) loop
            begin
              insert into stc_sip_workaround_data2(CWORDERID, SERVICEDESCRIPTION, SERVICEDESCRIPTION_ORIG, CWDOCID)
              select i.cworderid,
                     substr(s.servicedescription, 1, limit),
                     s.servicedescription,
                     x.cwdocid
                from stc_sp_home_sip s
               where s.cworderid = i.cworderid
                 and s.cwdocid = x.cwdocid;
           
              inserted := 1;
            exception
              when others then 
                limit := limit - 1;
            end;
          end loop;
        
        end;
      end loop;


    end;
  end loop;

end;
/


UPDATE stc_om_home_sip 
   SET customername = cworderid;
   
UPDATE stc_sp_home_sip 
   SET servicedescription = cwdocid;

