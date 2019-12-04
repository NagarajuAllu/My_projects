UPDATE stc_lineitem 
   SET provisioningFlag = NULL 
 WHERE cworderid IN (SELECT cworderid 
                       FROM stc_bundleorder_header 
                      WHERE orderNumber = 'I4482586') 
   AND elementTypeInOrderTree = 'C';

UPDATE stc_order_orchestration x
   SET lineItemIdentifier = (SELECT lineItemIdentifier 
                               FROM stc_lineitem l
                              WHERE l.cwdocid = x.cwdocid)
 WHERE elementTypeInOrchestration IN ('B', 'C', 'S')
   AND cworderid IN (SELECT cworderid 
                       FROM stc_bundleorder_header 
                      WHERE orderNumber = 'I4482586');