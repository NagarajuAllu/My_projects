create or replace view stc_bi_report_v as
select bi.bi_id,
       tfr.tfr_number,
       null prn_name,
       bi.creation_date,
       bi.completion_date,
       round((bi.completion_date - bi.creation_date)*24, 2) bi_duration_hours,
       round((bi.completion_date - bi.creation_date), 2) bi_duration_days
  from tfs.stc_bi bi, tfs.stc_bi_relationship bir, tfs.stc_tfr tfr
 where bi.bi_id = bir.bi_id
   and bir.source_tfr_id = tfr.tfr_id
   and bir.source_prn_id = '-1'
union 
select bi.bi_id,
       null tfr_number,
       prn.prn_name,
       bi.creation_date,
       bi.completion_date,
       round((bi.completion_date - bi.creation_date)*24, 2) bi_duration_hours,
       round((bi.completion_date - bi.creation_date), 2) bi_duration_days
  from tfs.stc_bi bi, tfs.stc_bi_relationship bir, tfs.stc_prn prn
 where bi.bi_id = bir.bi_id
   and bir.source_prn_id = prn.prn_id
   and bir.source_tfr_id = '-1';