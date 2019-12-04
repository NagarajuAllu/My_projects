CREATE OR REPLACE VIEW STC_GRANITE_REDUCED_DATA_4_HBU AS
SELECT DISTINCT "CIRC_PATH_INST_ID","CIRCUIT_NUMBER","CIRCUIT_STATUS","CUSTOMER","CUSTOMER_NAME","CUSTOMER_NUMBER","ACCOUNT_NUMBER","ICMS_SO_NUMBER","ORDER_DOMAIN","ORDER_NUMBER","ORDER_TYPE","ORDER_STATUS","NBR_TASKS","PROJECT_ID","CCT_TYPE","SERVICE_DATE","PLATE_ID","CREATED_BY","DOMAIN_NAME","ORDER_ROW_ITEM_ID","PARENT_ORDER_NUMBER","SUBMITTED_DATE_YEAR"
  FROM (
-- CIRC_PATH_INST + WORK_ORDER_INST
SELECT cpi.circ_path_inst_id,
       cpi.circ_path_hum_id circuit_number,
       cpi.status circuit_status,
       cpi.customer_id customer,
       (SELECT customer_name
          FROM val_customer v
         WHERE v.customer_id = cpi.customer_id) customer_name,
       cpi.customer_id customer_number,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Account Number') account_number,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'ICMS S/O Number') icms_so_number,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Domain'),
           'hbu__domain'),
         'ebu__domain', 'IEBU', 'wbu__domain','IWBU','IHBU') order_domain,
       woi.wo_name order_number,
       SUBSTR(NVL((SELECT was.attr_value
                     FROM workorder_attr_settings was, val_attr_name van
                    WHERE was.workorder_inst_id = woi.wo_inst_id
                      AND was.val_attr_inst_id = van.val_attr_inst_id
                      AND van.attr_name = 'Order Type'),
                   SUBSTR(woi.wo_name, 1, 1)), 1, 25) order_type,
       vts.status_name order_status,
       woi.nbr_tasks,
       woi.project_id,
       cpi.type cct_type,
       TO_CHAR(cpi.due,'MM/dd/yyyy') service_date,
       (SELECT site_hum_id
          FROM site_inst
         WHERE site_inst_id = cpi.z_side_site_id) plate_id,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Created by') created_by,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Source Domain'),
           di.domain_name),
         'Home', 'hbu__domain', di.domain_name) domain_name,
       '-1' order_row_item_id,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Parent Order Number') parent_order_number,
       TO_CHAR(woi.start_after, 'YYYY') submitted_date_year
  FROM circ_path_inst cpi,
       circ_path_inst next_cpi,
       work_order_inst woi,
       val_task_status vts,
       path_domain_map pdm,
       domain_inst di
 WHERE cpi.circ_path_inst_id = woi.element_inst_id
   AND cpi.next_path_inst_id = next_cpi.circ_path_inst_id(+)
--   AND next_cpi.circ_path_rev_nbr IS NULL
   AND pdm.circ_path_inst_id = cpi.circ_path_inst_id
   AND pdm.domain_inst_id = di.domain_inst_id
   AND vts.stat_code = woi.status
UNION
-- DEL_CIRC_PATH_INST + WORK_ORDER_INST
SELECT d_cpi.circ_path_inst_id,
       d_cpi.circ_path_hum_id circuit_number,
       d_cpi.status circuit_status,
       d_cpi.customer_id customer,
       (SELECT customer_name
          FROM val_customer v
         WHERE v.customer_id = d_cpi.customer_id) customer_name,
       d_cpi.customer_id customer_number,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = d_cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Account Number') account_number,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'ICMS S/O Number') icms_so_number,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Domain'),
           'hbu__domain'),
         'ebu__domain', 'IEBU', 'wbu__domain','IWBU', 'IHBU') order_domain,
       woi.wo_name order_number,
       SUBSTR(NVL((SELECT was.attr_value
                     FROM workorder_attr_settings was, val_attr_name van
                    WHERE was.workorder_inst_id = woi.wo_inst_id
                      AND was.val_attr_inst_id = van.val_attr_inst_id
                      AND van.attr_name = 'Order Type'),
                   SUBSTR(woi.wo_name, 1, 1)), 1, 25) order_type,
       vts.status_name order_status,
       woi.nbr_tasks,
       woi.project_id,
       d_cpi.type cct_type,
       TO_CHAR(d_cpi.due,'MM/dd/yyyy') service_date,
       (SELECT site_hum_id
          FROM site_inst
         WHERE site_inst_id = d_cpi.z_side_site_id) plate_id,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = d_cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Created by') created_by,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Source Domain'),
           di.domain_name),
         'Home', 'hbu__domain', di.domain_name) domain_name,
       '-1' order_row_item_id,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Parent Order Number') parent_order_number,
       TO_CHAR(woi.start_after, 'YYYY') submitted_date_year
  FROM del_circ_path_inst d_cpi,
       del_circ_path_inst nd_cpi,
       work_order_inst woi,
       val_task_status vts,
       path_domain_map pdm,
       domain_inst di
 WHERE d_cpi.circ_path_inst_id = woi.element_inst_id
   AND d_cpi.next_path_inst_id = nd_cpi.circ_path_inst_id(+)
--   AND nd_cpi.circ_path_rev_nbr IS NULL
   AND pdm.circ_path_inst_id = d_cpi.circ_path_inst_id
   AND pdm.domain_inst_id = di.domain_inst_id
   AND vts.stat_code = woi.status
