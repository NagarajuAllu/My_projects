create or replace procedure stc_cleanup_completed_orders as

  cursor child_orders is
    select ordernumber, parentordernumber, orderstatus, cworderid
      from stc_order_message_home
     where parentordernumber is not null
       and cwordercreationdate < to_date('01/08/2016', 'dd/mm/yyyy')
       and orderdomain <> 'IWBU'
       and rownum <= 1000;

  cursor child_order_status (parent_order_number varchar2) is
    select orderstatus
      from stc_order_message_home
     where parentordernumber = parent_order_number;

  parentorderstatus stc_order_message_home.orderstatus%type;
  wo_status_name    varchar2(20);
  update_parent     char(1);
  count_current     number(1);
  count_parent      number(1);
  errMsg            varchar2(200);
  errCode           number;
  
begin

  for co in child_orders loop
    begin
      
      select count(*)
        into count_current
        from stc_order_message_home
       where ordernumber = co.ordernumber;
      
      if(count_current = 0) then 
        insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Child order already deleted; skipping');
      else
        
        if(co.orderstatus in ('COMPLETED', 'CANCELLED')) then
          begin
            select orderstatus
              into parentorderstatus
              from stc_order_message_home
             where ordernumber = co.parentordernumber;
  
            if(parentorderstatus in ('COMPLETED', 'CANCELLED')) then
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Deleting parent and child orders #'||co.parentordernumber||'#');
              delete_parent_order_structure.delWithBCKParentAndChildOrders(co.parentordernumber, 'Y');
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Deleted parent and child orders #'||co.parentordernumber||'#');
            else
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Parent '||co.parentordernumber||' is not completed! Check it');
            end if;
          exception
            when no_data_found then
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Parent '||co.parentordernumber||' not found! Cleaning the child only');
              delete_parent_order_structure.deleteOrderStructureFromWD(co.ordernumber, 'Y');
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Parent '||co.parentordernumber||' not found! Cleaned the child only');
          end;
  
        else
          begin
            begin
              select status_name
                into wo_status_name
                from work_order_inst@rms_prod_db_link woi, val_task_status@rms_prod_db_link vts
               where woi.wo_name = co.ordernumber
                 and vts.stat_code = woi.status;
            exception
              when no_data_found then
                insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'WO not found in granite! Forcing deleting order in OM');
                wo_status_name := 'COMPLETED';
            end;
  
            if(wo_status_name in ('COMPLETED', 'CANCELLED')) then
              insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'WO status is '||wo_status_name||'; updating the child order');
  
              -- update the status of the services in the child order
              update stc_service_parameters_home
                 set servicestatus = decode(tobecancelled, 1, 'CANCELLED', 'COMPLETED')
               where cworderid = co.cworderid;
  
              -- update the status of the child order
              update stc_order_message_home
                 set orderstatus = wo_status_name
               where ordernumber = co.ordernumber;
  
              -- checking if parent order exists
              select count(*)
                into count_parent
                from stc_order_message_home
               where ordernumber = co.parentordernumber;
  
              if(count_parent <> 0) then
                -- update in parent order, the status of the services that were updated in the child order
                update stc_service_parameters_home h
                   set h.servicestatus = decode(h.tobecancelled, 1, 'CANCELLED', 'COMPLETED')
                 where cworderid in (select cworderid from stc_order_message_home where ordernumber = co.parentordernumber)
                   and h.orderrowitemid in (select orderrowitemid from stc_service_parameters_home where cworderid = co.cworderid);
  
                update_parent := 'Y';
                for c in child_order_status(co.parentordernumber) loop
                  begin
                    if (c.orderstatus not in ('COMPLETED', 'CANCELLED')) then
                      update_parent := 'N';
                    end if;
                  end;
                end loop;
  
                if(update_parent = 'Y') then
                  insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'WO status is '||wo_status_name||'; updating the parent order '|| co.parentordernumber);
                  update stc_order_message_home
                     set orderstatus = wo_status_name
                   where ordernumber = co.parentordernumber;
  
                  insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Deleting parent and child orders #'||co.parentordernumber||'#');
                  delete_parent_order_structure.delWithBCKParentAndChildOrders(co.parentordernumber, 'Y');
                  insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Deleted parent and child orders #'||co.parentordernumber||'#');
  
                else
                  insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'NOT updating the parent order '|| co.parentordernumber);
                end if;
  
              else
                insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Parent '||co.parentordernumber||' not found! Cleaning the child only');
                delete_parent_order_structure.deleteOrderStructureFromWD(co.ordernumber, 'Y');
                insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Parent '||co.parentordernumber||' not found! Cleaned the child only');
              end if;
            else
              -- it means that the WO in granite is not COMPLETED or CANCELLED; do nothing
              NULL;
            end if;
          end;
        end if;
      end if;
  
    exception
      when others then
        errCode := sqlcode;
        errMsg  := substr(sqlerrm, 1, 200);
        
        if(errCode between -20104 and -20101) then
          insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Validation error while deleting the order: '||errMsg);
        else
          insert into stc_cleanup_completed_log (sequence, ordernumber, message) values (cleanup_completed_seq.nextval, co.ordernumber, 'Unexpected error:'||errMsg);
        end if;
    end;
  end loop;
end;
/