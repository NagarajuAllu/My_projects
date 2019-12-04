--- Start only the ones received after 01/01/2014

-- Disable 1209 orders
update stc_bundleorder_header 
   set ismigrated = 2
 where cworderid in (
       select distinct h.cworderid
         from stc_bundleorder_header h, stc_lineItem b, stc_order_orchestration orc
        where h.ismigrated = 1
          and b.cworderid = h.cworderid
          and b.elementtypeinordertree = 'B'
          and b.provisioningFlag = 'PROVISIONING'
          and orc.cworderid = h.cworderid
          and h.receiveddate < to_date('01/01/2014', 'dd/mm/yyyy'));


--- Start only the ones that have a WO in Granite

-- Disable 37 orders
update stc_bundleorder_header 
   set ismigrated = 3
 where cworderid in (
       select distinct h.cworderid
         from stc_bundleorder_header h, stc_lineItem b, stc_order_orchestration orc
        where h.ismigrated = 1
          and b.cworderid = h.cworderid
          and b.elementtypeinordertree = 'B'
          and b.provisioningFlag = 'PROVISIONING'
          and orc.cworderid = h.cworderid
          and h.ordernumber not in (select woi.wo_name
                                      from rms_prod.work_order_inst@rms_prod_db_link woi));
                                      
commit;