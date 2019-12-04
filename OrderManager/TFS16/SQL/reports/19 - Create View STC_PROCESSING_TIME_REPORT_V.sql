create or replace view stc_processing_time_report_v as
select t.cwdocid,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       t.operation_name,
       t.performed_task_name,
       t.assign_to_user_date operation_assign_date,
       t.completion_date operation_completion_date,
       round((t.completion_date-t.assign_to_user_date)*24, 2) operation_duration_in_hours,
       round((t.completion_date-t.assign_to_user_date), 2) operation_duration_in_days,
       t.user_id operation_username,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = t.user_id
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) operation_department
  from tfs.stc_tracking t, tfs.stc_tfr tfr
 where tfr.tfr_id = t.object_id
   and tfr.cworderid = t.order_id;