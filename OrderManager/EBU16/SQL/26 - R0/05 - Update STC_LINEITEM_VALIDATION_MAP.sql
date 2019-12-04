update STC_LINEITEM_VALIDATION_MAP set fictBillingNumber = 1 where orderType <> 'F';
update STC_LINEITEM_VALIDATION_MAP set fictBillingNumber = 0 where orderType = 'F';

update STC_LINEITEM_VALIDATION_MAP set accountNumber = 0 where orderType = 'F';
update STC_LINEITEM_VALIDATION_MAP set serviceDate = 0 where orderType = 'F';

update STC_LINEITEM_VALIDMAP_NOCHG set fictBillingNumber = 0 where orderType = 'T';

commit;
