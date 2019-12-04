create or replace view stc_rejection_alarm_report_v as
select t.cwdocid,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.rejection_code,
       t.completion_date,
       (select listagg(r.remark_text, chr(10)) WITHIN GROUP (ORDER BY r.creation_date, r.cwdocid)
          from tfs.stc_tfr_remarks r
         where r.tfr_id = tfr.tfr_id
         group by r.tfr_id) tfr_remarks,
       u.userid_xc xc_userid,
       tfr.current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = tfr.current_userid
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department
  from tfs.stc_tfr tfr, tfs.stc_tracking t, tfs.stc_users4order u
 where tfr.tfr_id = t.object_id
   and tfr.cworderid = t.order_id
   and u.order_id = t.order_id
   and u.orderitemid = 0
   and t.operation_name = 'workflow.orderInitiatorTeamIF/reviewCWOReport'
   and t.performed_task_name = 'Reject CWO Report';