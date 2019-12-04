-- verify that the job id in the SQL matches the number of the job id in the environment 


begin
  sys.dbms_job.change(job => 124,
                      what => 'STC_Extract_Orders_Not_In_Sync(); commit;',
                      next_date => sysdate,
                      interval => 'SYSDATE + 1/24');
  commit;
end;
/