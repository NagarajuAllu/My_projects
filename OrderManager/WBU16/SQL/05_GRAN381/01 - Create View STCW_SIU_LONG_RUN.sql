create or replace view stcw_siu_long_run (process_id) as 
select process_id
  from cwprocess_not_completed p, cwmdtypes t
 where p.process_metadatype = t.typeid
   and t.typename = 'stcw.siteInformationUpdate'
   and p.status = 1
   and p.creation_date < trunc(sysdate - 7);