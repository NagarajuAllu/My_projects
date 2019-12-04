update stc_lineitem l
   set l.feasibilityType = 'DESIGN'
 where l.cworderid in (select o.cworderid 
                         from stc_bundleorder_header o
                        where o.reservation = 'Y'
                          and o.orderType = 'F');

update stc_lineitem l
   set l.feasibilityType = 'ENQUIRY'
 where l.cworderid in (select o.cworderid 
                         from stc_bundleorder_header o
                        where o.reservation = 'N'
                          and o.orderType = 'F');

declare 
  cursor oh_f is
    select cworderid, reservationNumber
      from stc_bundleorder_header o
     where o.orderType = 'F';
begin
  for c in oh_f loop
    begin
      update stc_lineitem l
         set l.reservationNumber = c.reservationNumber
       where l.cworderid = c.cworderid;
    end;
  end loop;
end;
/

commit;
