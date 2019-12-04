-- if everything is migrated correctly, resultmigration should be equals to 1
select resultmigration, quoteorder, ordertype, count(*) 
  from stcw_migration_result 
group by resultmigration, quoteorder, ordertype
order by quoteorder, ordertype, resultmigration;


-- should return no records
select lineitemidentifier, count(*) 
  from stcw_lineitem 
 where provisioningflag = 'ACTIVE' 
   and cworderid in (select cworderid from stcw_bundleorder_header where ismigrated = 1)
group by lineitemidentifier 
having count(*) > 1;


-- should return no records
select lineitemidentifier, count(*) 
  from stcw_lineitem 
 where provisioningflag = 'PROVISIONING' 
   and cworderid in (select cworderid from stcw_bundleorder_header where ismigrated = 1)
group by lineitemidentifier 
having count(*) > 1;


-- should return no records in case of serviceNumber not null
select serviceNumber, count(distinct lineItemIdentifier) 
  from stcw_lineitem 
 where cworderid in (select cworderid 
                       from stcw_bundleorder_header 
                      where ismigrated = 1 
                        and ordernumber not in ('MTP4', 'MTP5', '1-11706001', '1-11706001_CANC_20160207160539', '1-11706507', '1-11706507_CANC_20160207160021'))
group by serviceNumber
having count(distinct lineItemIdentifier) > 1;
