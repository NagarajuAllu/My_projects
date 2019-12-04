set serveroutput on

DECLARE

  CURSOR row_rawdata IS 
    SELECT *
      FROM stc_service_migration_rawdata
     WHERE analyzed = 0;

  errorCode     stc_service_migration.migration_result%TYPE;
  errorMsg      stc_service_migration.failure_description%TYPE;
  countRecords  NUMBER(5);
  posix         NUMBER(5);
  tempValue     stc_service_migration_rawdata.circuit_name%TYPE;
  counter       NUMBER(4);

BEGIN

  DBMS_OUTPUT.ENABLE(NULL);

  counter :=  1;
  
  FOR x IN row_rawdata LOOP
    BEGIN
      errorCode := null;
      errorMsg  := null;
      
      
      -- checking mandatory fields; errorCode = -10
      IF(x.customer_id IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Customer Id IS NULL';
      ELSIF(x.customer_account_number IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Customer Account Number IS NULL';
      ELSIF(x.circuit_name IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Circuit Name IS NULL';
      ELSIF(x.fictitious_billing_number IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Access Number IS NULL';
      ELSIF(x.a_side_clli IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Site A IS NULL';
      ELSIF(x.z_side_clli IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Site Z IS NULL';
      ELSIF(x.circuit_category IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Circuit Category IS NULL';
      ELSIF(x.bandwidth IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'bandwidth IS NULL';
      ELSIF(x.asset_status IS NULL) THEN
        errorCode := -10;
        errorMsg  := 'Asset Status IS NULL';
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking mandatory fields for serviceType; errorCode = -11
        IF(x.circuit_category = 'DSLSKY') THEN
          IF(x.rtn_circuit_speed IS NULL) THEN
            errorCode := -11;
            errorMsg  := 'DSLSKY # RTN Circuit Speed IS NULL';
          END IF;
        ELSIF(x.circuit_category = 'MVPN') THEN
          IF(x.msisdn IS NULL) THEN
            errorCode := -11;
            errorMsg  := 'MVPN # MSISDN IS NULL';
          ELSIF(x.mvpn_speed IS NULL) THEN
            errorCode := -11;
            errorMsg  := 'MVPN # MVPN Speed IS NULL';
          ELSIF(x.sim_number IS NULL) THEN
            errorCode := -11;
            errorMsg  := 'MVPN # SIM Number IS NULL';
          ELSIF(x.mvpn_access_type IS NULL) THEN
            errorCode := -11;
            errorMsg  := 'MVPN # MVPN Access Type IS NULL';
          END IF;
        END IF;
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking uniqueness of the path in Granite; errorCode = -12
        SELECT COUNT(*)
          INTO countRecords
          FROM circ_path_inst@rms_prod_db_link
         WHERE circ_path_hum_id = x.circuit_name;
      
        IF(countRecords <> 0) THEN
          errorCode := -12;
          errorMsg  := 'Path already exists in Granite; found '||countRecords||' records';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking uniqueness of the path in the archive in Granite; errorCode = -13
        SELECT COUNT(*)
          INTO countRecords
          FROM del_circ_path_inst@rms_prod_db_link
         WHERE circ_path_hum_id = x.circuit_name;
      
        IF(countRecords <> 0) THEN
          errorCode := -13;
          errorMsg  := 'Path already exists in archive in Granite; found '||countRecords||' records';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking customer is in Granite; errorCode = -14
        SELECT COUNT(*)
          INTO countRecords
          FROM val_customer@rms_prod_db_link
         WHERE customer_id = x.customer_id;
      
        IF(countRecords = 0) THEN
          errorCode := -14;
          errorMsg  := 'Customer does not exist in Granite';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking site_a is in Granite; errorCode = -15
        SELECT COUNT(*)
          INTO countRecords
          FROM site_inst@rms_prod_db_link
         WHERE site_hum_id = x.a_side_clli;
      
        IF(countRecords = 0) THEN
          errorCode := -15;
          errorMsg  := 'Site A not exist in Granite';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking site_z is in Granite; errorCode = -15
        SELECT COUNT(*)
          INTO countRecords
          FROM site_inst@rms_prod_db_link
         WHERE site_hum_id = x.z_side_clli;
      
        IF(countRecords = 0) THEN
          errorCode := -15;
          errorMsg  := 'Site Z not exist in Granite';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking status is in Granite; errorCode = -16
        IF(UPPER(x.asset_status) <> 'ACTIVE') THEN
          errorCode := -16;
          errorMsg  := 'Asset is not Active';
        END IF;  
      END IF;
      
      IF(errorCode IS NULL) THEN
        -- checking path name should end with path_category then a number; errorCode = -17 & -18
        posix := INSTR(x.circuit_name, x.circuit_category);
        
        IF(posix <= 0) THEN
          errorCode := -17;
          errorMsg  := 'Path name does not contain the path category';
        ELSE 
          tempValue := SUBSTR(x.circuit_name, posix + LENGTH(x.circuit_category));
          IF(NOT (regexp_like(tempValue, '^[0-9]'))) THEN
            errorCode := -18;
            errorMsg  := 'Path name contains the path category but does not end with a number'''||tempValue||'''';
          END IF;
        END IF;  
      END IF;

      IF(errorCode IS NULL) THEN
        -- checking uniqueness of the path in stc_service_migration; errorCode = -19
        SELECT COUNT(*)
          INTO countRecords
          FROM stc_service_migration
         WHERE path_name = x.circuit_name;
      
        IF(countRecords <> 0) THEN
          errorCode := -19;
          errorMsg  := 'Path name already exists in STC_SERVICE_MIGRATION; found '||countRecords||' records';
        END IF;  
      END IF;

      INSERT INTO stc_service_migration(customer_number, 
                                        customer_name, 
                                        account_number, 
                                        path_name, 
                                        ecnm_migration, 
                                        access_number, 
                                        mvpn_mobile_number, 
                                        msisdn, 
                                        asset_status, 
                                        site_a, 
                                        site_b, 
                                        circuit_category, 
                                        bandwidth, 
                                        mvpn_speed, 
                                        sim_number, 
                                        mvpn_access_type, 
                                        imsi_number, 
                                        registration_id, 
                                        asset_created, 
                                        rtn_circuit_speed, 
                                        function_code, 
                                        order_number, 
                                        migration_result, 
                                        failure_description)
                                VALUES (x.customer_id, 
                                        x.customer_name, 
                                        x.customer_account_number, 
                                        x.circuit_name, 
                                        x.ecnm_migration, 
                                        x.fictitious_billing_number, 
                                        x.mvpn_mobile_number, 
                                        x.msisdn, 
                                        x.asset_status, 
                                        x.a_side_clli, 
                                        x.z_side_clli, 
                                        x.circuit_category, 
                                        x.bandwidth, 
                                        x.mvpn_speed, 
                                        x.sim_number, 
                                        x.mvpn_access_type, 
                                        x.imsi_number, 
                                        x.registration_id, 
                                        x.asset_created, 
                                        x.rtn_circuit_speed,
                                        NULL, -- function code
                                        'I_MIGR'||LPAD(counter, 4, '0'), -- order number
                                        NVL(errorCode, 0),
                                        errorMsg);

      UPDATE stc_service_migration_rawdata
         SET analyzed = 1
       WHERE recNum = x.recNum;
    
      counter := counter+1;
      
    EXCEPTION
      WHEN others THEN
        errorMsg := SUBSTR(sqlerrm, 1, 1000);
        dbms_output.put_line('Unexpected error while analyzing row with id '||x.recNum||'; error = '||errorMsg);
    END;
  END LOOP;
END;

/