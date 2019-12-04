column msg format a90
set lines 132
set pages 1000

select to_char(when, 'dd/mm/yyyy hh24:mi:ss') when, substr(msg, 1, 90) msg from LOG_HOUSEKEEPING order by 1;

select count(*) from cwh_orderitems_hk where processed is null;

select count(1) from (
      SELECT DISTINCT i.cwdocid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME'
       MINUS
      SELECT DISTINCT c.cworderid
        FROM stc_order_message_home c
);


select count(1) from (
      SELECT DISTINCT c.cworderid
        FROM stc_order_message_home c
      MINUS
      SELECT DISTINCT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME'
);

select count(1) from (
      SELECT DISTINCT c.cworderid
        FROM stc_service_parameters_home c
      MINUS
      SELECT DISTINCT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME'
);

select count(1) from (
      SELECT DISTINCT c.cworderid
        FROM stc_name_value c
      MINUS
      SELECT DISTINCT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename in ('ds_ws:default_orderSTC_HOME', 'ds_ws:default_orderSTC')
);

select count(1) from (
      SELECT DISTINCT c.cworderid
        FROM stc_order_ack c
      MINUS
      SELECT DISTINCT i.cwdocid cworderid
        FROM cworderinstance i, cwmdtypes t
       WHERE i.metadatatype = t.typeid
         AND t.typename = 'ds_ws:default_orderSTC_HOME'
);