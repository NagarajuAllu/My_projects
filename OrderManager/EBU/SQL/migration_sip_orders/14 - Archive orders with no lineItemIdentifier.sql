/**
 * These records have no LineItemIdentifier, so they are unmanagable; so they are "OLD".
 */
update stc_lineItem 
   set provisioningFlag = 'OLD' 
 where elementTypeInOrderTree = 'B'
   and cworderid in (select cworderid 
                       from stc_lineItem
                      where lineitemidentifier is null)
   and provisioningFlag <> 'OLD';

commit;