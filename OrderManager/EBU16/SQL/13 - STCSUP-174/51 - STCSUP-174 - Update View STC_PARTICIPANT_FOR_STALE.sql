CREATE OR REPLACE VIEW STC_PARTICIPANT_FOR_STALE AS
SELECT p.PROCESS_ID
  FROM cwprocess_not_completed p, stc_bundleorder_header h
 WHERE p.status in (1, 8)
   and h.cworderid = p.order_id
   AND h.ordernumber NOT LIKE '%_CANC_201%'
   AND h.ordernumber NOT LIKE '%_REVI_201%'
   AND p.process_id IN (SELECT pa.consumer_id
                          FROM cwpparticipant pa
                         WHERE pa.CREATION_DATE < (sysdate - 10/(24*60)) -- 10 minutes
                           AND pa.disable <> 10
                           AND pa.operation IN ('processSTC.notifyProvisioningIsCompleted', 'processSTC.wakeUpParentInOrchestration', 'ifGranite_jms.XngServicesNotificationToProcesses/WorkOrderStatusUpdate'));
