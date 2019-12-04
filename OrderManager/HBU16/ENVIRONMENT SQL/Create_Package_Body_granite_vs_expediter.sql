CREATE OR REPLACE PACKAGE BODY GRANITE_VS_EXPEDITER IS

  PROCEDURE check_orattr_exp_vs_gr(order_number IN VARCHAR2, step IN VARCHAR2, granite_attribute IN VARCHAR2, expediter_attribute IN VARCHAR2, is_parent IN BOOLEAN, error_level IN VARCHAR2) IS
    result_msg VARCHAR2(1000);
  BEGIN
    result_msg := NULL;
    
    IF(granite_attribute IS NULL) THEN
      IF(expediter_attribute IS NOT NULL) THEN
        result_msg := 'DIFFERENT: Granite IS NULL, Expediter ['||expediter_attribute||']';
      END IF;
    ELSIF(expediter_attribute IS NULL) THEN
      result_msg := 'DIFFERENT: Granite ['||granite_attribute||'], Expediter IS NULL';
    ELSIF(expediter_attribute <> granite_attribute) THEN
      result_msg := 'DIFFERENT: Granite ['||granite_attribute||'], Expediter ['||expediter_attribute||']';
    END IF;
    
    IF(result_msg IS NOT NULL) THEN
      IF(is_parent) THEN
        print_record(error_level, 'ParentOrder ['||order_number||'] - '||step||' '||result_msg);
      ELSE
        print_record(error_level, 'Order ['||order_number||'] - '||step||' '||result_msg);
      END IF;
    END IF;
    
  END;

  PROCEDURE check_servattr_exp_vs_gr(order_number IN VARCHAR2, service_indx IN NUMBER, step IN VARCHAR2, granite_attribute IN VARCHAR2, expediter_attribute IN VARCHAR2, is_parent IN BOOLEAN, error_level IN VARCHAR2) IS
    result_msg VARCHAR2(1000);
  BEGIN
    result_msg := NULL;

    IF(granite_attribute IS NULL) THEN
      IF(expediter_attribute IS NOT NULL) THEN
        result_msg := 'DIFFERENT: Granite IS NULL, Expediter ['||expediter_attribute||']';
      END IF;
    ELSIF(expediter_attribute IS NULL) THEN
      result_msg := 'DIFFERENT: Granite ['||granite_attribute||'], Expediter IS NULL';
    ELSIF(expediter_attribute <> granite_attribute) THEN
      result_msg := 'DIFFERENT: Granite ['||granite_attribute||'], Expediter ['||expediter_attribute||']';
    END IF;

    IF(result_msg IS NOT NULL) THEN
      IF(is_parent) THEN
        print_record(error_level, 'ParentOrder ['||order_number||']['||service_indx||'] - '||step||' '||result_msg);
      ELSE 
        print_record(error_level, 'Order ['||order_number||']['||service_indx||'] - '||step||' '||result_msg);
      END IF;
    END IF;
  END;
  
  PROCEDURE print_record(error_level IN VARCHAR2, data IN VARCHAR2) IS
  BEGIN
