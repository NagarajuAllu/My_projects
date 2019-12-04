CREATE INDEX idx_order_msg_cworderid ON stc_order_message(cworderid) TABLESPACE cwe_ndx;
CREATE INDEX idx_serv_params_cworderid ON stc_service_parameters(cworderid) TABLESPACE cwe_ndx;
