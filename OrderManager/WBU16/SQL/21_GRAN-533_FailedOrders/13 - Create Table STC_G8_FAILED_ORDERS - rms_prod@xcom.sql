
DROP TABLE stc_g8_failed_orders;

-- Create table
CREATE TABLE stc_g8_failed_orders (
  task_inst_id  NUMBER(10) not null);

ALTER TABLE stc_g8_failed_orders
  ADD CONSTRAINT pk_stc_g8_failed_orders PRIMARY KEY (task_inst_id)
  USING INDEX;

