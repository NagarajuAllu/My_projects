To check possible errors:


select * 
  from stc_migration_log 
 where log_message not in ('DE0030 = No value in mandatory field "icmsSONumber"', 'DE0030 = No value in mandatory field "fictBillingNumber"') and 
       log_message not like 'Validation Errors in order %' and
       log_message not like '% - Processing order%';
       

                       
select count(*), h.orderstatus
  from stc_migration_log l , stc_bundleorder_header h
 where l.log_message like 'Validation Errors in order %'
   and substr(log_message, 28, 16) = h.cworderid
group by h.orderstatus;

COUNT(*)  | ORDERSTATUS
----------+------------------       
    375   | CANCELLED
      3   | IN-PROCESS
      1   | NEW
      7   | ON-HOLD
     39   | READY
   2043   | COMPLETED


select count(*), migratedtobundle from stc_order_message o group by migratedtobundle;

COUNT(*)  | MigratedToBundle
----------+------------------       
  181617	| 1
      98	| 5
      22	| 4
  107806	| 3
       
       
       
       
orderType:            1   -- IDT80124516
action:               1   -- IDT80124516
icmsSONumber:      1087   -- (1041 are COMPLETED)
fictBillingNumber: 2248   -- (1828 are COMPLETED)
wires = FIBER:        3   -- O4175684, O4192124, O4343678; all completed
wires = COAX:         2   -- O4322436  (NEW), O4324518 (COMPLETED)


424 = Orders without icmsSONumber or fictBillingNumber and NOT COMPLETED!

==> 425 orders without STC_ORDER_ORCHESTRATION 