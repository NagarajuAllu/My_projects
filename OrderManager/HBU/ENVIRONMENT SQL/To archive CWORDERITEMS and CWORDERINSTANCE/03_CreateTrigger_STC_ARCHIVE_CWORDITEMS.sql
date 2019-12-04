CREATE OR REPLACE TRIGGER "CWH"."STC_ARCHIVE_CWORDITEMS"
  BEFORE DELETE ON cwOrderItems FOR EACH ROW


BEGIN

  INSERT INTO CWORDERITEMS_ARCHIVE VALUES
    (:old.toporderid, :old.parentid, :old.itemid, :old.metadatatype, :old.pos, :old.instancekey, :old.hasattachment, :old.state, :old.process_id, :old.search_key, :old.order_creation_date, SYSDATE);

END;
