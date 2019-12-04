create or replace view stc_advanced_report_v as
select tfr.tfr_id,
       tfr.tfr_number,
       tfr.ni_number,
       prn.prn_id,
       prn.prn_name,
       prn.prn_status,
       bi.bi_id,
       bi.bi_status,
       tfr.icms_number,
       tfr.district,
       tfr.region,
       tfr.priority,
       tfr.project,
       tfr.tfr_type,
       tfr.tfr_status,
       tfr.current_userid,
       tfr.mapping_status,
       tfr.dept_created_by,
       tfr.updatedBy,
       tfr.requirement_type,
       tfr.site_a_name,
       tfr.site_z_name,
       tfr.site_a_jvc,
       tfr.site_z_jvc,
       tfr.site_a_exchangetype,
       tfr.site_z_exchangetype,
       tfr.cwo_type,
       tfr.bu_requester,
       tfr.reason_for_issue,
       tfr.hajj_committment,
       tfr.group_requester,
       tfr.customer_name,
       tfr.site_a_if,
       tfr.site_z_if,
       tfr.existing,
       tfr.required,
       (tfr.existing + tfr.existing) total,
       tfr.order_number,
       tfr.circuit_number,
       tfr.creation_date,
       tfr.planned_rfs_date,
       tfr.customer_expd_date,
       tfr.fa_completion_date,
       (select listagg(remark_text, chr(10)) WITHIN GROUP (ORDER BY creation_date, cwdocid)
          from tfs.stc_tfr_remarks r
         where r.tfr_id = tfr.tfr_id
         group by tfr_id) tfr_remarks
  from tfs.stc_tfr tfr, tfs.stc_prn prn, tfs.stc_tfr_task tsk, tfs.stc_bi bi, tfs.stc_bi_relationship bir
 where bir.source_tfr_id (+) = tfr.tfr_id
   and bi.bi_id (+) = bir.bi_id
   and tsk.tfr_task_id (+) = tfr.tfr_id
   and prn.prn_id (+) = tfr.prn_id;
