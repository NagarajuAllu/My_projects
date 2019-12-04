/*****************************************

 HBU version of the stored procedure fill_hbu_expd_order_missing.


 This script must be executed by Granite Regional DB user in its schema.

*******************************************/

CREATE OR REPLACE PROCEDURE FILL_HBU_EXPD_ORDER_MISSING(submitted_date_year VARCHAR2, order_type VARCHAR2) AS

  error_msg                 VARCHAR2(100);
  count_rec                 NUMBER(9);
  count_children            NUMBER(9);
  step                      VARCHAR2(1);
  
  CURSOR missing_order_name IS (
    SELECT DISTINCT wo_name FROM (
      (-- CIRC_PATH_INST join WORK_ORDER_INST
       SELECT woi.wo_name
         FROM circ_path_inst cpi,
              circ_path_inst next_cpi,
              work_order_inst woi,
              path_domain_map pdm,                -- to manage the 'Business Unit'
              domain_inst di
        WHERE cpi.circ_path_inst_id = woi.element_inst_id
          AND cpi.next_path_inst_id = next_cpi.circ_path_inst_id (+)
          AND next_cpi.circ_path_rev_nbr IS NULL
          AND pdm.circ_path_inst_id = cpi.circ_path_inst_id
          AND pdm.domain_inst_id = di.domain_inst_id
          AND DECODE(
                NVL(
                  (SELECT was.attr_value
                     FROM workorder_attr_settings was, val_attr_name van
                    WHERE was.workorder_inst_id = woi.wo_inst_id 
                      AND was.val_attr_inst_id = van.val_attr_inst_id
                      AND van.attr_name = 'Source Domain'),
                   di.domain_name),
                'Home', 'hbu__domain', di.domain_name) = 'hbu__domain'      -- Home BU
          AND woi.wo_name not like '%WO-%' 
          AND TO_CHAR(woi.start_after, 'YYYY') = submitted_date_year    -- check submit date
          AND SUBSTR(NVL((SELECT was.attr_value
                            FROM workorder_attr_settings was, val_attr_name van 
                           WHERE was.workorder_inst_id = woi.wo_inst_id 
                             AND was.val_attr_inst_id = van.val_attr_inst_id
                             AND van.attr_name = 'Order Type'),
                         SUBSTR(woi.wo_name, 1, 1)), 1, 3) = order_type      -- check order type
       UNION
         -- DEL_CIRC_PATH_INST join WORK_ORDER_INST
         SELECT woi.wo_name
           FROM del_circ_path_inst d_cpi,
                work_order_inst woi,
                path_domain_map pdm,              -- to manage the 'Business Unit'
                domain_inst di
          WHERE d_cpi.circ_path_inst_id = woi.element_inst_id
            AND d_cpi.next_path_inst_id IS NULL
            AND pdm.circ_path_inst_id = d_cpi.circ_path_inst_id
            AND pdm.domain_inst_id = di.domain_inst_id
            AND DECODE(
                  NVL(
                    (SELECT was.attr_value
                       FROM workorder_attr_settings was, val_attr_name van
                      WHERE was.workorder_inst_id = woi.wo_inst_id 
                        AND was.val_attr_inst_id = van.val_attr_inst_id
                        AND van.attr_name = 'Source Domain'),
                     di.domain_name),
                  'Home', 'hbu__domain', di.domain_name) = 'hbu__domain'      -- Home BU
            AND woi.wo_name not like '%WO-%' 
            AND TO_CHAR(woi.start_after, 'YYYY') = submitted_date_year  -- check submit date
            AND SUBSTR(NVL((SELECT was.attr_value
                              FROM workorder_attr_settings was, val_attr_name van 
                             WHERE was.workorder_inst_id = woi.wo_inst_id 
                               AND was.val_attr_inst_id = van.val_attr_inst_id
                               AND van.attr_name = 'Order Type'),
                           SUBSTR(woi.wo_name, 1, 1)), 1, 3) = order_type      -- check order type
       UNION
         -- CIRC_PATH_INST join DEL_WORK_ORDER_INST
         SELECT woi.wo_name
           FROM circ_path_inst cpi,
                circ_path_inst next_cpi,
                del_work_order_inst woi,
                path_domain_map pdm,              -- to manage the 'Business Unit'
                domain_inst di
          WHERE cpi.circ_path_inst_id = woi.element_inst_id
            AND cpi.next_path_inst_id = next_cpi.circ_path_inst_id (+)
            AND next_cpi.circ_path_rev_nbr IS NULL
            AND pdm.circ_path_inst_id = cpi.circ_path_inst_id
            AND pdm.domain_inst_id = di.domain_inst_id
            AND DECODE(
                  NVL(
                    (SELECT was.attr_value
                       FROM workorder_attr_settings was, val_attr_name van
                      WHERE was.workorder_inst_id = woi.wo_inst_id 
                        AND was.val_attr_inst_id = van.val_attr_inst_id
                        AND van.attr_name = 'Source Domain'),
                     di.domain_name),
                  'Home', 'hbu__domain', di.domain_name) = 'hbu__domain'      -- Home BU
            AND woi.wo_name not like '%WO-%' 
            AND TO_CHAR(woi.start_after, 'YYYY') = submitted_date_year    -- check submit date
            AND SUBSTR(NVL((SELECT was.attr_value
                              FROM workorder_attr_settings was, val_attr_name van 
                             WHERE was.workorder_inst_id = woi.wo_inst_id 
                               AND was.val_attr_inst_id = van.val_attr_inst_id
                               AND van.attr_name = 'Order Type'),
                           SUBSTR(woi.wo_name, 1, 1)), 1, 3) = order_type      -- check order type
       UNION
         -- DEL_CIRC_PATH_INST join DEL_WORK_ORDER_INST
         SELECT woi.wo_name
           FROM del_circ_path_inst d_cpi,
                del_work_order_inst woi,
                path_domain_map pdm,              -- to manage the 'Business Unit'
                domain_inst di
          WHERE d_cpi.circ_path_inst_id = woi.element_inst_id
            AND d_cpi.next_path_inst_id IS NULL
            AND pdm.circ_path_inst_id = d_cpi.circ_path_inst_id
            AND pdm.domain_inst_id = di.domain_inst_id
            AND DECODE(
                  NVL(
                    (SELECT was.attr_value
                       FROM workorder_attr_settings was, val_attr_name van
                      WHERE was.workorder_inst_id = woi.wo_inst_id 
                        AND was.val_attr_inst_id = van.val_attr_inst_id
                        AND van.attr_name = 'Source Domain'),
                     di.domain_name),
                  'Home', 'hbu__domain', di.domain_name) = 'hbu__domain'      -- Home BU
            AND woi.wo_name not like '%WO-%' 
            AND TO_CHAR(woi.start_after, 'YYYY') = submitted_date_year   -- check submit date
            AND SUBSTR(NVL((SELECT was.attr_value
                              FROM workorder_attr_settings was, val_attr_name van 
                             WHERE was.workorder_inst_id = woi.wo_inst_id 
                               AND was.val_attr_inst_id = van.val_attr_inst_id
                               AND van.attr_name = 'Order Type'),
                           SUBSTR(woi.wo_name, 1, 1)), 1, 3) = order_type      -- check order type
      )
      MINUS
      SELECT ordernumber wo_name
        FROM rmsh_cw.stc_order_message_home)
    );

  CURSOR missing_order_data(wo_name VARCHAR2) IS (
    SELECT DISTINCT order_status, circuit_status, parent_order_number
      FROM tmptable_granite_data_for_hbu
     WHERE order_number = wo_name
    );

