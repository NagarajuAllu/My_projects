delete from stc_name_value where cworderid in (
select cworderid from stc_order_message where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from stc_service_parameters where cworderid in (
select cworderid from stc_order_message where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from cworderinstance where cwdocid in (
select cworderid from stc_order_message where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from stc_order_message where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header);

truncate table downgrade_log;