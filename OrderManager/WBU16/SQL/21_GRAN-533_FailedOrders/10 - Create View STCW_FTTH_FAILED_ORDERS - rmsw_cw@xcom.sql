CREATE OR REPLACE VIEW stcw_ftth_failed_orders AS 
SELECT woi.wo_inst_id, woi.wo_name, woi.status wo_status_code,
       (SELECT status_name 
          FROM rms_prod.val_task_status 
         WHERE stat_code = woi.status) wo_status, 
       (SELECT was.attr_value 
          FROM rms_prod.workorder_attr_settings was, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Order Type' 
           AND van.group_name = 'Work Order Info'
           AND was.val_attr_inst_id = van.val_attr_inst_id
           AND was.workorder_inst_id = woi.wo_inst_id) wo_order_type, 
       woi.start_after, woi.complete_by, woi.actual_start, woi.actual_compl,
       tsk.task_inst_id, tsk.task_name, tsk.task_number, tsk.task_operation, tsk.status_code tsk_status_code,
       (SELECT status_name 
          FROM rms_prod.val_task_status 
         WHERE stat_code = tsk.status_code) tsk_status, 
       tsk.start_after tsk_start_after, tsk.complete_by tsk_complete_by, tsk.actual_start tsk_actual_start, tsk.actual_compl tsk_actual_compl,
       (SELECT tas.attr_value
          FROM rms_prod.task_attr_settings tas, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Reason Code'
           AND van.group_name = 'Rejected Task Details' 
           AND tas.val_attr_inst_id = van.val_attr_inst_id
           AND tas.task_inst_id = tsk.task_inst_id) tsk_reason_code,
       (SELECT tas.attr_value
          FROM rms_prod.task_attr_settings tas, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Reason Description'
           AND van.group_name = 'Rejected Task Details' 
           AND tas.val_attr_inst_id = van.val_attr_inst_id
           AND tas.task_inst_id = tsk.task_inst_id) tsk_reason_descr,
       cpi.circ_path_inst_id, cpi.circ_path_hum_id, cpi.status,
       si.site_hum_id, si.state_prov, si.county, si.country,
       ra.target_subtype,
       ri.resource_inst_id, ri.status ri_status, ri.name, ri.category,
       (SELECT ras.attr_value
          FROM rms_prod.resource_attr_settings ras, rms_prod.val_attr_name van
         WHERE van.attr_name = 'Change Request Type'
           AND van.group_name = decode(ri.category, 'VOIP', 'FTTH_VOIP_ATTRIBUTES',
                                                    'IPTV', 'FTTH_IPTV_ATTRIBUTES',
                                                            'FTTH_HSI_ATTRIBUTES')
           AND ras.val_attr_inst_id = van.val_attr_inst_id
           AND ras.resource_inst_id = ri.resource_inst_id) changeRequestType,
       (SELECT ei.serial_no
          FROM rms_prod.circ_path_element cpe, rms_prod.equip_inst ei, rms_prod.epa p
         WHERE p.port_inst_id = cpe.port_inst_id
           AND ei.equip_inst_id = p.equip_inst_id
           AND ei.type = 'FTTH-ONT'
           AND cpe.circ_path_inst_id = cpi.circ_path_inst_id
           AND cpe.element_type = 'E'
           AND rownum = 1) ont_serial_no,
       (select attr_value
          from rms_prod.resource_attr_settings ras, rms_prod.val_attr_name van
         where van.attr_name = 'UPSTREAM_BW'
           and van.group_name = 'FTTH_HSI_ATTRIBUTES'
           and ras.val_attr_inst_id = van.val_attr_inst_id
           and ras.resource_inst_id = ri.resource_inst_id) upstreamBW,
       (select attr_value
          from rms_prod.resource_attr_settings ras, rms_prod.val_attr_name van
         where van.attr_name = 'DOWNSTREAM_BW'
           and van.group_name = 'FTTH_HSI_ATTRIBUTES'
           and ras.val_attr_inst_id = van.val_attr_inst_id
           and ras.resource_inst_id = ri.resource_inst_id) downstreamBW
  FROM rms_prod.work_order_inst woi,
       rms_prod.wo_task_inst tsk,
       rms_prod.circ_path_inst cpi,
       rms_prod.site_inst si,
       rms_prod.resource_associations ra,
       rms_prod.resource_inst ri,
       rms_prod.stc_g8_failed_orders fo
 WHERE woi.element_type = 'P'
   AND tsk.wo_inst_id = woi.wo_inst_id
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
   AND ri.resource_inst_id = ra.resource_inst_id
   AND woi.status IN (4, 5, 6, 9)
   AND fo.task_inst_id = tsk.task_inst_id
;