UNION
-- CIRC_PATH_INST + DEL_WORK_ORDER_INST
SELECT cpi.circ_path_inst_id,
       cpi.circ_path_hum_id circuit_number,
       cpi.status circuit_status,
       cpi.customer_id customer,
       (SELECT customer_name
          FROM val_customer v
         WHERE v.customer_id = cpi.customer_id) customer_name,
       cpi.customer_id customer_number,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Account Number') account_number,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = d_woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'ICMS S/O Number') icms_so_number,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = d_woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Domain'),
           'hbu__domain'),
         'ebu__domain', 'IEBU', 'wbu__domain','IWBU', 'IHBU') order_domain,
       d_woi.wo_name order_number,
       SUBSTR(NVL((SELECT was.attr_value
                     FROM workorder_attr_settings was, val_attr_name van
                    WHERE was.workorder_inst_id = d_woi.wo_inst_id
                      AND was.val_attr_inst_id = van.val_attr_inst_id
                      AND van.attr_name = 'Order Type'),
                   SUBSTR(d_woi.wo_name, 1, 1)), 1, 25) order_type,
       vts.status_name order_status,
       d_woi.nbr_tasks,
       d_woi.project_id,
       cpi.type cct_type,
       TO_CHAR(cpi.due,'MM/dd/yyyy') service_date,
       (SELECT site_hum_id
          FROM site_inst
         WHERE site_inst_id = cpi.z_side_site_id) plate_id,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Created by') created_by,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = d_woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Source Domain'),
           di.domain_name),
         'Home', 'hbu__domain', di.domain_name) domain_name,
       '-1' order_row_item_id,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = d_woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Parent Order Number') parent_order_number,
       TO_CHAR(d_woi.start_after, 'YYYY') submitted_date_year
  FROM circ_path_inst cpi,
       circ_path_inst next_cpi,
       del_work_order_inst d_woi,
       val_task_status vts,
       path_domain_map pdm,
       domain_inst di
 WHERE cpi.circ_path_inst_id = d_woi.element_inst_id
   AND cpi.next_path_inst_id = next_cpi.circ_path_inst_id(+)
--   AND next_cpi.circ_path_rev_nbr IS NULL
   AND pdm.circ_path_inst_id = cpi.circ_path_inst_id
   AND pdm.domain_inst_id = di.domain_inst_id
   AND vts.stat_code = d_woi.status
UNION
-- DEL_CIRC_PATH_INST + DEL_WORK_ORDER_INST
SELECT d_cpi.circ_path_inst_id,
       d_cpi.circ_path_hum_id circuit_number,
       d_cpi.status circuit_status,
       d_cpi.customer_id customer,
       (SELECT customer_name
          FROM val_customer v
         WHERE v.customer_id = d_cpi.customer_id) customer_name,
       d_cpi.customer_id customer_number,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = d_cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Account Number') account_number,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = d_woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'ICMS S/O Number') icms_so_number,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = d_woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Domain'),
           'hbu__domain'),
         'ebu__domain', 'IEBU', 'wbu__domain','IWBU', 'IHBU') order_domain,
       d_woi.wo_name order_number,
       SUBSTR(NVL((SELECT was.attr_value
                     FROM workorder_attr_settings was, val_attr_name van
                    WHERE was.workorder_inst_id = d_woi.wo_inst_id
                      AND was.val_attr_inst_id = van.val_attr_inst_id
                      AND van.attr_name = 'Order Type'),
                   SUBSTR(d_woi.wo_name, 1, 1)), 1, 25) order_type,
       vts.status_name order_status,
       d_woi.nbr_tasks,
       d_woi.project_id,
       d_cpi.type cct_type,
       TO_CHAR(d_cpi.due,'MM/dd/yyyy') service_date,
       (SELECT site_hum_id
          FROM site_inst
         WHERE site_inst_id = d_cpi.z_side_site_id) plate_id,
       (SELECT cpas.attr_value
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = d_cpi.circ_path_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Created by') created_by,
       DECODE(
         NVL(
           (SELECT was.attr_value
              FROM workorder_attr_settings was, val_attr_name van
             WHERE was.workorder_inst_id = d_woi.wo_inst_id
               AND was.val_attr_inst_id = van.val_attr_inst_id
               AND van.attr_name = 'Source Domain'),
           di.domain_name),
         'Home', 'hbu__domain', di.domain_name) domain_name,
       '-1' order_row_item_id,
       (SELECT was.attr_value
          FROM workorder_attr_settings was, val_attr_name van
         WHERE was.workorder_inst_id = d_woi.wo_inst_id
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'Parent Order Number') parent_order_number,
       TO_CHAR(d_woi.start_after, 'YYYY') submitted_date_year
  FROM del_circ_path_inst d_cpi,
       del_circ_path_inst nd_cpi,
       del_work_order_inst d_woi,
       val_task_status vts,
       path_domain_map pdm,
       domain_inst di
 WHERE d_cpi.circ_path_inst_id = d_woi.element_inst_id
   AND d_cpi.next_path_inst_id = nd_cpi.circ_path_inst_id(+)
--   AND nd_cpi.circ_path_rev_nbr IS NULL
   AND pdm.circ_path_inst_id = d_cpi.circ_path_inst_id
   AND pdm.domain_inst_id = di.domain_inst_id
   AND vts.stat_code = d_woi.status
)
;