DECLARE

  CURSOR allParentLineItemsToProcess IS
    SELECT l.cworderid
      FROM stc_lineitem l
     WHERE l.elementTypeInOrderTree = 'B'
       AND l.provisioningFlag = 'PROVISIONING'
    UNION
    SELECT l.cworderid
      FROM stc_lineitem l
     WHERE l.elementTypeInOrderTree = 'B'
       AND l.provisioningFlag = 'ACTIVE'
       AND l.lineItemIdentifier NOT IN (SELECT lineItemIdentifier
                                          FROM stc_lineitem p
                                         WHERE p.elementTypeInOrderTree = 'B'
                                           AND provisioningFlag = 'PROVISIONING');

  CURSOR lineItemsInOrder(orderId VARCHAR2) IS
    SELECT cwdocid, workOrderNumber, locationACCLICode, locationBCCLICode
      FROM stc_lineitem
     WHERE cworderid = orderId
       AND workOrderNumber IS NOT NULL
       AND elementTypeInOrderTree in ('B', 'C');
       
  errorMsg        VARCHAR2(1000);
  foundCircuit    CHAR(1);
  woElementInstId NUMBER(10);
  siteAInstId     NUMBER(10);
  siteAName       stc_lineitem.locationACCLICode%TYPE;
  siteZInstId     NUMBER(10);
  siteZName       stc_lineitem.locationBCCLICode%TYPE;

BEGIN
  
  FOR parentLineItem IN allParentLineItemsToProcess LOOP
    BEGIN
      
      FOR li IN lineItemsInOrder(parentLineItem.cworderid) LOOP
        BEGIN
          errorMsg        := NULL;
          foundCircuit    := 'N';
          woElementInstId := NULL;
          siteAInstId     := NULL;
          siteAName       := NULL;
          siteZInstId     := NULL;
          siteZName       := NULL;
          
          -- looking for the WorkOrder
          BEGIN
            
            SELECT wo.element_inst_id
              INTO woElementInstId
              FROM work_order_inst@rms_prod_db_link wo
             WHERE wo.wo_name = li.workOrderNumber;     
                     
          EXCEPTION
            WHEN no_data_found THEN
              NULL;
          END;
          
          IF(woElementInstId IS NULL) THEN
            BEGIN
              
              SELECT wo.element_inst_id
                INTO woElementInstId
                FROM del_work_order_inst@rms_prod_db_link wo
               WHERE wo.wo_name = li.workOrderNumber;
               
            EXCEPTION
              WHEN no_data_found THEN
                NULL;
            END;
          END IF;
          
          IF(woElementInstId IS NULL) THEN 
            BEGIN
              
              errorMsg := 'Unable to find WO in Granite with name '||li.workOrderNumber;
              INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
                VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, errorMsg);
                
            END;
          ELSE 
            BEGIN
              
              -- looking for the Path
              BEGIN
                
                SELECT p.a_side_site_id, p.z_side_site_id
                  INTO siteAInstId, siteZInstId
                  FROM circ_path_inst@rms_prod_db_link p
                 WHERE p.circ_path_inst_id = woElementInstId;
                 
                 foundCircuit := 'Y';
                 
              EXCEPTION
                WHEN no_data_found THEN
                  NULL;
              END;
            
              IF(foundCircuit = 'N') THEN
                BEGIN
                  
                  SELECT p.a_side_site_id, p.z_side_site_id
                    INTO siteAInstId, siteZInstId
                    FROM del_circ_path_inst@rms_prod_db_link p
                   WHERE p.circ_path_inst_id = woElementInstId;

                 foundCircuit := 'Y';
                 
                EXCEPTION
                  WHEN no_data_found THEN
                    NULL;
                END;
              END IF;
              
              IF(foundCircuit = 'N') THEN 
                BEGIN
                  
                  errorMsg := 'Unable to find circuit in Granite with instId '||woElementInstId;
                  INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
                    VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, errorMsg);
                
                END;
              ELSE 
                BEGIN
                  
                  -- looking for site A
                  BEGIN
                    
                    SELECT si.site_hum_id
                      INTO siteAName
                      FROM site_inst@rms_prod_db_link si
                     WHERE si.site_inst_id = siteAInstId;
                     
                  EXCEPTION 
                    WHEN no_data_found THEN
                      NULL;
                  END;
                  
                  IF(siteAName IS NULL) THEN
                    BEGIN
                      
                      SELECT si.site_hum_id
                        INTO siteAName
                        FROM del_site_inst@rms_prod_db_link si
                       WHERE si.site_inst_id = siteAInstId;
                       
                    EXCEPTION 
                      WHEN no_data_found THEN
                        NULL;
                    END;
                  END IF;
              
                  IF(siteAName IS NULL) THEN 
                    BEGIN
                      
                      errorMsg := 'Unable to find site A in Granite with instId '||siteAInstId;
                      INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
                        VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, errorMsg);
                    
                    END;
                  ELSE 
                    BEGIN
                  
                      -- looking for site Z
                      BEGIN
                        
                        SELECT si.site_hum_id
                          INTO siteZName
                          FROM site_inst@rms_prod_db_link si
                         WHERE si.site_inst_id = siteZInstId;
                         
                      EXCEPTION 
                        WHEN no_data_found THEN
                          NULL;
                      END;
                      
                      IF(siteAName IS NULL) THEN
                        BEGIN
                          
                          SELECT si.site_hum_id
                            INTO siteZName
                            FROM del_site_inst@rms_prod_db_link si
                           WHERE si.site_inst_id = siteZInstId;
                           
                        EXCEPTION 
                          WHEN no_data_found THEN
                            NULL;
                        END;
                      END IF;
                  
                      IF(siteZName IS NULL) THEN 
                        BEGIN

                          errorMsg := 'Unable to find site Z in Granite with instId '||siteZInstId;
                          INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
                            VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, errorMsg);
                        
                        END;
                      ELSE 
                        BEGIN
                        
                          -- all data found; checking
                          IF(siteAName <> li.locationACCLICode OR siteZName <> li.locationBCCLICode) THEN
                            BEGIN
                
                              UPDATE stc_lineitem 
                                 SET locationACCLICode = siteAName,
                                     locationBCCLICode = siteZName 
                               WHERE cwdocid = li.cwdocid;
                      
                              INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
                                VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, null);
                
                            END;
                          END IF; -- end updating
                        END;                        
                      END IF;  -- end IF(siteZName IS NULL)
                    END;
                  END IF; -- end IF(siteAName IS NULL)
                END;
              END IF; -- end IF(foundCircuit = 'N') 
            END;
          END IF; -- end IF(woElementInstId IS NULL) 
          
        EXCEPTION
          WHEN others THEN
            errorMsg := substr(sqlerrm, 1, 1000);
            INSERT INTO stc_updateCCLI_log(logid, cworderid,	cwdocid, old_A_CCLI, old_Z_CCLI, new_A_CCLI, new_Z_CCLI, errorMsg)
              VALUES (stc_custom_log_id.nextval, parentLineItem.cworderid, li.cwdocid, li.locationACCLICode, li.locationBCCLICode, siteAName, siteZName, errorMsg);
        END;
      END LOOP;
        
    END;
  END LOOP;
END;
/
