--- Start only the ones that have a WO in Granite

-- 2017-07-10: disabled 0 orders
update stcw_bundleorder_header 
   set ismigrated = 3
 where cworderid in (
       select distinct h.cworderid
         from stcw_bundleorder_header h, stcw_lineItem b, stcw_order_orchestration orc
        where h.ismigrated = 1
          and b.cworderid = h.cworderid
          and b.elementtypeinordertree = 'B'
          and b.provisioningFlag = 'PROVISIONING'
          and orc.cworderid = h.cworderid
          and b.workordernumber not in (select woi.wo_name
                                        from rms_prod.work_order_inst@rms_prod_db_link woi));
                                      
commit;