CREATE TABLE to_be_removed (PROCESS_ID) 
  AS (SELECT process_id 
        FROM CWPROCESS, CWMDTYPES 
       WHERE process_metadatype = typeid
         AND typename IN ('stcw.syncAllOrdersAndQuotesBetweenExpediterAndGranite',
                          'stcw.syncAllOrderBetweenExpdAndGraniteProcess',
                          'stcw.syncAllQuoteBetweenExpdAndGraniteProcess',
                          'stcw.syncOrderBetweenExpdAndGranite',
                          'stcw.syncQuoteBetweenExpdAndGranite',
                          'stcw.syncRejectedOrderBetweenExpdAndGranite',
                          'stcw.syncRejectedQuoteBetweenExpdAndGranite'));
                          

DECLARE

  bucketsNum    integer;

BEGIN

  bucketsNum:=GET_MAX_BUCKET_NO();
  
  FOR tabNum IN 0..bucketsNum - 1 LOOP
    execute immediate 'DELETE FROM CWPPARTICIPANT_NEW' || tabNum || ' WHERE CONSUMER_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    execute immediate 'DELETE FROM CWPPARTICIPANT_ACTIVE' || tabNum || ' WHERE CONSUMER_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    execute immediate 'DELETE FROM CWPACTIVITY' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    execute immediate 'DELETE FROM CWPACTIVITYARC' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    execute immediate 'DELETE FROM CWPROCESS_NEW' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    execute immediate 'DELETE FROM CWPROCESS_ACTIVE' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM to_be_removed)';
    COMMIT;
  END LOOP;
  
END;
/

ALTER TRIGGER cwprocessdelete DISABLE;
ALTER TRIGGER cwprocesscompleted_fixed DISABLE;

CREATE TABLE temp_proc_completed AS SELECT * FROM cwprocess_completed WHERE process_id NOT IN (SELECT process_id FROM to_be_removed);

TRUNCATE TABLE cwprocess_completed;

INSERT INTO CWPROCESS_COMPLETED SELECT * FROM temp_proc_completed;
COMMIT;

ALTER TRIGGER cwprocessdelete ENABLE;
ALTER TRIGGER cwprocesscompleted_fixed ENABLE;

DROP TABLE temp_proc_completed;

DROP TABLE to_be_removed;
