set serveroutput on

declare
  cursor graniteMsg is
    select msgid, operation, send_time, receive_time, user_data1, user_data2,
           utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 1))||
           utl_raw.cast_to_varchar2(dbms_lob.substr(send_data, 2000, 2001)) snt_msg,
           utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
           utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg,
           decode(operation, 'wsws:ifExpedtier_WHOLESALE/operation_SubmitOrder', 'Y', 'N') is_submit
      from cwmessagelog
     where operation in (
        'wsws:ifExpedtier_WHOLESALE/operation_SubmitOrder',
        'wsws:ifExpedtier_WHOLESALE/operation_UpdateOrder'
        )
       and creation_time >= to_date('01/01/2018', 'dd/mm/yyyy')
       and user_data1 is not null
     order by creation_time;

  graniteResponse  varchar2(4000);
  status           varchar2(100);
  errorCode        varchar2(300);
  errorDescr       varchar2(4000);
  woNumber         varchar2(100);
  orderType        varchar2(100);
  serviceType      varchar2(100);
  
  positionStart    number;
  positionEnd      number;
  whenOccurred     varchar2(20);
  whenOccurredTS   timestamp(6);
  provBU           varchar2(1);

  step             number(2);

begin
  dbms_output.enable(NULL);
  
--   dbms_output.put_line('MsgId|When Received|CRM Order Number|CRM OrderType|PLI ServiceType|WO Number|Prov BU|Is Submit|Result|Error Code|Error Description');

  execute immediate ('truncate table wbu_stats');
  
  for m in graniteMsg loop
    begin
      status         := NULL;
      errorCode      := NULL;
      errorDescr     := NULL;
      whenOccurred   := to_char(m.send_time, 'yyyy/mm/dd hh24:mi:ss');
      whenOccurredTS := m.send_time;
      provBU         := NULL;
      
      step := 1;
      
      
      positionStart := instr(m.snt_msg, '<MasterOrderStatus>');
      positionEnd   := instr(m.snt_msg, '</MasterOrderStatus>');
      if(positionStart > 0 and positionEnd > 0) then
        status := substr(m.snt_msg, positionStart + 19, positionEnd - (positionStart +  19));
      end if;

      step := 2;

      positionStart := instr(m.snt_msg, '<ErrorCode>');
      positionEnd   := instr(m.snt_msg, '</ErrorCode>');
      if(positionStart > 0 and positionEnd > 0) then
        errorCode := substr(m.snt_msg, positionStart + 11, positionEnd - (positionStart +  11));
      end if;

      step := 3;

      positionStart := instr(m.snt_msg, '<ErrorDescription>');
      positionEnd   := instr(m.snt_msg, '</ErrorDescription>');
      if(positionStart > 0 and positionEnd > 0) then
        errorDescr := substr(m.snt_msg, positionStart + 18, positionEnd - (positionStart +  18));
      end if;
      
      step := 4;

      positionStart := instr(m.rcv_msg, '<OrderType>');
      positionEnd   := instr(m.rcv_msg, '</OrderType>');
      if(positionStart > 0 and positionEnd > 0) then
        orderType := substr(m.rcv_msg, positionStart + 11, positionEnd - (positionStart +  11));
      end if;
      
      step := 5;

      positionStart := instr(m.rcv_msg, '<ServiceType>');
      positionEnd   := instr(m.rcv_msg, '</ServiceType>');
      if(positionStart > 0 and positionEnd > 0) then
        serviceType := substr(m.rcv_msg, positionStart + 13, positionEnd - (positionStart +  13));
      end if;

      step := 6;
      
      if(errorCode is null) then
        begin
          -- checking if it's managed by CIMW
          begin
            select utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
                   utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg, 
                   user_data2
              into graniteResponse, woNumber
              from cwmessagelog
             where user_data1 = m.user_data1
               and operation in ('grws:XngOrderService/submitOrder', 'grws:XngOrderService/updateOrder', 'grws:XngQuoteService/validateQuote')
               and receive_time = (select min(receive_time)
                                     from cwmessagelog
                                    where receive_time > m.receive_time
                                      and operation in ('grws:XngOrderService/submitOrder', 'grws:XngOrderService/updateOrder', 'grws:XngQuoteService/validateQuote')
                                      and user_data1 = m.user_data1)
               and rownum = 1;
            provBU := 'W';
            step  := 7;
              
            positionStart := instr(graniteResponse, '<java:Status>');
            positionEnd   := instr(graniteResponse, '</java:Status>');
            if(positionStart > 0 and positionEnd > 0) then
              status := substr(graniteResponse, positionStart + 13, positionEnd - (positionStart +  13));
            end if;

            step := 8;

            positionStart := instr(graniteResponse, '<java:ErrorCode>');
            positionEnd   := instr(graniteResponse, '</java:ErrorCode>');
            if(positionStart > 0 and positionEnd > 0) then
              errorCode := substr(graniteResponse, positionStart + 16, positionEnd - (positionStart +  16));
            end if;

            step := 9;

            positionStart := instr(graniteResponse, '<java:ErrorDescription>');
            positionEnd   := instr(graniteResponse, '</java:ErrorDescription>');
            if(positionStart > 0 and positionEnd > 0) then
              errorDescr := substr(graniteResponse, positionStart + 23, positionEnd - (positionStart +  23));
            end if;
              
            step := 10;
            
          exception
            when NO_DATA_FOUND then
              -- dbms_output.put_line('No flows found to CIM-W while processing order '||m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
              NULL;
          end;        
          
          if(provBU IS NULL) then
            -- checking if it's managed by CIM-E
            begin
              select utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
                     utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg, 
                     user_data2
                into graniteResponse, woNumber
                from cwmessagelog
               where user_data1 = m.user_data1
                 and operation in ('cimeWS:XngOrderService/submitOrder', 'cimeWS:XngOrderService/updateOrder')
                 and receive_time = (select min(receive_time)
                                       from cwmessagelog
                                      where receive_time > m.receive_time
                                        and operation in ('cimeWS:XngOrderService/submitOrder', 'cimeWS:XngOrderService/updateOrder')
                                        and user_data1 = m.user_data1)
                 and rownum = 1;
              provBU := 'E';
              step  := 17;
                
              positionStart := instr(graniteResponse, '<status>');
              positionEnd   := instr(graniteResponse, '</status>');
              if(positionStart > 0 and positionEnd > 0) then
                status := substr(graniteResponse, positionStart + 8, positionEnd - (positionStart +  8));
              end if;

              step := 18;

              positionStart := instr(graniteResponse, '<errorCode>');
              positionEnd   := instr(graniteResponse, '</errorCode>');
              if(positionStart > 0 and positionEnd > 0) then
                errorCode := substr(graniteResponse, positionStart + 11, positionEnd - (positionStart +  11));
              end if;

              step := 19;

              positionStart := instr(graniteResponse, '<errorDescription>');
              positionEnd   := instr(graniteResponse, '</errorDescription>');
              if(positionStart > 0 and positionEnd > 0) then
                errorDescr := substr(graniteResponse, positionStart + 18, positionEnd - (positionStart +  18));
              end if;
                
              step := 20;
              
            exception
              when NO_DATA_FOUND then
                -- dbms_output.put_line('No flows found to CIM-W while processing order '||m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
                NULL;
            end;        
          end if;
          
          if(provBU IS NULL) then
            -- checking if it's managed by CIM-H
            begin
              select utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
                     utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg, 
                     user_data2
                into graniteResponse, woNumber
                from cwmessagelog
               where user_data1 = m.user_data1
                 and operation in ('cimhJMS:XngServicesSubmitOrderResult/SubmitOrderResult', 'cimhJMS:XngServicesUpdateOrderResult/UpdateOrderResult')
                 and receive_time = (select min(receive_time)
                                       from cwmessagelog
                                      where receive_time > m.receive_time
                                        and operation in ('cimhJMS:XngServicesSubmitOrderResult/SubmitOrderResult', 'cimhJMS:XngServicesUpdateOrderResult/UpdateOrderResult')
                                        and user_data1 = m.user_data1);
              provBU := 'H';
              step  := 27;
                
              positionStart := instr(graniteResponse, '<status>');
              positionEnd   := instr(graniteResponse, '</status>');
              if(positionStart > 0 and positionEnd > 0) then
                status := substr(graniteResponse, positionStart + 8, positionEnd - (positionStart +  8));
              end if;

              step := 28;

              positionStart := instr(graniteResponse, '<errorCode>');
              positionEnd   := instr(graniteResponse, '</errorCode>');
              if(positionStart > 0 and positionEnd > 0) then
                errorCode := substr(graniteResponse, positionStart + 11, positionEnd - (positionStart +  11));
              end if;

              step := 29;

              positionStart := instr(graniteResponse, '<errorDescription>');
              positionEnd   := instr(graniteResponse, '</errorDescription>');
              if(positionStart > 0 and positionEnd > 0) then
                errorDescr := substr(graniteResponse, positionStart + 18, positionEnd - (positionStart +  18));
              end if;
                
              step := 30;
              
            exception
              when NO_DATA_FOUND then
                -- dbms_output.put_line('No flows found to CIM-H while processing order '||m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
                NULL;
            end;        
          end if;

          if(provBU IS NULL) then
            -- checking if it's managed by MOBILE
            begin
              select utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 1))||
                     utl_raw.cast_to_varchar2(dbms_lob.substr(receive_data, 2000, 2001)) rcv_msg, 
                     user_data2
                into graniteResponse, woNumber
                from cwmessagelog
               where user_data1 = m.user_data1
                 and operation in ('nsmValidateInventoryWS:validateInventoryIF/validateInventory', 'pnaSubmitPnAOrderWS:submitPnAOrderIF/submitPnAOrder')
                 and receive_time = (select min(receive_time)
                                       from cwmessagelog
                                      where receive_time > m.receive_time
                                        and operation in ('nsmValidateInventoryWS:validateInventoryIF/validateInventory', 'pnaSubmitPnAOrderWS:submitPnAOrderIF/submitPnAOrder')
                                        and user_data1 = m.user_data1);
              provBU := 'M';
              step  := 37;
                
              positionStart := instr(graniteResponse, '<result>');
              positionEnd   := instr(graniteResponse, '</result>');
              if(positionStart > 0 and positionEnd > 0) then
                status := substr(graniteResponse, positionStart + 8, positionEnd - (positionStart +  8));
              end if;

              step := 38;

              positionStart := instr(graniteResponse, '<errorCode>');
              positionEnd   := instr(graniteResponse, '</errorCode>');
              if(positionStart > 0 and positionEnd > 0) then
                errorCode := substr(graniteResponse, positionStart + 11, positionEnd - (positionStart +  11));
              end if;

              step := 39;

              positionStart := instr(graniteResponse, '<errorDescription>');
              positionEnd   := instr(graniteResponse, '</errorDescription>');
              if(positionStart > 0 and positionEnd > 0) then
                errorDescr := substr(graniteResponse, positionStart + 18, positionEnd - (positionStart +  18));
              end if;
                
              step := 40;
              
            exception
              when NO_DATA_FOUND then
                dbms_output.put_line('No flows found to provisioning systems while processing order '||m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
            end;        
          end if;
        end;
      end if;

      if(errorDescr is not null) then
        step := 13;

        errorDescr := replace(errorDescr, chr(10), ' ');


        step := 14;

        errorDescr := replace(errorDescr, chr(13), '');

        step := 15;
      end if;
        
               
      -- dbms_output.put_line(msg_id||'|'||whenOccurred||'|'||m.usorderType||'|'||serviceType||'|'||woNumber||'|'||provBU||'|'||m.is_submit||'|'||status||'|'||errorCode||'|'||errorDescr);
      
      insert into wbu_stats (msg_id, when_received, crm_order_number, crm_order_type, pli_service_type, wo_number, prov_bu, is_submit, status, error_code, error_descr)
        values (m.msgId, whenOccurredTS, m.user_data1, orderType, serviceType, woNumber, provBU, m.is_submit, status, errorCode, errorDescr);
      
      commit;
    
    exception
      when others then
        dbms_output.put_line(m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
    end;
  end loop;
end;
/