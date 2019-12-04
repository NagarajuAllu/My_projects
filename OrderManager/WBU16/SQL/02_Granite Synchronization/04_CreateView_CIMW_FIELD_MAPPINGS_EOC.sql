create or replace view field_mappings_eoc as
select to_char(id) id, order_type, object_type, object_category, dbms_lob.substr(fm.source, 2000, 1) source,
       dbms_lob.substr(fm.target, 2000, 1) target, dbms_lob.substr(fm.default_value, 2000, 1) default_value, path_exists
  from cimw.field_mappings fm;
