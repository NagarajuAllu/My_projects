DECLARE

  TYPE ProcessNameList IS TABLE OF cwmdtypes.typename%TYPE;
  my_processes ProcessNameList;

  processTypeId cwmdtypes.typeid%TYPE;
  bucketsNum    integer;
  

BEGIN
  
  my_processes := ProcessNameList(
    'stcw.syncAllOrdersAndQuotesBetweenExpediterAndGranite',
    'stcw.syncAllOrderBetweenExpdAndGraniteProcess',
    'stcw.syncAllQuoteBetweenExpdAndGraniteProcess',
    'stcw.syncOrderBetweenExpdAndGranite',
    'stcw.syncQuoteBetweenExpdAndGranite',
    'stcw.syncRejectedOrderBetweenExpdAndGranite',
    'stcw.syncRejectedQuoteBetweenExpdAndGranite');


  bucketsNum:=GET_MAX_BUCKET_NO();
  
  FOR i IN my_processes.FIRST .. my_processes.LAST LOOP
  
    SELECT typeid
      INTO processTypeId
      FROM cwmdtypes
     WHERE typename = my_processes(i);
     
    FOR tabNum IN 0..bucketsNum - 1 LOOP
      execute immediate 'DELETE FROM CWPPARTICIPANT_NEW' || tabNum || ' WHERE CONSUMER_ID IN (SELECT PROCESS_ID FROM CWPROCESS WHERE PROCESS_METADATYPE = '|| processTypeId||')';
      execute immediate 'DELETE FROM CWPPARTICIPANT_ACTIVE' || tabNum || ' WHERE CONSUMER_ID IN (SELECT PROCESS_ID FROM CWPROCESS WHERE PROCESS_METADATYPE = '|| processTypeId||')';
      execute immediate 'DELETE FROM CWPACTIVITY' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM CWPROCESS WHERE PROCESS_METADATYPE = '|| processTypeId||')';
      execute immediate 'DELETE FROM CWPACTIVITYARC' || tabNum || ' WHERE PROCESS_ID IN (SELECT PROCESS_ID FROM CWPROCESS WHERE PROCESS_METADATYPE = '|| processTypeId||')';
      execute immediate 'DELETE FROM CWPROCESS_NEW' || tabNum || ' WHERE PROCESS_METADATYPE = '|| processTypeId;
      execute immediate 'DELETE FROM CWPROCESS_ACTIVE' || tabNum || ' WHERE PROCESS_METADATYPE = '|| processTypeId;
    END LOOP;
    DELETE FROM CWPROCESS_COMPLETED WHERE PROCESS_METADATYPE = processTypeId;
  
  END LOOP;
  
END;
/