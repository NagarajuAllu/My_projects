create or replace view stc_dept_productivity_report_v as
select t.user_id,
       ur.roleid,
       t.cwdocid,
       t.operation_name,
       t.performed_task_name,
       t.assign_to_user_date,
       t.completion_date,
       round((t.completion_date-t.assign_to_user_date)*24, 2) duration_in_hours,
       round((t.completion_date-t.assign_to_user_date), 2) duration_in_days,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.project,
       tfr.requirement_type,
       tfr.required,
       tfr.current_userid current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = tfr.current_userid
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department
  from tfs.stc_tracking t, tfs.cwuser u, tfs.cwuserrole ur, tfs.cwusergroupprivilege ugp, tfs.stc_privilege_v p, tfs.stc_tfr tfr
 where tfr.tfr_id = t.object_id
   and t.user_id = u.userid
   and u.userid = ur.userid
   and ugp.usergroup = ur.roleid
   and ugp.privilege = p.privilege_name;