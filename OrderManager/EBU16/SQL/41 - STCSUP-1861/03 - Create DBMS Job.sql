VARIABLE jobno number;
BEGIN
   -- daily
   DBMS_JOB.SUBMIT(:jobno, 'deleteOldRecordsFromSIUStage(); commit;', to_date(to_char(sysdate+1, 'yyyy/MM/dd') || ' 00:05:00', 'yyyy/MM/dd hh24:mi:ss'), 'TRUNC(SYSDATE+1)+5/(24*60)');
   commit;
END;
/