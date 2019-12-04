create or replace procedure stc_del_all_compl_orders(creation_year varchar2) as

  cursor parent_orders is
    select p.ordernumber
      from stc_order_message_home p
     where p.parentordernumber is null
       and nvl(p.orderdomain, 'X') <> 'IWBU'
       and to_char(p.cwordercreationdate, 'yyyy') = creation_year
       and (trunc(p.cwordercreationdate) + 1) < trunc(sysdate);
       
  cursor child_orders is
    select c.ordernumber
      from stc_order_message_home c
     where c.parentordernumber is not null
       and c.parentordernumber not in (select p.ordernumber from stc_order_message_home p where p.parentordernumber is null)
       and nvl(c.orderdomain, 'X') <> 'IWBU'
       and to_char(c.cwordercreationdate, 'yyyy') = creation_year
       and (trunc(c.cwordercreationdate) + 1) <> trunc(sysdate);

  errorMsg VARCHAR2(1000);

begin

  for o in parent_orders loop
    begin
      delete_parent_order_structure.deleteParentAndChildOrders(o.ordernumber);

      insert into stc_delete_all_orders_log(when, ordernumber, result_del, error_msg) values (sysdate, o.ordernumber, 'OK', null);
    exception
      when others then
        errorMsg := substr(sqlerrm, 1, 1000);
        insert into stc_delete_all_orders_log(when, ordernumber, result_del, error_msg) values (sysdate, o.ordernumber, 'KO', errorMsg);
    end;

    commit;
  end loop;

  for o in child_orders loop
    begin
      delete_parent_order_structure.deleteParentAndChildOrders(o.ordernumber);

      insert into stc_delete_all_orders_log(when, ordernumber, result_del, error_msg) values (sysdate, o.ordernumber, 'OK', null);
    exception
      when others then
        errorMsg := substr(sqlerrm, 1, 1000);
        insert into stc_delete_all_orders_log(when, ordernumber, result_del, error_msg) values (sysdate, o.ordernumber, 'KO', errorMsg);
    end;

    commit;
  end loop;
end;
/