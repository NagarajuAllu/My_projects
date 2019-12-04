create or replace view mops_order_type as 
select order_type,
       nvl(listagg(decode(service_type, 'FTTH_HSI', operation_type,
                                        ''),
                          '') within group (order by seq_num), '-') hsi_op_type,
       nvl(listagg(decode(service_type, 'FTTH_VOIP', operation_type,
                                        ''),
                          '') within group (order by seq_num), '-') voip_op_type,
       nvl(listagg(decode(service_type, 'FTTH_IPTV', operation_type,
                                        ''),
                          '') within group (order by seq_num), '-') iptv_op_type
  from cim.mops_opn_config@rms_prod_db_link
group by order_type;