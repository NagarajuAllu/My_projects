UPDATE stc_servicetype_behaviorconfig
   SET send_disconnect_for_cancel = 1
 WHERE serviceType IN ('SIP', 'BSIP', 'SIPMW', 'BSIPMW');

COMMIT;

   