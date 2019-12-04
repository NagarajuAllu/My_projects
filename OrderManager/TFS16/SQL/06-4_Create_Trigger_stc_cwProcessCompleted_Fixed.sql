CREATE OR REPLACE TRIGGER 
cwProcessCompleted_Fixed AFTER
    INSERT
    ON "CWPROCESS_COMPLETED"
    FOR EACH ROW

DECLARE
   sqlCmd VARCHAR2(3000);
   
BEGIN
   IF :new.STATUS IN(3,6) THEN
      --Complete,Terminated
      delete from cwpDynamicParticipant where PROCESS_ID = :new.PROCESS_ID;

      FOR tabNum in 0 .. 19 LOOP
         EXECUTE IMMEDIATE 'DELETE FROM CWPPARTICIPANT_ACTIVE' || tabNum || ' t WHERE CONSUMER_ID = '|| :new.PROCESS_ID;
      END LOOP;
      
      delete from CWPGLOBAL where PROCESS_ID = :new.PROCESS_ID;

      FOR tabNum in 0 .. 19 LOOP
         EXECUTE IMMEDIATE 'DELETE FROM CWPPARTICIPANT_ACTIVE' || tabNum || ' t WHERE SENDER_ID = '|| :new.PROCESS_ID;
      END LOOP;

      DELETE FROM CWPWORKLIST WHERE SENDER_ID =:new.PROCESS_ID;

      FOR tabNum in 0 .. 19 LOOP
         sqlCmd := 'INSERT INTO CWPACTIVITYARC' || tabNum ||' (PROCESS_ID,ACTIVITY_INDEX,START_TIME,COMPLETION_TIME)
                    SELECT PROCESS_ID,
                           ACTIVITY_INDEX,    
                           (CASE WHEN START_TIME IS NULL THEN sysdate ELSE START_TIME END),
                           COMPLETION_TIME
                      FROM cwpActivity' || tabNum || ' WHERE PROCESS_ID = '|| :new.PROCESS_ID;
         EXECUTE IMMEDIATE sqlCmd;
      END LOOP;
        
      FOR tabNum in 0 .. 19 LOOP
         EXECUTE IMMEDIATE 'DELETE FROM CWPACTIVITY' || tabNum || ' t WHERE PROCESS_ID = '|| :new.PROCESS_ID;
      END LOOP;

   ELSIF :new.STATUS IN (2,5) THEN
      --Error,Suspended
      update cwpworklist set DISABLE = 1 where SENDER_ID = :new.PROCESS_ID and SENDER_TYPE = :new.PROCESS_METADATYPE;
   ELSIF :new.STATUS = 1 THEN
      --Executing
      update cwpworklist set DISABLE = 0 where SENDER_ID = :new.PROCESS_ID and SENDER_TYPE = :new.PROCESS_METADATYPE;
   END IF;
END;

/