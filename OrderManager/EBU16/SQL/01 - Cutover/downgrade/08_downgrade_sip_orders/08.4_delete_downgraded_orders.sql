delete from stc_name_value where cworderid in (
select cworderid from stc_order_message_home where ordernumber in (select workordernumber FROM cwe_downgrade.stc_lineItem));

delete from stc_service_parameters_home where cworderid in (
select cworderid from stc_order_message_home where ordernumber in (select workordernumber FROM cwe_downgrade.stc_lineItem));

delete from cworderinstance where cwdocid in (
select cworderid from stc_order_message_home where ordernumber in (select workordernumber FROM cwe_downgrade.stc_lineItem));

delete from stc_order_message_home where ordernumber in (select workordernumber FROM cwe_downgrade.stc_lineItem);




delete from stc_name_value where cworderid in (
select cworderid from stc_order_message_home where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from stc_service_parameters_home where cworderid in (
select cworderid from stc_order_message_home where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from cworderinstance where cwdocid in (
select cworderid from stc_order_message_home where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header));

delete from stc_order_message_home where ordernumber in (select ordernumber FROM cwe_downgrade.stc_bundleorder_header);


truncate table downgrade_log;
