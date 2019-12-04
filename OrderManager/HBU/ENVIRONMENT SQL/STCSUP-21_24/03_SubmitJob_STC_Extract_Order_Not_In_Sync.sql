VARIABLE jobno number;
BEGIN
   --every 20 minutes
   DBMS_JOB.SUBMIT(:jobno, 'STC_Extract_Orders_Not_In_Sync(); commit;', SYSDATE, 'SYSDATE + 1/72');
   COMMIT;
END;
/
COMMIT;
