create or replace view stc_duration_tfr_report_v as
select t.cwdocid,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       u.userid operation_username,
       ur.roleid operation_department,
       t.operation_name,
       t.performed_task_name,
       t.assign_to_user_date,
       t.completion_date,
       round((t.completion_date-t.assign_to_user_date)*24, 2) duration_in_hours,
       round((t.completion_date-t.assign_to_user_date), 2) duration_in_days,
       tfr.current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = tfr.current_userid
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department
  from tfs.stc_tracking t, tfs.cwuser u, tfs.cwuserrole ur, tfs.cwusergroupprivilege ugp, tfs.stc_privilege_v p, tfs.stc_tfr tfr
 where tfr.tfr_id = t.object_id
   and tfr.cworderid = t.order_id
   and u.userid = t.user_id
   and ur.userid = u.userid
   and ugp.usergroup = ur.roleid
   and ugp.privilege = p.privilege_name;