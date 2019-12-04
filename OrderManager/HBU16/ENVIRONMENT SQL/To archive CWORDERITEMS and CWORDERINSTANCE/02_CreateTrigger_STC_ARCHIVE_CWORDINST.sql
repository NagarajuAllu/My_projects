CREATE OR REPLACE TRIGGER "CWH"."STC_ARCHIVE_CWORDINST"  
  BEFORE DELETE ON cwOrderInstance FOR EACH ROW

BEGIN
  
  INSERT INTO CWORDERINSTANCE_ARCHIVE VALUES
    (:old.cwdocid, :old.metadatatype, :old.status, :old.state, :old.visualkey, :old.productcode, :old.creationdate, :old.createdby, :old.updatedby, :old.lastupdateddate, 
     :old.parentorder, :old.owner, :old.state2, :old.hasattachment, :old.metadatatype_ver, :old.original_order_id, :old.source_order_id, :old.kind_of_order, :old.order_phase, 
     :old.project_id, :old.process_id, :old.cworderstamp, :old.cwdocstamp, :old.duedate, SYSDATE);
  
END;
