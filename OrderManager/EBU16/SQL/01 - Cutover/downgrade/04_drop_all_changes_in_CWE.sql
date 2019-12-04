-- THIS ONE HAS TO BE EXECUTED AS CWE


DROP TABLE stc_amo_name_bck CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_sip_crm_data CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_sip_workaround_data CASCADE CONSTRAINTS PURGE;

DROP TABLE sip_orders_excluded_from_migr CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_home_fromcrm_ordnum;
DROP TABLE stc_home_sip_fromcrm CASCADE CONSTRAINTS PURGE;

DROP INDEX idx_nv_home_cwordid;
DROP TABLE stc_nv_home_sip CASCADE CONSTRAINTS PURGE;

DROP INDEX idx_sp_home_cwordid;
DROP TABLE stc_sp_home_sip CASCADE CONSTRAINTS PURGE;

DROP INDEX idx_om_home_parentordernumber;
DROP INDEX idx_om_home_cwordid;
DROP TABLE stc_om_home_sip CASCADE CONSTRAINTS PURGE;


DROP TABLE stc_nvnames_mandatory CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_servicetype_behaviorconfig CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_lineitem_validation_map CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_orderheader_validation_map CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_producttype_map_intval;
DROP INDEX stc_producttype_map_crmval;
DROP TABLE stc_producttype_name_map CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_servicetype_map_crmval;
DROP TABLE stc_servicetype_name_map CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_orders_sent2granite_ordnum;
DROP TABLE stc_orders_sent_to_granite CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_map_workordertype CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_ord_orchestr_cworderid;
DROP TABLE stc_order_orchestration CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_granite_event_storage CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_pl_validation_dtypename;
DROP TABLE stc_picklist_for_validation CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_block_value CASCADE CONSTRAINTS PURGE;

DROP TABLE stc_reason_code CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_lineitem_liidentifier;
DROP INDEX stc_lineitem_cworderid;
DROP TABLE stc_lineitem CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_namevalue_parentid;

DROP INDEX stc_block_namevalue_parentid;
DROP INDEX stc_block_namevalue_cworderid;
DROP TABLE stc_block_name_value CASCADE CONSTRAINTS PURGE;

DROP INDEX stc_bo_header_ordernumber;
DROP INDEX stc_bo_header_cworderid;
DROP TABLE stc_bundleorder_header CASCADE CONSTRAINTS PURGE;

DROP PACKAGE legacy_order_migration;

DROP TABLE stc_migration_log;
DROP SEQUENCE stc_migration_log_seq;

ALTER TABLE stc_name_value DROP COLUMN parentelementid;
ALTER TABLE stc_name_value DROP COLUMN action;

ALTER TABLE stc_order_message DROP COLUMN migratedtobundle;