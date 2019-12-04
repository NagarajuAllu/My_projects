ALTER TABLE stc_service_migration_rawdata 
  ADD recNum NUMBER(4);

UPDATE stc_service_migration_rawdata SET recNum = rowNum;

COMMIT;
