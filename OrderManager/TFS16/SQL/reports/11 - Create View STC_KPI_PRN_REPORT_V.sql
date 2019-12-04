create or replace view stc_kpi_prn_report_v as
select prnr.customer_name,
       prnr.prnr_id,
       prnr.prnr_name,
       prnr.creation_date prnr_creation_date,
       prnr.released_date prnr_released_date,
       prnr.cancelled_date prnr_cancelled_date,
       round((nvl(prnr.released_date, prnr.cancelled_date) - prnr.creation_date)*24, 2) prnr_duration_hours,
       round((nvl(prnr.released_date, prnr.cancelled_date) - prnr.creation_date), 2) prnr_duration_days,
       prn.prn_id,
       prn.prn_name,
       prn.creation_date prn_creation_date,
       prn.released_date prn_released_date,
       prn.cancelled_date prn_cancelled_date,
       round((nvl(prn.released_date, prn.cancelled_date) - prn.creation_date)*24, 2) prn_duration_hours,
       round((nvl(prn.released_date, prn.cancelled_date) - prn.creation_date), 2) prn_duration_days,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.fa_completion_date,
       tfr.cancelled_date tfr_cancelled_date,
       round((nvl(tfr.fa_completion_date, tfr.cancelled_date) - tfr.creation_date)*24, 2) tfr_duration_hours,
       round((nvl(tfr.fa_completion_date, tfr.cancelled_date) - tfr.creation_date), 2) tfr_duration_days,
       (select max(t.completion_date-prnr.creation_date)
          from tfs.stc_tracking t
         where t.operation_name = 'workflow.orderInitiatorTeamIF/prepareToSubmitPRNR'
           and t.order_id = prn.cworderid) orderInitiator_duration_days,
       (select max(t.completion_date)-min(t.assign_to_user_date)
          from tfs.stc_tracking t
         where t.operation_name like 'workflow.networkDesignTeamIF/%'
           and t.order_id = prn.cworderid) networkDesign_duration_days,
       (select max(t.completion_date)-min(t.assign_to_user_date)
          from tfs.stc_tracking t
         where t.operation_name not like 'workflow.networkDesignTeamIF/%'
           and t.operation_name not like 'workflow.orderInitiatorTeamIF/%'
           and t.order_id = prn.cworderid) faTeams_duration_days,
       (select max(t.completion_date)-min(t.assign_to_user_date)
          from tfs.stc_tracking t
         where t.operation_name = 'workflow.orderInitiatorTeamIF/reviewCWOReport'
           and t.order_id = prn.cworderid) cust_acceptance_duration_days,
       (select max(t.completion_date)-prnr.creation_date
          from tfs.stc_tracking t
         where t.operation_name = 'workflow.orderInitiatorTeamIF/reviewCWOReport'
           and t.performed_task_name = 'Accept CWO Report'
           and t.order_id = prn.cworderid) end2end_duration_days
  from tfs.stc_prn prn, tfs.stc_prnr prnr, tfs.stc_tfr tfr
 where prn.prnr_id = prnr.prnr_id
   and tfr.prn_id (+) = prn.prn_id
   and (prn.released_date is not null or prn.cancelled_date is not null);