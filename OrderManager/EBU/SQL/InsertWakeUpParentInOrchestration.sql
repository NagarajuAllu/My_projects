DECLARE
  
  process_parent_metadatype NUMBER(9);
  process_sender_id         NUMBER(16);
  process_consumer_id       NUMBER(16);
  
  signal                    cwpparticipant.OPERATION%TYPE;

BEGIN
  process_sender_id   := &PROCESS_SENDER_ID;
  process_consumer_id := &PROCESS_CONSUMER_ID;
  
--  signal              := 'processSTC:wakeUpParentInOrchestration';
  signal              := 'processSTC:notifyProvisioningIsCompleted';
  
  SELECT process_metadatype
    INTO process_parent_metadatype
    FROM cwprocess
   WHERE process_id = process_sender_id;

  
  INSERT INTO cwpparticipant 
    (MSGID, DOC_TYPE, SENDER_ID, SENDER_TYPE, ORDER_ID, 
     CONSUMER_ID, OPERATION, CREATION_DATE, DISABLE, ACTIVITY_INDEX)
  VALUES
    (cwparticipantseq.nextval, 0, process_sender_id, process_parent_metadatype, null, 
     process_consumer_id, 'processSTC:wakeUpParentInOrchestration', sysdate, 0, 0);

  EXCEPTION
    WHEN others THEN
DBMS_OUTPUT.PUT_LINE('>>> Errore in insert cwpparticipant; Error: '||substr( sqlerrm, 0, 1000));

END;

/

SPOOL OFF;
