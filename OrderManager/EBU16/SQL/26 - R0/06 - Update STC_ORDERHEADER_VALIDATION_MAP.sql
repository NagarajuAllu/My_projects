update STC_ORDERHEADER_VALIDATION_MAP set accountNumber = 0 where orderType = 'F';
update STC_ORDERHEADER_VALIDATION_MAP set serviceDate = 0 where orderType = 'F';

commit;
