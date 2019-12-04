CREATE TABLE stcw_info_all_services (
  service_number       VARCHAR2(255),
  wo_number            VARCHAR2(20),
  wo_status            VARCHAR2(25),
  service_status_eoc   VARCHAR2(25),
  service_status_gi    VARCHAR2(25),
  system_designation   VARCHAR2(1000),
  ni_number            VARCHAR2(1000),
  reservation_number   VARCHAR2(255),
  service_type         VARCHAR2(25),
  product_type         VARCHAR2(255),
  provisioning_flag    VARCHAR2(12),
  serv_completion_date DATE,
  lineitemtype         VARCHAR2(10),
  ordernumber          VARCHAR2(50),
  ordertype            VARCHAR2(1),
  ord_completion_date  DATE,
  is_migrated          NUMBER(1)
) TABLESPACE CWW;
  