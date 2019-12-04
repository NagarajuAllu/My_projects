/***
  Due to the request from STC to not migrate SIP "pending" orders, restore now provisioningFlag from SKIP to PROVISIONING
  @refer to procedure 19
***/

UPDATE stc_lineItem
   SET provisioningFlag = 'PROVISIONING'
 WHERE provisioningFlag = 'SKIP';
