CREATE TABLE stcw_info_all_services (
  lineitem_identifier  VARCHAR2(255),
  service_number       VARCHAR2(255),
  wo_number            VARCHAR2(20),
  wo_status            VARCHAR2(25),
  service_status_gi    VARCHAR2(25),
  service_type         VARCHAR2(25),
  product_type         VARCHAR2(255),
  serv_completion_date DATE,
  lineitem_type        VARCHAR2(10),
  ordernumber          VARCHAR2(50),
  ordertype            VARCHAR2(1)
) TABLESPACE CWW;


CREATE TABLE stcw_info_old_services (
  lineitem_identifier  VARCHAR2(255),
  service_number       VARCHAR2(255),
  wo_number            VARCHAR2(20),
  wo_status            VARCHAR2(25),
  service_status_gi    VARCHAR2(25),
  service_type         VARCHAR2(25),
  product_type         VARCHAR2(255),
  serv_completion_date DATE,
  lineitem_type        VARCHAR2(10),
  ordernumber          VARCHAR2(50),
  ordertype            VARCHAR2(1)
) TABLESPACE CWW;
