set serveroutput on

declare

  cursor not_in_sync_orders is
    select h.ordernumber, h.orderstatus, h.cworderid,
           l.lineitemidentifier, l.servicenumber, l.servicetype, l.workordernumber, l.action, l.lineitemstatus, l.lineitemtype, l.issubmit, l.iscancel,
           (select pli.lineitemidentifier from stc_lineitem pli where pli.cworderid = h.cworderid and pli.elementtypeinordertree = 'B') pli_identifier,
           w.wo_name, w.element_name, w.elm_compl_status, w.status, w.actual_compl, v.status_name,
           (select count(*) from cwprocess_not_completed where order_id = h.cworderid and status not in (3,6)) count_processes
      from stc_bundleorder_header h, stc_lineitem l, work_order_inst@rms_prod_db_link w, val_task_status@rms_prod_db_link v
     where l.lineitemstatus in ('FAILED_SUBMIT', 'SUBMIT_FAILED', 'FAILED')
       and h.cworderid = l.cworderid
       and l.workordernumber = w.wo_name
       and l.workordernumber is not null
       and w.status in (7, 8)
       and w.status = v.stat_code
       and l.cworderid in (select cworderid from stc_lineitem where provisioningflag = 'PROVISIONING')
       and l.iscancel = 0
       and l.lineitemtype <> 'Root'
       and l.elementtypeinordertree <> 'B'
       and h.ordernumber not in ('I4480416', 'I4481909', 'I4462763', 'I4527341')  -- these order have the element cancelled in GI even if the cancel flow was not received in EOC
       ;
       
       -- and h.ordernumber in ('C4494804', 'I4478852', 'I4508622', 'I4520594', 'O4520798')
      



  countElementStatus NUMBER(2);
  
begin

  dbms_output.enable(null);
  
  for c in not_in_sync_orders loop
    begin
      
      update stc_lineitem
         set lineitemstatus = 'COMPLETED',
             completionDate = c.actual_compl
       where cworderid = c.cworderid
         and lineitemidentifier = c.lineitemidentifier;
      
      select count(distinct lineitemstatus)
        into countElementStatus
        from stc_lineitem
       where elementtypeinordertree <> 'B'
         and lineitemidentifier <> c.lineitemidentifier
         and lineitemstatus <> 'COMPLETED'
         and cworderid = c.cworderid;
      
      if(countElementStatus > 0) then
        dbms_output.put_line('STRANGE SITUATION FOR Order '||c.ordernumber);
      else 
        begin

          update stc_lineitem
             set provisioningFlag = 'ACTIVE'
           where cworderid = c.cworderid
             and lineitemidentifier = c.pli_identifier;
     
          update stc_lineitem
             set provisioningFlag = 'OLD'
           where provisioningFlag = 'ACTIVE'
             and cworderid <> c.cworderid
             and lineitemidentifier = c.pli_identifier;

          update stc_bundleorder_header
             set orderstatus = 'COMPLETED',
                 completionDate = c.actual_compl
           where cworderid = c.cworderid;

          insert into STC_SYNC_RECORD (wo_name, xml_msg) 
            select c.wo_name, 
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'||
  '<soapenv:Body>'||
    '<ifEAI_WOSU_17122008:receiveWorkOrderStatusUpdate xmlns:ifEAI_WOSU_17122008="receiveWorkOrderStatusUpdate" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||
      '<workOrderStatusUpdateRequest xsi:type="ifEAI_WOSU_17122008:WorkOrderStatusUpdateRequest">'||
        '<header xsi:type="ifEAI_WOSU_17122008:RequestHeader">'||
          '<systemId>Granite</systemId>'||
          '<serverInfo>172.20.214.16</serverInfo>'||
          '<messageId>'||to_char(systimestamp, 'yyyymmddhh24missFF3')||'</messageId>'||
          '<conversationId>'||to_char(systimestamp, 'yyyymmddhh24missFF3')||'</conversationId>'||
          '<timestamp>'||to_char(systimestamp, 'yyyy-mm-dd"T"hh24:mi:ss.FF3')||'</timestamp>'||
          '<domainId>Data</domainId>'||
          '<serviceId>WorkOrderStatusUpdate</serviceId>'||
          '<operationType>Update</operationType>'||
          '<userId>URY_GRANITE</userId>'||
        '</header>'||
        '<body xsi:type="ifEAI_WOSU_17122008:body">'||
          '<crmOrderNumber>'||c.ordernumber||'</crmOrderNumber>'||
          '<crmOrderStatus>COMPLETED</crmOrderStatus>'||
          '<businessUnit>Enterprise</businessUnit>'||
          '<lineItemIdentifier>'||c.lineitemidentifier||'</lineItemIdentifier>'||
          '<lineItemStatus>COMPLETED</lineItemStatus>'||
          '<lineItemType>'||c.lineitemtype||'</lineItemType>'||
          '<remarks/>'||
          '<workOrderName>'||c.workordernumber||'</workOrderName>'||
          '<workOrderStatus>'||c.status_name||'</workOrderStatus>'||
          '<workOrderRemarks/>'||
          '<workOrderServiceCompletionStatus>'||c.elm_compl_status||'</workOrderServiceCompletionStatus>'||
          '<taskNumber>1</taskNumber>'||
          '<taskName>no-value</taskName>'||
          '<taskDescription>Activate the service</taskDescription>'||
          '<taskOperation>ACTIVATE SERVICE</taskOperation>'||
          '<taskPriority>-1</taskPriority>'||
          '<taskServiceStatus>ACTIVE</taskServiceStatus>'||
          '<taskStatusCode>COMPLETED</taskStatusCode>'||
          '<taskRemarks/>'||
        '</body>'||
      '</workOrderStatusUpdateRequest>'||
    '</ifEAI_WOSU_17122008:receiveWorkOrderStatusUpdate>'||
  '</soapenv:Body>'||
'</soapenv:Envelope>'
          from dual;
        
        end;
        
      end if;  
      
    end;
  end loop;
end;
/
