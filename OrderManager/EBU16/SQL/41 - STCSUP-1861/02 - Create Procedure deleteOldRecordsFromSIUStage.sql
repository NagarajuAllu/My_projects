CREATE OR REPLACE PROCEDURE deleteOldRecordsFromSIUStage AS

  numOfDays  NUMBER(2);

BEGIN

  -- this is the parameter used to define for how many days the records should remain in the stage table
  numOfDays := 2;

  -- check if the WO and the path are in online tables
  BEGIN
    DELETE FROM stc_siu_event_stage WHERE eventDate < TRUNC(sysdate - numOfDays);
  EXCEPTION
    WHEN others THEN
      RETURN;
  END;


END deleteOldRecordsFromSIUStage;
/