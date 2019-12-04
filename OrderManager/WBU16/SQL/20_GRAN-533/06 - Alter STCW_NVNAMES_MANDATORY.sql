ALTER TABLE stcw_nvnames_mandatory ADD datatype VARCHAR2(10) default 'String';

ALTER TABLE stcw_nvnames_mandatory 
  ADD CONSTRAINT datatype_chk
  CHECK (datatype IN ('String', 'Number'));