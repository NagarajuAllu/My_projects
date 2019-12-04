VARIABLE jobno number;
BEGIN
   --daily at 00:01:00
   DBMS_JOB.SUBMIT(:jobno, 'STCW_FILL_INFO_ALL_SERVICES(); commit;', SYSDATE, 'TRUNC(SYSDATE + 1) + 1/(24*60)');
   COMMIT;
END;
/
COMMIT;
