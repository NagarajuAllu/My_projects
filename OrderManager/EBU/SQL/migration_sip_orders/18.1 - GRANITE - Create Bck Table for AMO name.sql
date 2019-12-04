CREATE TABLE stc_granite_bck_amo_name (
  amo_inst_id NUMBER(16) NOT NULL,
  old_amo_name VARCHAR2(255) NOT NULL,
  new_amo_name VARCHAR2(255) NOT NULL,
  uda_identifier NUMBER(10),
  old_uda_value VARCHAR2(255),
  new_uda_value VARCHAR2(255));
