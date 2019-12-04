create or replace view stc_work_productivity_report_v as
select t.user_id,
       ur.roleid,
       t.cwDocId,
       t.operation_name,
       t.performed_task_name,
       t.assign_to_user_date,
       t.completion_date track_completion_date,
       round((t.completion_date-t.assign_to_user_date)*24, 2) duration_in_hours,
       round((t.completion_date-t.assign_to_user_date), 2) duration_in_days,
       t.object_type,
       t.object_id,
       decode(t.object_type, 'TFR Task', tsk.task_name,
                                         tfr.tfr_number) object_name,
       decode(t.object_type, 'TFR Task', tsk.task_status,
                                         tfr.tfr_status) object_status,
       decode(t.object_type, 'TFR Task', null,
                                         tfr.ni_number) ni_number,
       decode(t.object_type, 'TFR Task', null,
                                         tfr.project) tfr_project,
       decode(t.object_type, 'TFR Task', nvl2(t.completion_date, null, t.user_id),
                                         tfr.current_userid) current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = decode(t.object_type, 'TFR Task', nvl2(t.completion_date, null, t.user_id),
                                                              tfr.current_userid)
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department
  from tfs.stc_tracking t, tfs.cwuser u, tfs.cwuserrole ur, tfs.cwusergroupprivilege ugp, tfs.stc_privilege_v p, tfs.stc_tfr tfr, tfs.stc_tfr_task tsk
 where t.object_type in ('TFR', 'TFR Task')
   and u.userid = t.user_id
   and ur.userid = u.userid
   and ugp.usergroup = ur.roleid
   and ugp.privilege = p.privilege_name
   and tfr.tfr_id (+) = t.object_id
   and tsk.tfr_task_id (+) = t.object_id
   and t.completion_date is not null;