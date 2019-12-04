CREATE OR REPLACE VIEW STC_EXPEDITOR_WBU_NINUMBER 
(resource_inst_id, ninumber, target_inst_id, target_subtype)
AS
SELECT ra2.RESOURCE_INST_ID,
       (SELECT LISTAGG(sa.USER_VALUE, ',') WITHIN GROUP (ORDER BY sa.USER_VALUE)
          FROM segment_attributes sa, CIRCUIT_PATH_ELEMENTS ce
         WHERE ce.CIRC_PATH_INST_ID = ra2.TARGET_INST_ID
           AND ce.ELEMENT_CATEGORY LIKE 'NI'
           AND ce.ELEMENT_INST_ID = sa.CIRC_INST_ID
           AND sa.ATTRIBUTE_GROUP = 'SEGMENTINFO'
           AND sa.USER_ATTRIBUTE = 'Network Identifier (NI Number)') NINUMBER,
       ra2.target_inst_id,
       ra2.target_subtype
  FROM resource_associations ra2
 WHERE ra2.TARGET_TYPE_ID = 10
UNION
SELECT ra2.RESOURCE_INST_ID,
       (SELECT LISTAGG(sa.USER_VALUE, ',') WITHIN GROUP (ORDER BY sa.USER_VALUE)
          FROM segment_attributes sa, CIRCUIT_PATH_ELEMENTS ce
         WHERE ce.CIRC_PATH_INST_ID = ra2.TARGET_INST_ID
           AND ce.ELEMENT_CATEGORY LIKE 'NI'
           AND ce.ELEMENT_INST_ID = sa.CIRC_INST_ID
           AND sa.ATTRIBUTE_GROUP = 'SEGMENTINFO'
           AND sa.USER_ATTRIBUTE = 'Network Identifier (NI Number)') NINUMBER,
       ra2.target_inst_id,
       ra2.target_subtype
  FROM del_resource_associations ra2
 WHERE ra2.TARGET_TYPE_ID = 10
;