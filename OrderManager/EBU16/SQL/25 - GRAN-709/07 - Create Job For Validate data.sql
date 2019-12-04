VARIABLE jobno number;
BEGIN
   -- daily
   DBMS_JOB.SUBMIT(:jobno, 'validate_eoc_ebu_data.perform_all_checks(); commit;', to_date(to_char(sysdate+1, 'yyyy/MM/dd') || ' 18:00:00', 'yyyy/MM/dd hh24:mi:ss'), 'TRUNC(SYSDATE+1)+18/24');
   commit;
END;
/