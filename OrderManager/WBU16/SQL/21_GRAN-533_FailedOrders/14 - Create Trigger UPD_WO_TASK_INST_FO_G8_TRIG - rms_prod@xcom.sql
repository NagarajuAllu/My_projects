CREATE OR REPLACE TRIGGER upd_wo_task_inst_fo_g8_trig
  BEFORE UPDATE
  ON wo_task_inst
  FOR EACH ROW
DECLARE

  parent_wo_inst_id      work_order_inst.wo_inst_id%TYPE;
  parent_wo_elm_type     work_order_inst.element_type%TYPE;
  parent_wo_elm_inst_id  work_order_inst.element_inst_id%TYPE;
  som_domain_uda         circ_path_attr_settings.attr_value%TYPE;

  add_case               char(1);
  del_case               char(1);
BEGIN

  add_case := 'N';
  del_case := 'N';

  IF(-- REJECT_FTTH_ORDER updated to READY status; add to table
     (:new.task_operation = 'REJECT_FTTH_ORDER' AND :new.status_code = 4 AND :old.status_code <> 4) OR
     -- generic task updated to FAILED status; add to table
     (:new.status_code = 9 AND :old.status_code <> 9)) THEN
    add_case := 'Y';
    del_case := 'N';
  ELSIF(
        -- REJECT_FTTH_ORDER left READY status; remove from table
        (:new.task_operation = 'REJECT_FTTH_ORDER' AND :new.status_code <> 4 AND :old.status_code = 4) OR
        -- generic task left FAILED status; remove from table
        (:new.status_code <> 9 AND :old.status_code = 9))THEN
    add_case := 'N';
    del_case := 'Y';
  END IF;

  IF(add_case = 'Y' OR del_case = 'Y') THEN
    BEGIN
      SELECT wo_inst_id, element_type, element_inst_id
        INTO parent_wo_inst_id, parent_wo_elm_type, parent_wo_elm_inst_id
        FROM work_order_inst
       WHERE wo_inst_id = :new.wo_inst_id;

      IF (parent_wo_inst_id IS NOT NULL AND parent_wo_elm_type = 'P') THEN
        --
        --  Check the value for SOM_DOMAIN; acceptable value = 'WHOLESALE_G8'
        --
        SELECT attr_value
          INTO som_domain_uda
          FROM circ_path_attr_settings cpas, val_attr_name van
         WHERE cpas.circ_path_inst_id = parent_wo_elm_inst_id
           AND cpas.val_attr_inst_id = van.val_attr_inst_id
           AND van.attr_name = 'SOM_DOMAIN'
           AND van.group_name = 'Circuit Details';

        IF (som_domain_uda = 'WHOLESALE_G8') THEN
          --
          -- It's a valid case for G8
          --
          IF(add_case = 'Y') THEN
            INSERT INTO STC_G8_FAILED_ORDERS(task_inst_id) values (:new.task_inst_id);
          ELSIF(del_case = 'Y') THEN
            DELETE FROM STC_G8_FAILED_ORDERS WHERE task_inst_id = :new.task_inst_id;
          END IF;

        END IF;
      END IF;

    EXCEPTION
      WHEN others THEN
        NULL;
    END;
  END IF;
END;
/