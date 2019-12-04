-- disable orders without any service
update stc_om_home_sip o
   set o.migratedtobundle = 2
 where cworderid not in (select cworderid 
                           from stc_sp_home_sip);
                           
/****

 disable duplicated parent orders

****/
-- to find
select count(*), parentordernumber 
  from stc_om_home_sip
group by parentordernumber 
having count(*) > 1;

-- 2015-09-09: 
-- 04309223  2  ==> C90893720  & C90963117: both exist and completed in Granite. disable C90893720


update stc_om_home_sip o
   set o.migratedtobundle = 3
 where ordernumber = 'C90893720';
 
 
-- 2015-09-09: there are orders without circuitnumber
-- 03517047
-- 04453685
-- 04490237
-- 02067809
update stc_om_home_sip o
   set o.migratedtobundle = 4
 where circuitnumber is null;
  