--    dbms_output.put_line(data);
    IF(error_level IS NOT NULL) THEN
      INSERT INTO compare_orders_expd_vs_gr_log VALUES (row_counter, error_level, data);
      COMMIT;
      row_counter := row_counter + 1;
    END IF;
  END;
  
  PROCEDURE compare_orders_expd_vs_gr(input_submitted_date_year IN VARCHAR2, input_order_type IN VARCHAR2) IS

    error_msg                 VARCHAR2(100);
    step                      VARCHAR2(40);
    counter_service           NUMBER(4);

    -- GRANITE ATTRIBUTES
    gr_account_number         stc_granite_data_for_hbu.account_number%TYPE;
    gr_cct_type               stc_granite_data_for_hbu.cct_type%TYPE;
    gr_circuit_number         stc_granite_data_for_hbu.circuit_number%TYPE;
    gr_created_by             stc_granite_data_for_hbu.created_by%TYPE;
    gr_customer               stc_granite_data_for_hbu.customer%TYPE;
    gr_customer_name          stc_granite_data_for_hbu.customer_name%TYPE;
    gr_customer_number        stc_granite_data_for_hbu.customer_number%TYPE;
    gr_icms_so_number         stc_granite_data_for_hbu.icms_so_number%TYPE;
    gr_order_status           stc_granite_data_for_hbu.order_status%TYPE;
    gr_order_type             stc_granite_data_for_hbu.order_type%TYPE;
    gr_project_id             stc_granite_data_for_hbu.project_id%TYPE;
    gr_circuit_status         stc_granite_data_for_hbu.circuit_status%TYPE;
    gr_order_domain           stc_granite_data_for_hbu.order_domain%TYPE;
    gr_service_date           stc_granite_data_for_hbu.service_date%TYPE;
    gr_parent_order_number    stc_granite_data_for_hbu.parent_order_number%TYPE;
    gr_plate_id               stc_granite_data_for_hbu.plate_id%TYPE;
    gr_service_number         stc_granite_data_for_hbu.service_number%TYPE;
    gr_service_type           stc_granite_data_for_hbu.service_type%TYPE;

    -- EXPEDITER ATTRIBUTES
    ex_account_number         rmsh_cw.stc_order_message_home.accountnumber%TYPE;
    ex_cct_type               rmsh_cw.stc_order_message_home.ccttype%TYPE;
    ex_circuit_number         rmsh_cw.stc_order_message_home.circuitnumber%TYPE;
    ex_created_by             rmsh_cw.stc_order_message_home.createdby%TYPE;
    ex_customer               rmsh_cw.stc_order_message_home.customeridnumber%TYPE;
    ex_customer_name          rmsh_cw.stc_order_message_home.customername%TYPE;
    ex_customer_number        rmsh_cw.stc_order_message_home.customernumber%TYPE;
    ex_icms_so_number         rmsh_cw.stc_order_message_home.icmssonumber%TYPE;
    ex_order_status           rmsh_cw.stc_order_message_home.orderstatus%TYPE;
    ex_order_type             rmsh_cw.stc_order_message_home.ordertype%TYPE;
    ex_project_id             rmsh_cw.stc_order_message_home.projectid%TYPE;
    ex_circuit_status         rmsh_cw.stc_order_message_home.circuitstatus%TYPE;
    ex_order_domain           rmsh_cw.stc_order_message_home.orderdomain%TYPE;
    ex_parent_order_number    rmsh_cw.stc_order_message_home.parentordernumber%TYPE;
    ex_service_date           varchar2(10);
    ex_plate_id               rmsh_cw.stc_service_parameters_home.plateid%TYPE;
    ex_service_number         rmsh_cw.stc_service_parameters_home.servicenumber%TYPE;

    CURSOR found_orders_name_in_granite IS (
      SELECT gd.order_number, gd.service_number, gd.service_type
        FROM stc_granite_data_for_hbu gd, rmsh_cw.stc_order_message_home omh
       WHERE gd.order_number = omh.ordernumber
         AND gd.submitted_date_year = input_submitted_date_year
         AND gd.order_type = input_order_type
         AND omh.orderstatus NOT IN ('CANCELLED', 'COMPLETED')
    );

    CURSOR found_services_data(order_number IN VARCHAR2, service_number IN VARCHAR2, service_type IN VARCHAR2) IS
      SELECT sph.servicetype, sph.plateid, sph.servicenumber
        FROM rmsh_cw.stc_order_message_home omh, rmsh_cw.stc_service_parameters_home sph
       WHERE omh.ordernumber = order_number
         AND sph.servicetype = service_type
         AND sph.servicenumber = service_number
         AND sph.cworderid = omh.cworderid;

  BEGIN
    
    dbms_output.enable(100000000000);

    FOR i IN found_orders_name_in_granite LOOP
      BEGIN

        print_record(null, '==============================================');
        
        -- Comparing Order Data
        SELECT account_number, cct_type, circuit_number, created_by, customer, customer_name, customer_number, icms_so_number,
               order_status, order_type, project_id, circuit_status, order_domain, service_date, plate_id, service_number, 
               service_type, parent_order_number
          INTO gr_account_number, gr_cct_type, gr_circuit_number, gr_created_by, gr_customer, gr_customer_name, gr_customer_number, gr_icms_so_number,
               gr_order_status, gr_order_type, gr_project_id, gr_circuit_status, gr_order_domain, gr_service_date, gr_plate_id, gr_service_number, 
               gr_service_type, gr_parent_order_number
          FROM stc_granite_data_for_hbu
         WHERE order_number = i.order_number
           AND service_number = i.service_number
           AND service_type = i.service_type
           AND submitted_date_year = input_submitted_date_year
           AND order_type = input_order_type;

        SELECT accountnumber, ccttype, circuitnumber, createdby, customeridnumber, customername, customernumber, icmssonumber,
               orderstatus, ordertype, projectid, circuitstatus, orderdomain, to_char(servicedate, 'dd/mm/yyyy'), commonplateid, commonservicenumber, 
               parentordernumber
          INTO ex_account_number, ex_cct_type, ex_circuit_number, ex_created_by, ex_customer, ex_customer_name, ex_customer_number, ex_icms_so_number,
               ex_order_status, ex_order_type, ex_project_id, ex_circuit_status, ex_order_domain, ex_service_date, ex_plate_id, ex_service_number, 
               ex_parent_order_number
          FROM rmsh_cw.stc_order_message_home
         WHERE ordernumber = i.order_number
           AND ordertype = input_order_type;


        step := 'Account Number';
        check_orattr_exp_vs_gr(i.order_number, step, gr_account_number, ex_account_number, false, 'ERROR');         

        step := 'CCT Type';
        check_orattr_exp_vs_gr(i.order_number, step, gr_cct_type, ex_cct_type, false, 'ERROR');

        step := 'Circuit Number';
        check_orattr_exp_vs_gr(i.order_number, step, gr_circuit_number, ex_circuit_number, false, 'ERROR');

        step := 'Created By';
        check_orattr_exp_vs_gr(i.order_number, step, gr_created_by, ex_created_by, false, 'WARN');

        step := 'Customer';
        check_orattr_exp_vs_gr(i.order_number, step, gr_customer, ex_customer, false, 'ERROR');

        step := 'Customer Name';
        check_orattr_exp_vs_gr(i.order_number, step, gr_customer_name, ex_customer_name, false, 'WARN');

        step := 'Customer Number';
        check_orattr_exp_vs_gr(i.order_number, step, gr_customer_number, ex_customer_number, false, 'WARN');

        step := 'ICMS SO Number';
        check_orattr_exp_vs_gr(i.order_number, step, gr_icms_so_number, ex_icms_so_number, false, 'ERROR');

        step := 'Order Status';
        check_orattr_exp_vs_gr(i.order_number, step, gr_order_status, ex_order_status, false, 'ERROR');

        step := 'Order Type';
        check_orattr_exp_vs_gr(i.order_number, step, gr_order_type, ex_order_type, false, 'ERROR');

        step := 'Project ID';
        check_orattr_exp_vs_gr(i.order_number, step, gr_project_id, ex_project_id, false, 'WARN');

        step := 'Circuit Status';
        check_orattr_exp_vs_gr(i.order_number, step, gr_circuit_status, ex_circuit_status, false, 'ERROR');

        step := 'Order Domain';
        check_orattr_exp_vs_gr(i.order_number, step, gr_order_domain, ex_order_domain, false, 'ERROR');

        step := 'Service Date';
        check_orattr_exp_vs_gr(i.order_number, step, gr_service_date, ex_service_date, false, 'WARN');

        step := 'Parent Order Number';
        check_orattr_exp_vs_gr(i.order_number, step, gr_parent_order_number, ex_parent_order_number, false, 'ERROR');

        counter_service := 0;
        FOR k IN found_services_data(i.order_number, i.service_number, i.service_type) LOOP
          BEGIN

            step := 'Service Type';
            check_servattr_exp_vs_gr(i.order_number, counter_service, step, gr_service_type, k.servicetype, false, 'ERROR');

            step := 'Plate ID';
            check_servattr_exp_vs_gr(i.order_number, counter_service, step, gr_plate_id, k.plateid, false, 'ERROR');

            step := 'Service Number';
            check_servattr_exp_vs_gr(i.order_number, counter_service, step, gr_service_number, k.servicenumber, false, 'ERROR');

          EXCEPTION
            WHEN others THEN
              error_msg := SUBSTR(sqlerrm, 1, 100);
              dbms_output.put_line('Error while comparing service['||counter_service||'] for order '||i.order_number||' - step '||step||': '||error_msg);

          END;

          counter_service := counter_service + 1;
        END LOOP;

        print_record(null, '----------------------------------------------');
        -- Comparing Parent Order Data
        IF(gr_parent_order_number IS NOT NULL AND ex_parent_order_number IS NOT NULL AND gr_parent_order_number = ex_parent_order_number) THEN
        
          SELECT accountnumber, ccttype, circuitnumber, createdby, customeridnumber, customername, customernumber, icmssonumber,
                 orderstatus, ordertype, projectid, circuitstatus, orderdomain, to_char(servicedate, 'dd/mm/yyyy'), commonplateid, commonservicenumber
            INTO ex_account_number, ex_cct_type, ex_circuit_number, ex_created_by, ex_customer, ex_customer_name, ex_customer_number, ex_icms_so_number,
                 ex_order_status, ex_order_type, ex_project_id, ex_circuit_status, ex_order_domain, ex_service_date, ex_plate_id, ex_service_number
            FROM rmsh_cw.stc_order_message_home
           WHERE ordernumber = ex_parent_order_number
             AND ordertype = input_order_type
             AND parentordernumber IS NULL;


          step := 'Account Number';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_account_number, ex_account_number, true, 'ERROR');

          step := 'CCT Type';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_cct_type, ex_cct_type, true, 'ERROR');

          step := 'Circuit Number';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_circuit_number, ex_circuit_number, true, 'ERROR');

          step := 'Created By';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_created_by, ex_created_by, true, 'WARN');

          step := 'Customer';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_customer, ex_customer, true, 'ERROR');

          step := 'Customer Name';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_customer_name, ex_customer_name, true, 'WARN');

          step := 'Customer Number';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_customer_number, ex_customer_number, true, 'WARN');

          step := 'ICMS SO Number';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_icms_so_number, ex_icms_so_number, true, 'ERROR');

          step := 'Order Status';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_order_status, ex_order_status, true, 'ERROR');

          step := 'Order Type';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_order_type, ex_order_type, true, 'ERROR');

          step := 'Project ID';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_project_id, ex_project_id, true, 'WARN');

          step := 'Circuit Status';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_circuit_status, ex_circuit_status, true, 'ERROR');

          step := 'Order Domain';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_order_domain, ex_order_domain, true, 'ERROR');

          step := 'Service Date';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_service_date, ex_service_date, true, 'WARN');

          step := 'Parent Order Number';
          check_orattr_exp_vs_gr(ex_parent_order_number, step, gr_parent_order_number, ex_parent_order_number, true, 'WARN');

          counter_service := 0;
          FOR k IN found_services_data(ex_parent_order_number, i.service_number, i.service_type) LOOP
            BEGIN

              step := 'Service Type';
              check_servattr_exp_vs_gr(ex_parent_order_number, counter_service, step, gr_service_type, k.servicetype, true, 'ERROR');

              step := 'Plate ID';
              check_servattr_exp_vs_gr(ex_parent_order_number, counter_service, step, gr_plate_id, k.plateid, true, 'ERROR');

              step := 'Service Number';
              check_servattr_exp_vs_gr(ex_parent_order_number, counter_service, step, gr_service_number, k.servicenumber, true, 'ERROR');

            EXCEPTION
              WHEN others THEN
                error_msg := SUBSTR(sqlerrm, 1, 100);
                dbms_output.put_line('Error while comparing service['||counter_service||'] for ParentOrder '||ex_parent_order_number||' - step '||step||': '||error_msg);

            END;

            counter_service := counter_service + 1;
          END LOOP;
        END IF; -- end Parent Order Data

      EXCEPTION
        WHEN others THEN
          error_msg := SUBSTR(sqlerrm, 1, 100);
          dbms_output.put_line('Error while comparing order '||i.order_number||' - step '||step||': '||error_msg);

      END;
    END LOOP;

  END;


END GRANITE_VS_EXPEDITER; 
