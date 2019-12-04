create or replace view stc_fa_pending_sum_report_v as
select tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.creation_date,
       tfr.fa_completion_date,
       tfr.cancelled_date,
       round((nvl(tfr.fa_completion_date, nvl(tfr.cancelled_date, sysdate)) - tfr.creation_date), 2) num_days,
       round(((nvl(tfr.fa_completion_date, nvl(tfr.cancelled_date, sysdate)) - tfr.creation_date)/7), 2) num_weeks,
       round(months_between(nvl(tfr.fa_completion_date, nvl(tfr.cancelled_date, sysdate)), tfr.creation_date), 2) num_months,
       tfr.required
  from tfs.stc_tfr tfr;