select x.when_received, x.crm_order_number, x.crm_order_type, x.pli_service_type, x.prov_bu, x.is_submit, x.error_code, x.error_descr 
  from wbu_stats x 
 where error_code is not null
order by x.when_received desc
