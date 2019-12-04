CREATE TABLE stcw_info_all_services_new (
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
  ordertype            VARCHAR2(1),
  customer_site_a      VARCHAR2(100),
  region_site_a        VARCHAR2(40),
  latitude_site_a      VARCHAR2(20),
  longitude_site_a     VARCHAR2(20),
  customer_site_z      VARCHAR2(100),
  region_site_z        VARCHAR2(40),
  latitude_site_z      VARCHAR2(20),
  longitude_site_z     VARCHAR2(20)
) TABLESPACE CWW;

