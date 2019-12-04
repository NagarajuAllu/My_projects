/**
 * These records have no LineItemIdentifier, so they are unmanagable; so they are "OLD".
 */
update stc_lineItem set provisioningFlag = 'OLD' where lineitemidentifier is null;

commit;