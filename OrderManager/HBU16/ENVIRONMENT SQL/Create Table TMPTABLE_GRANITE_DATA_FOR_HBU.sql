DROP TABLE tmptable_granite_data_for_hbu;
CREATE TABLE tmptable_granite_data_for_hbu (
  circ_path_inst_id   NUMBER(9),
  circuit_number      VARCHAR2(100),
  circuit_status      VARCHAR2(20),
  customer            VARCHAR2(50),
  customer_name       VARCHAR2(60),
  customer_number     VARCHAR2(50),
  account_number      VARCHAR2(3100),
  icms_so_number      VARCHAR2(3100),
  order_domain        VARCHAR2(4),
  order_number        VARCHAR2(20),
  order_type          VARCHAR2(25),
  order_status        VARCHAR2(20),
  nbr_tasks           NUMBER(3),
  project_id          VARCHAR2(50),
  cct_type            VARCHAR2(30),
  service_date        VARCHAR2(10),
  service_type        VARCHAR2(255),
  plate_id            VARCHAR2(100),
  created_by          VARCHAR2(3100),
  domain_name         VARCHAR2(30),
  order_row_item_id   CHAR(2),
  parent_order_number VARCHAR2(3100),
  submitted_date_year VARCHAR2(4),
  service_number      VARCHAR2(50),
  task_name           VARCHAR2(60)
);

CREATE INDEX idx_granite_data_hbu_ordnum ON tmptable_granite_data_for_hbu (order_number);
CREATE INDEX idx_granite_data_hbu_parordnum ON tmptable_granite_data_for_hbu (parent_order_number);
