create or replace view stc_prnr_prn_sum_report_v as
select prnr.prnr_id,
       prnr.prnr_name,
       prnr.prnr_status,
       prnr.customer_name,
       prnr.customer_project,
       prnr.customer_project_phase,
       prnr.creation_date prnr_creation_date,
       prnr.released_date prnr_released_date,
       prnr.current_userid prnr_current_userid,
       prnr.created_by prnr_created_by,
       prn.prn_id,
       prn.prn_name,
       prn.prn_status,
       prn.planner,
       prn.analyzed_by,
       prn.analysis_date,
       prn.released_date prn_released_date,
       prn.creation_date prn_creation_date,
       prn.current_userid prn_current_userid
  from tfs.stc_prnr prnr, tfs.stc_prn prn
 where prnr.prnr_id = prn.prnr_id;