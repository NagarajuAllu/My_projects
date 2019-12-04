create or replace view stc_tfr_rejection_report_v as
select act.activity_id,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.site_a_name,
       tfr.site_z_name,
       tfr.site_a_jvc,
       tfr.site_z_jvc,
       proc.creation_date proc_creation_date,
       tfr.rejection_code,
       tfr.current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = tfr.current_userid
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department,
       act.creation_date act_creation_date,
       act.question_id,
       (select q.text_question
          from tfs.stc_reject_question q
         where q.question_id = act.question_id) text_question,
       act.answer_id,
       (select a.text_answer
          from tfs.stc_reject_answer a
         where a.answer_id = act.answer_id) text_answer
  from tfs.stc_tfr tfr, tfs.stc_rejection_process proc, tfs.stc_rejection_process_activity act
 where proc.tfr_id = tfr.tfr_id
   and act.process_id = proc.process_id;