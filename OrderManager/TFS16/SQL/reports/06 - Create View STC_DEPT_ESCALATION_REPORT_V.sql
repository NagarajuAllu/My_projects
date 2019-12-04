create or replace view stc_dept_escalation_report_v as
select t.cwdocid,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.customer_name, 
       tfr.requirement_type,
       tfr.creation_date,
       (tfr.required + tfr.existing) total,
       tfr.project,
       t.operation_name,
       t.performed_task_name,
       t.assign_to_user_date,
       t.completion_date,
       round((t.completion_date-t.assign_to_user_date)*24, 2) duration_in_hours,
       round((t.completion_date-t.assign_to_user_date), 2) duration_in_days,
       tfr.current_userid
  from tfs.stc_tracking t, tfs.stc_tfr tfr
 where t.object_type = 'TFR'
   and t.operation_name like 'workflow.facilityDesignTeamIF/%'
   and tfr.tfr_id = t.object_id;
