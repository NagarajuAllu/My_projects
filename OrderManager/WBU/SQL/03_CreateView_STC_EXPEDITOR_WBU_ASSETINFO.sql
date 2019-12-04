CREATE OR REPLACE VIEW STC_EXPEDITOR_WBU_ASSETINFO
(wo_name, wo_status, assetname, assetstatus, wo_comments, resource_inst_id)
AS
SELECT DISTINCT w.WO_NAME,
                w.STATUS,
                ri.NAME ASSETNAME,
                ri.STATUS ASSETSTATUS,
                REPLACE(REPLACE(w.COMMENTS, CHR(31), '|'), CHR(30), CHR(10)) comments,
                ri.resource_inst_id
  FROM work_order_inst w,
       resource_inst ri,
       resource_domain_map rm,
       domain_inst di
 WHERE w.STATUS IN (7, 8)
   AND w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
   AND ri.RESOURCE_INST_ID = rm.RESOURCE_INST_ID
   AND rm.DOMAIN_INST_ID = di.DOMAIN_INST_ID
   AND di.DOMAIN_NAME = 'wbu__domain'
   AND ri.CATEGORY <> 'I/N-VOIP_TRANSIT'
   AND ri.CATEGORY <> 'I-BILATERAL_VOICE_CIRCUIT'
   AND ri.CATEGORY <> 'I/N-SS7_SIGNALING'
   AND ri.CATEGORY <> 'I/N-INTERCONNECT_LINK'
UNION
SELECT DISTINCT w.WO_NAME,
                w.STATUS,
                ri.NAME ASSETNAME,
                ri.STATUS ASSETSTATUS,
                REPLACE(REPLACE(w.COMMENTS, CHR(31), '|'), CHR(30), CHR(10)) comments,
                ri.resource_inst_id
  FROM del_work_order_inst w,
       resource_inst ri,
       resource_domain_map rm,
       domain_inst di
 WHERE w.STATUS IN (7, 8)
   AND w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
   AND ri.RESOURCE_INST_ID = rm.RESOURCE_INST_ID
   AND rm.DOMAIN_INST_ID = di.DOMAIN_INST_ID
   AND di.DOMAIN_NAME = 'wbu__domain'
   AND ri.CATEGORY <> 'I/N-VOIP_TRANSIT'
   AND ri.CATEGORY <> 'I-BILATERAL_VOICE_CIRCUIT'
   AND ri.CATEGORY <> 'I/N-SS7_SIGNALING'
   AND ri.CATEGORY <> 'I/N-INTERCONNECT_LINK'
UNION
SELECT DISTINCT w.WO_NAME,
                w.STATUS,
                ri.NAME ASSETNAME,
                ri.STATUS ASSETSTATUS,
                REPLACE(REPLACE(w.COMMENTS, CHR(31), '|'), CHR(30), CHR(10)) comments,
                ri.resource_inst_id
  FROM del_resource_inst ri,
       work_order_inst w,
       resource_domain_map rm,
       domain_inst di
 WHERE w.STATUS IN (7, 8)
   AND w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
   AND ri.RESOURCE_INST_ID = rm.RESOURCE_INST_ID
   AND rm.DOMAIN_INST_ID = di.DOMAIN_INST_ID
   AND di.DOMAIN_NAME = 'wbu__domain'
   AND ri.CATEGORY <> 'I/N-VOIP_TRANSIT'
   AND ri.CATEGORY <> 'I-BILATERAL_VOICE_CIRCUIT'
   AND ri.CATEGORY <> 'I/N-SS7_SIGNALING'
   AND ri.CATEGORY <> 'I/N-INTERCONNECT_LINK'
UNION
SELECT DISTINCT w.WO_NAME,
                w.STATUS,
                ri.NAME ASSETNAME,
                ri.STATUS ASSETSTATUS,
                REPLACE(REPLACE(w.COMMENTS, CHR(31), '|'), CHR(30), CHR(10)) comments,
                ri.resource_inst_id
  FROM del_resource_inst ri,
       del_work_order_inst w,
       resource_domain_map rm,
       domain_inst di
 WHERE w.STATUS IN (7, 8)
   AND w.ELEMENT_INST_ID = ri.RESOURCE_INST_ID
   AND ri.RESOURCE_INST_ID = rm.RESOURCE_INST_ID
   AND rm.DOMAIN_INST_ID = di.DOMAIN_INST_ID
   AND di.DOMAIN_NAME = 'wbu__domain'
   AND ri.CATEGORY <> 'I/N-VOIP_TRANSIT'
   AND ri.CATEGORY <> 'I-BILATERAL_VOICE_CIRCUIT'
   AND ri.CATEGORY <> 'I/N-SS7_SIGNALING'
   AND ri.CATEGORY <> 'I/N-INTERCONNECT_LINK'
;
