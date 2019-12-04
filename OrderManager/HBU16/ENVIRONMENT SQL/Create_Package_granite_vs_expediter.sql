CREATE OR REPLACE PACKAGE GRANITE_VS_EXPEDITER IS

  row_counter NUMBER :=1;

  PROCEDURE check_orattr_exp_vs_gr(order_number IN VARCHAR2, step IN VARCHAR2, granite_attribute IN VARCHAR2, expediter_attribute IN VARCHAR2, is_parent IN BOOLEAN, error_level IN VARCHAR2);

  PROCEDURE check_servattr_exp_vs_gr(order_number IN VARCHAR2, service_indx IN NUMBER, step IN VARCHAR2, granite_attribute IN VARCHAR2, expediter_attribute IN VARCHAR2, is_parent IN BOOLEAN, error_level IN VARCHAR2);
 
  PROCEDURE print_record(error_level IN VARCHAR2, data IN VARCHAR2);
    
  PROCEDURE compare_orders_expd_vs_gr(input_submitted_date_year IN VARCHAR2, input_order_type IN VARCHAR2);


END GRANITE_VS_EXPEDITER;
