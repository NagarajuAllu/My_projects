-- THIS ONE HAS TO BE EXECUTED AS RMS_PROD USER

DECLARE

  CURSOR granite_bck_amo_cursor IS
    SELECT *
      FROM stc_granite_bck_amo_name;

  rollback_total   NUMBER(10);
  rollback_success NUMBER(10);
  rollback_error   NUMBER(10);

  error_msg        VARCHAR2(100);
  
BEGIN

  rollback_total := 0;
  rollback_success := 0;
  rollback_error := 0;

  FOR amo_bck_cur IN granite_bck_amo_cursor LOOP
    BEGIN

      rollback_total := rollback_total + 1;
      
      UPDATE resource_inst
         SET name = amo_bck_cur.old_amo_name
       WHERE resource_inst_id = amo_bck_cur.amo_inst_id;
      
      IF(amo_bck_cur.new_uda_value IS NOT NULL) THEN
        -- new value is not null, so it means that the procedure updated/created the UDA
        
        IF(amo_bck_cur.old_uda_value IS NOT NULL) THEN
          -- old value is not null, so it means that the procedure updated the UDA
        
          UPDATE resource_attr_settings ras
             SET ras.attr_value = amo_bck_cur.old_uda_value
           WHERE ras.resource_inst_id = amo_bck_cur.amo_inst_id
             AND ras.val_attr_inst_id = amo_bck_cur.uda_identifier;

        ELSE
          -- old value is null, so it means that the procedure created the UDA

          DELETE FROM resource_attr_settings ras
           WHERE ras.resource_inst_id = amo_bck_cur.amo_inst_id
             AND ras.val_attr_inst_id = amo_bck_cur.uda_identifier;

        END IF;
      
      END IF;
      
      rollback_success := rollback_success + 1;

    EXCEPTION
      WHEN others THEN
        error_msg := SUBSTR(sqlerrm, 1, 100);
DBMS_OUTPUT.PUT_LINE('  >>>> Error while processing record for AMO ['||amo_bck_cur.amo_inst_id||']: '||error_msg);
        migrated_error := migrated_error + 1;
    END;
  END LOOP;

DBMS_OUTPUT.PUT_LINE('Rollback completed');
DBMS_OUTPUT.PUT_LINE('  Total:  '||LPAD(migrated_total, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Success:'||LPAD(migrated_success, 5, ' '));
DBMS_OUTPUT.PUT_LINE('  Error:  '||LPAD(migrated_error, 5, ' '));


END;
/
