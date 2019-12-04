CREATE OR REPLACE VIEW stcw_ftth_orders AS 
SELECT woi.wo_inst_id, woi.wo_name, woi.status wo_status_code,
       (SELECT status_name
          FROM rms_prod.val_task_status
         WHERE stat_code = woi.status) wo_status,
       (SELECT attr_value 
          FROM rms_prod.workorder_attr_settings was, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Order Type' 
           AND van.group_name = 'Work Order Info'
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND was.workorder_inst_id = woi.wo_inst_id) wo_order_type, 
       woi.start_after, woi.complete_by, woi.actual_start, woi.actual_compl,
       cpi.circ_path_inst_id, cpi.circ_path_hum_id, cpi.status,
       si.site_hum_id, si.state_prov, si.county, si.country,
       ra.target_subtype,
       ri.resource_inst_id, ri.status ri_status, ri.name, ri.category,
       (SELECT attr_value
          FROM rms_prod.resource_attr_settings ras, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Change Request Type'
           AND van.group_name = decode(ri.category, 'VOIP', 'FTTH_VOIP_ATTRIBUTES',
                                                    'IPTV', 'FTTH_IPTV_ATTRIBUTES',
                                                            'FTTH_HSI_ATTRIBUTES')
           AND ras.val_attr_inst_id = van.val_attr_inst_id
           AND ras.resource_inst_id = ri.resource_inst_id) changeRequestType
  FROM rms_prod.work_order_inst woi,
       rms_prod.circ_path_inst cpi,
       rms_prod.site_inst si,
       rms_prod.resource_associations ra,
       rms_prod.resource_inst ri
 WHERE woi.element_type = 'P'
   AND woi.element_inst_id = cpi.circ_path_inst_id
   AND cpi.circ_path_inst_id = (SELECT cpas.circ_path_inst_id
                                  FROM rms_prod.val_attr_name van, rms_prod.circ_path_attr_settings cpas
                                 WHERE van.attr_name = 'SOM_DOMAIN'
                                   AND van.group_name = 'Circuit Details'
                                   AND cpas.attr_value = 'WHOLESALE_G8'
                                   AND cpas.val_attr_inst_id = van.val_attr_inst_id
                                   AND cpas.circ_path_inst_id = cpi.circ_path_inst_id)
   AND si.site_inst_id = cpi.z_side_site_id
   AND si.num = 'FIBER'
   AND ra.target_inst_id = cpi.circ_path_inst_id
   AND ra.target_type_id = 10
   AND ri.resource_inst_id = ra.resource_inst_id;