create or replace view stc_bi_productivity_report_v as
select t.cwdocid,
       t.completion_date track_completion_date,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.ni_number,
       tsk.tfr_task_id,
       tsk.task_name,
       bi.bi_id,
       bi.creation_date bi_creation_date,
       bi.completion_date bi_completion_date,
       t.user_id
  from tfs.stc_tracking t, tfs.stc_tfr tfr, tfs.stc_tfr_task tsk, tfs.stc_bi bi, tfs.stc_bi_relationship bir
 where t.object_id = tsk.tfr_task_id
   and tsk.tfr_id = tfr.tfr_id
   and bir.source_tfr_id = tfr.tfr_id
   and bir.source_prn_id = '-1'
   and bi.bi_id = bir.bi_id;