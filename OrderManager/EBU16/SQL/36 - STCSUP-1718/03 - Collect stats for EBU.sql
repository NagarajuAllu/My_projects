set serveroutput on

declare
  cursor graniteMsg is
    select msgid, operation, send_time, receive_time, user_data1, user_data2,
           snt_msg, rcv_msg,
           decode(operation, 'ifExpediter_ws:ifExpedtier/operation_SubmitOrder', 'Y', 'N') is_submit
      from full_cwmessagelog_view
     where operation in (
        'ifExpediter_ws:ifExpedtier/operation_SubmitOrder',
        'ifExpediter_ws:ifExpedtier/operation_UpdateOrder'
        )
       and creation_time >= to_date('01/01/2019', 'dd/mm/yyyy')
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
  tmp              varchar2(1);

  step             number(2);

begin
  dbms_output.enable(NULL);
  
--   dbms_output.put_line('MsgId|When Received|CRM Order Number|CRM OrderType|PLI ServiceType|WO Number|Is Submit|Result|Error Code|Error Description');

  execute immediate ('truncate table ebu_stats');
  
  for m in graniteMsg loop
    begin
      status         := NULL;
      errorCode      := NULL;
      errorDescr     := NULL;
      whenOccurred   := to_char(m.send_time, 'yyyy/mm/dd hh24:mi:ss');
      whenOccurredTS := m.send_time;
      
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
          select rcv_msg, user_data2
            into graniteResponse, woNumber
            from full_cwmessagelog_view
           where user_data1 = m.user_data1
             and operation in ('ifGranite_jms:XngServicesSubmitOrderResult/SubmitOrderResult', 'ifGranite_jms:XngServicesUpdateOrderResult/UpdateOrderResult')
             and receive_time = (select min(receive_time)
                                   from full_cwmessagelog_view
                                  where receive_time > m.receive_time
                                    and operation in ('ifGranite_jms:XngServicesSubmitOrderResult/SubmitOrderResult', 'ifGranite_jms:XngServicesUpdateOrderResult/UpdateOrderResult')
                                    and user_data1 = m.user_data1);

          step := 7;

          positionStart := instr(graniteResponse, '<status>');
          positionEnd   := instr(graniteResponse, '</status>');
          if(positionStart > 0 and positionEnd > 0) then
            status := substr(graniteResponse, positionStart + 8, positionEnd - (positionStart +  8));
          end if;

          step := 8;

          positionStart := instr(graniteResponse, '<errorCode>');
          positionEnd   := instr(graniteResponse, '</errorCode>');
          if(positionStart > 0 and positionEnd > 0) then
            errorCode := substr(graniteResponse, positionStart + 11, positionEnd - (positionStart +  11));
          end if;

          step := 9;

          positionStart := instr(graniteResponse, '<errorDescription>');
          positionEnd   := instr(graniteResponse, '</errorDescription>');
          if(positionStart > 0 and positionEnd > 0) then
            errorDescr := substr(graniteResponse, positionStart + 18, positionEnd - (positionStart +  18));
          end if;

          step := 10;
          
        exception
          when NO_DATA_FOUND then
            dbms_output.put_line('ERROR while processing order '||m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
        end;        
      end if;

      if(errorDescr is not null) then
        step := 13;

        errorDescr := replace(errorDescr, chr(10), ' ');


        step := 14;

        errorDescr := replace(errorDescr, chr(13), '');

        step := 15;
      end if;
        
               
      -- dbms_output.put_line(msg_id||'|'||whenOccurred||'|'||m.usorderType||'|'||serviceType||'|'||woNumber||'|'||m.is_submit||'|'||status||'|'||errorCode||'|'||errorDescr);
      
      insert into ebu_stats (msg_id, when_received, crm_order_number, crm_order_type, pli_service_type, wo_number, is_submit, status, error_code, error_descr)
        values (m.msgId, whenOccurredTS, m.user_data1, orderType, serviceType, woNumber, m.is_submit, status, errorCode, errorDescr);
      
      commit;
    
    exception
      when others then
        dbms_output.put_line(m.msgid||'|'||m.user_data1||'|'||whenOccurred||'|'||step||': '||sqlerrm);
    end;
  end loop;
end;
/