create or replace view stc_participant_for_stale as
select pa.consumer_id
  from cwpparticipant pa, cwprocess_not_completed p, stc_bundleorder_header h
 where pa.consumer_id = p.process_id
   and pa.CREATION_DATE < (sysdate - 1/(24*60)) -- 1 minute
   and p.status = 8
   and h.cworderid = p.order_id
   AND h.ordernumber not like '%_CANC_201%'
   AND h.ordernumber not like '%_REVI_201%'
   and operation in ('processSTC.notifyProvisioningIsCompleted', 'processSTC.wakeUpParentInOrchestration')
;
