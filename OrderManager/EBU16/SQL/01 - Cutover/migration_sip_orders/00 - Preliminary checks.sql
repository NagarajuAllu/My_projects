-- To check if there are child orders with multiple services
select count(*), cworderid 
  from cwh.stc_service_parameters_home 
 where cworderid in (select cworderid 
                       from cwh.stc_order_message_home 
                      where ccttype = 'SIP' 
                        and parentordernumber is not null)
group by cworderid
having count(*) > 1;

-- 2015-07-09: situation is the following one:

  COUNT(*) CWORDERID
---------- -------------
         3 2587149768     ==> Services: FTTH_VOIP, FTTH_HSI, DID_SIP; but in Granite only FTTH_VOIP, FTTH_HSI                         <<-- exclude it
         4 2628129418     ==> Services: FTTH_VOIP, FTTH_IPTV, FTTH_HSI, DID_SIP; but in Granite only FTTH_VOIP, FTTH_IPTV, FTTH_HSI   <<-- exclude it


select count(*), cworderid 
  from cwh.stc_serv_params_home_archive 
 where cworderid in (select cworderid 
                       from cwh.stc_order_message_home_archive 
                      where ccttype = 'SIP' 
                        and parentordernumber is not null)
group by cworderid
having count(*) > 1;

-- 2015-07-09: no records found



-- To check if there are more and different child orders that refer to the same parentOrder
select parentordernumber, count(*)
  from cwh.stc_order_message_home
 where parentordernumber is not null
   and ccttype = 'SIP'
group by parentordernumber
having count(*) > 1;


-- 2015-07-06: here is the situation found:

                                             Child Order #1             Child Order #1      
PARENTORDERNUMBER       COUNT(*)          OrderNumber CWOrderId      OrderNumber CWOrderId  
--------------------- ----------          ----------- -----------    ----------- -----------
00012820                       2      ==> I91839256  (6341073025)    I91881242   (6349858062)  <<-- exclude the first from migration
03334899                       2      ==> T91559133  (3071797277)    T91655984   (4795262506)  <<-- rename the parentOrderNumber of the first to _OLD
03034686                       2      ==> O91838950  (6341002089)    O91879701   (6349540272)  <<-- exclude the first from migration
01872287                       2      ==> I91896387  (6352945553)    I91892767   (6352215729)  <<-- exclude the second from migration
02807229                       2      ==> O91838949  (6341001904)    O91879700   (6349540178)  <<-- exclude the first from migration
03291851                       2      ==> I91844972  (6342255831)    I91839230   (6341069862)  <<-- exclude the second from migration
02645092                       2      ==> T91839069  (6341042953)    I91883691   (6350303076)  <<-- exclude the first from migration
06435788                       2      ==> I91559838  (3271058564)    I91577518   (3260501503)  <<-- rename the parentOrderNumber of the first to _OLD
05290544                       2      ==> C91990849  (6396333207)    C91867897   (6347137658)  <<-- exclude the second from migration



---- USED QUERY
select ordernumber, cworderid, wo_name, attr_value parentOrderNumber, woi.status
  from stc_order_message_home, rms_prod.work_order_inst@rms_prod_db_link woi, workorder_attr_settings@rms_prod_db_link woas
 where parentordernumber = '03334899'
   and woas.val_attr_inst_id (+) = 4339
   and ordernumber = wo_name (+)
   and woi.wo_inst_id = woas.workorder_inst_id (+)