BEGIN
  
  INSERT INTO rmsh_cw.cwprocesseventlog(event_id,                    transaction_id, avm_id, event_source, event_severity,    event_code,
                                        description,                                                
                                        event_time, user_id,                       metadata_ver, stack_trace)
                                 values(rmsh_cw.cwfEventSeq.nextval, 0,              0,      1,            3,              9995,
                                        'Running with ('||submitted_date_year||','||order_type||');', 
                                        sysdate,    'FILL_HBU_EXPD_ORDER_MISSING', 0,            null);
  
      
  DELETE expd_hbu_order_missing;
  
  DELETE tmptable_granite_data_for_hbu;
  
  INSERT INTO tmptable_granite_data_for_hbu
    SELECT * FROM stc_granite_data_for_hbu;
  
  COMMIT;

  count_rec    := 0;

  FOR i IN missing_order_name LOOP
    BEGIN

      count_rec := count_rec + 1;

      step := 0;
      
      FOR j IN missing_order_data(i.wo_name) LOOP
        BEGIN

          step := 1;

          IF(j.order_status NOT IN ('CANCELLED', 'COMPLETED')) THEN
            step := 2;

            INSERT INTO expd_hbu_order_missing
              SELECT circ_path_inst_id, circuit_number, circuit_status, customer, customer_name, customer_number, account_number, icms_so_number,
                     order_domain, order_number, order_type, order_status, nbr_tasks, project_id, cct_type, service_date, service_type, plate_id,
                     created_by, domain_name,  order_row_item_id, parent_order_number, service_number, task_name
                FROM tmptable_granite_data_for_hbu
               WHERE order_number = i.wo_name;
    
            step := 3;

          ELSIF(j.order_status = 'COMPLETED') THEN
          
            SELECT COUNT(*)
              INTO count_children
              FROM tmptable_granite_data_for_hbu
             WHERE parent_order_number = j.parent_order_number;
          
            IF(count_children = 1) THEN
              INSERT INTO expd_hbu_order_missing
                SELECT circ_path_inst_id, circuit_number, circuit_status, customer, customer_name, customer_number, account_number, icms_so_number,
                       order_domain, order_number, order_type, order_status, nbr_tasks, project_id, cct_type, service_date, service_type, plate_id,
                       created_by, domain_name,  order_row_item_id, parent_order_number, service_number, task_name
                  FROM tmptable_granite_data_for_hbu
                 WHERE order_number = i.wo_name;
            END IF;
          
          END IF;

          step := 4;
      
        END;
      END LOOP;

      step := 5;

    EXCEPTION
      WHEN others THEN
        error_msg := SUBSTR(sqlerrm, 1, 100);
        INSERT INTO rmsh_cw.cwprocesseventlog(event_id,                    transaction_id, avm_id, event_source, event_severity,    event_code, 
                                              description,                                                event_time, user_id,                   
                                              metadata_ver, stack_trace)
                                       values(rmsh_cw.cwfEventSeq.nextval, 0,              0,      1,            3,              9995,       
                                              'Error while managing order '||i.wo_name||' - step '||step, sysdate,    'FILL_HBU_EXPD_ORDER_MISSING', 
                                              0,            'Error while loading data for order '||i.wo_name||' - step '||step||': '||error_msg);

    END;
    
    IF(MOD(count_rec,100) = 0) THEN
      COMMIT;
    END IF;

  END LOOP;

  INSERT INTO rmsh_cw.cwprocesseventlog(event_id,                    transaction_id, avm_id, event_source, event_severity,    event_code,
                                        description,                                                
                                        event_time, user_id,                       metadata_ver, stack_trace)
                                 values(rmsh_cw.cwfEventSeq.nextval, 0,              0,      1,            3,              9995,
                                        'Completed Run with ('||submitted_date_year||','||order_type||');', 
                                        sysdate,    'FILL_HBU_EXPD_ORDER_MISSING', 0,            null);

  COMMIT;
  
END; 
 