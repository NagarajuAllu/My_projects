create or replace view stc_prn_summary_report_v as
select rownum num_row,
       prn.prn_id,
       prn.prn_name,
       prn.prn_status,
       prn.creation_date prn_creation_date,
       tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       nvl(tfr.current_userid, prn.current_userid) current_userid,
       (select urc.roleid
          from tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc
         where urc.userid = nvl(tfr.current_userid, prn.current_userid)
           and ugpc.usergroup = urc.roleid
           and ugpc.privilege = pc.privilege_name) current_department
  from tfs.stc_prn prn, tfs.stc_tfr tfr
 where tfr.tfr_id (+) = prn.tfr_id;
