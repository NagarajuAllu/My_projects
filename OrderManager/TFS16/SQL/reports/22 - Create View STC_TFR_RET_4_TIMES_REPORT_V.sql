create or replace view stc_tfr_ret_4_times_report_v as
select tfr.tfr_id,
       tfr.tfr_number,
       tfr.tfr_status,
       tfr.ni_number,
       tfr.requirement_type,
       (tfr.required + tfr.existing) total,
       tfr.current_userid,
       urc.roleid current_department,
       fat.recno,
       fat.newvalue audit_trail_remarks,
       at.updatedby audit_trail_who,
       at.lastupdateddate audit_trail_when
  from tfs.stc_tfr tfr, tfs.cwuserrole urc, tfs.cwusergroupprivilege ugpc, tfs.stc_privilege_v pc, tfs.cwaudittrail at, tfs.cwfieldaudittrail fat, tfs.cwmdtypes t
 where tfr.cworderid in (select t.order_id
                           from tfs.stc_tracking t
                          where t.performed_task_name like '%Reject%Mapping%'
                         group by t.order_id
                         having count(*) > 3)
   and urc.userid = tfr.current_userid
   and ugpc.usergroup = urc.roleid
   and ugpc.privilege = pc.privilege_name
   and at.docid = tfr.tfr_id
   and t.typename = 'tfs.tfr'
   and at.docmetadatatype = t.typeid
   and at.recno = fat.recno (+)
   and fat.attributename (+) = 'tfrRemarks';