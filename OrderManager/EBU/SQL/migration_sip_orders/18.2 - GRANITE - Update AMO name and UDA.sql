set serveroutput on

DECLARE

  CURSOR c_crm_data IS
    SELECT circuitnumber, childcircuitid, childservicenumber, childequivalentservicenumber
      FROM stc_sip_crm_data@cwe_wdprod_db_link
     WHERE used = 'M';

  CURSOR c_resources(circuitnumber IN VARCHAR2) IS
    SELECT distinct ri.name, ri.resource_inst_id, ri.definition_inst_id
      FROM circ_path_inst cpi, resource_associations ra, resource_inst ri
     WHERE cpi.circ_path_hum_id = circuitnumber
       AND ra.target_type_id = 10
       AND cpi.circ_path_inst_id = ra.target_inst_id
       AND ra.resource_inst_id = ri.resource_inst_id
       AND ri.category like '%SIP%';
  
  found                CHAR(1);
  did_servicenumber    resource_inst.name%TYPE;
  old_amo_name         resource_inst.name%TYPE;
  didresource_inst_id  resource_inst.resource_inst_id%TYPE;
  
  old_uda_value        resource_attr_settings.attr_value%TYPE;
  uda_inst_id          val_attr_name.val_attr_inst_id%TYPE;
  uda_group_inst_id    val_attr_name.val_attr_inst_id%TYPE;
  
BEGIN

  DBMS_OUTPUT.ENABLE(NULL);
  
dbms_output.put_line('[INFO] Starting');  

  FOR crmDataCursor IN c_crm_data LOOP
    BEGIN
      found := 'N';
      
dbms_output.put_line('[INFO] Process serviceNumber ['||crmDataCursor.circuitnumber||']');

      FOR graniteResourceCursor in c_resources(crmDataCursor.circuitnumber) LOOP
        BEGIN
          INSERT INTO stc_granite_bck_amo_name 
            VALUES (graniteResourceCursor.resource_inst_id, graniteResourceCursor.name, crmDataCursor.childcircuitid, null, null, null);

          UPDATE resource_inst
             SET name = crmDataCursor.childcircuitid
           WHERE resource_inst_id = graniteResourceCursor.resource_inst_id;


dbms_output.put_line('[INFO]    Updated successfully AMO ['||graniteResourceCursor.resource_inst_id||'] for serviceNumber['||crmDataCursor.circuitnumber||']; new value: '||crmDataCursor.childcircuitid);

          IF(crmDataCursor.childequivalentservicenumber IS NOT NULL) THEN
            uda_inst_id := NULL;
            
            -- searching UDA inst id
            IF(INSTR(crmDataCursor.childcircuitid, ' 800') > 0) THEN
              -- 800 is SIP_TF
              SELECT val_attr_inst_id, group_inst_id
                INTO uda_inst_id, uda_group_inst_id
                FROM val_attr_name van, val_attr_group vag
               WHERE van.attr_name = 'TELEPHONE NUMBER'
                 AND van.group_name = 'SIP_TF_Attributes'
                 AND van.group_name = vag.group_name;
            ELSIF(INSTR(crmDataCursor.childcircuitid, ' 9200') > 0) THEN
              -- 9200 is SIP_UAN
              SELECT val_attr_inst_id, group_inst_id
                INTO uda_inst_id, uda_group_inst_id
                FROM val_attr_name van, val_attr_group vag
               WHERE van.attr_name = 'TELEPHONE NUMBER'
                 AND van.group_name = 'SIP_UAN_Attributes'
                 AND van.group_name = vag.group_name;
            END IF;
            
            IF(uda_inst_id IS NOT NULL) THEN            
dbms_output.put_line('[INFO]    UDA INST ID = '||uda_inst_id);
              -- managing UDA "TELEPHONE NUMBER"
              old_uda_value := NULL;
              
              BEGIN
                SELECT attr_value
                  INTO old_uda_value
                  FROM resource_attr_settings ras
                 WHERE ras.val_attr_inst_id = uda_inst_id
                   AND ras.resource_def_id = graniteResourceCursor.definition_inst_id
                   AND ras.resource_inst_id = graniteResourceCursor.resource_inst_id;
              EXCEPTION
                WHEN no_data_found THEN
                  old_uda_value := NULL;
              END;
                  
              IF(old_uda_value IS NOT NULL) THEN
                UPDATE resource_attr_settings ras
                   SET ras.attr_value = crmDataCursor.childservicenumber
                 WHERE ras.resource_inst_id = graniteResourceCursor.resource_inst_id
                   AND ras.resource_def_id = graniteResourceCursor.definition_inst_id
                   AND ras.val_attr_inst_id = uda_inst_id;
              ELSE 
                INSERT INTO resource_attr_settings ras(resource_inst_id, resource_def_id, group_inst_id, val_attr_inst_id, attr_value)
                  VALUES(graniteResourceCursor.resource_inst_id, graniteResourceCursor.definition_inst_id, uda_group_inst_id, uda_inst_id, crmDataCursor.childservicenumber);
              END IF;
            
              UPDATE stc_granite_bck_amo_name bck 
                 SET bck.uda_identifier = uda_inst_id,
                     bck.old_uda_value = old_uda_value,
                     bck.new_uda_value = crmDataCursor.childservicenumber
               WHERE bck.amo_inst_id = graniteResourceCursor.resource_inst_id;
      
dbms_output.put_line('[INFO]    Updated successfully UDA ''TELEPHONE NUMBER'' for AMO ['||graniteResourceCursor.resource_inst_id||'] for serviceNumber['||crmDataCursor.circuitnumber||']; new value: '||crmDataCursor.childservicenumber);
            END IF;
            
          END IF;
          
          found := 'Y';
       
        END;
      END LOOP;
      
      IF(found = 'N') THEN
dbms_output.put_line('[ERROR]   Unable to find AMO for serviceNumber['||crmDataCursor.circuitnumber||']'); 
      ELSE
        IF(crmDataCursor.childequivalentservicenumber IS NOT NULL) THEN
          UPDATE stc_sip_crm_data@cwe_wdprod_db_link
             SET used = 'Y'
           WHERE circuitnumber = crmDataCursor.circuitnumber
             AND childcircuitid = crmDataCursor.childcircuitid
             AND childservicenumber = crmDataCursor.childservicenumber
             AND childequivalentservicenumber = crmDataCursor.childequivalentservicenumber;
        ELSE 
          UPDATE stc_sip_crm_data@cwe_wdprod_db_link
             SET used = 'Y'
           WHERE circuitnumber = crmDataCursor.circuitnumber
             AND childcircuitid = crmDataCursor.childcircuitid
             AND childservicenumber = crmDataCursor.childservicenumber
             AND childequivalentservicenumber IS NULL;
        END IF;
dbms_output.put_line('[INFO]   updated['||crmDataCursor.circuitnumber||','||crmDataCursor.childcircuitid||','||crmDataCursor.childservicenumber||','||crmDataCursor.childequivalentservicenumber||']'); 
      END IF;
      
    END;
  
  END LOOP;

END;
/
  