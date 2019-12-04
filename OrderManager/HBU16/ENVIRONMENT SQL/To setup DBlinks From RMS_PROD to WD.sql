

-- executed as SYS user
alter user rmse_cw account unlock;
alter user rmsh_cw account unlock;
alter user rmsw_cw account unlock;

grant CREATE SESSION to rmse_cw;
grant CREATE SESSION to rmsh_cw;
grant CREATE SESSION to rmsw_cw;


drop database link RMS_PROD.CWE_LINK;
create public database link CWE_LINK
  connect to CWE identified by cwe
  using 'wdpt';

drop database link RMS_PROD.CWH_LINK;
create public database link CWH_LINK
  connect to CWH identified by cwh
  using 'wdpt';

drop database link RMS_PROD.CWW_LINK;
create public database link CWW_LINK
  connect to CWW identified by cww
  using 'wdpt';


-- query used to gather data: select * from all_synonyms where owner = 'RMS%_CW'; 

-- executed as RMSE_CW user
drop synonym RMSE_CW.CWFEVENTSEQ;
create synonym RMSE_CW.CWFEVENTSEQ for CWE.CWFEVENTSEQ@CWE_LINK;

drop synonym RMSE_CW.CWPROCESSEVENTLOG;
create synonym RMSE_CW.CWPROCESSEVENTLOG for CWE.CWPROCESSEVENTLOG@CWE_LINK;

drop synonym RMSE_CW.STC_ORDER_MESSAGE;
create synonym RMSE_CW.STC_ORDER_MESSAGE for CWE.STC_ORDER_MESSAGE@CWE_LINK;


-- executed as RMSH_CW user

drop synonym RMSH_CW.CWFEVENTSEQ;
create synonym RMSH_CW.CWFEVENTSEQ for CWH.CWFEVENTSEQ@CWH_LINK;

drop synonym RMSH_CW.CWMESSAGELOG;
create synonym RMSH_CW.CWMESSAGELOG for CWH.CWMESSAGELOG@CWH_LINK;

drop synonym RMSH_CW.CWORDERINSTANCE;
create synonym RMSH_CW.CWORDERINSTANCE for CWH.CWORDERINSTANCE@CWH_LINK;

drop synonym RMSH_CW.CWPROCESSEVENTLOG;
create synonym RMSH_CW.CWPROCESSEVENTLOG for CWH.CWPROCESSEVENTLOG@CWH_LINK;

drop synonym RMSH_CW.STC_NAME_VALUE;
create synonym RMSH_CW.STC_NAME_VALUE for CWH.STC_NAME_VALUE@CWH_LINK;

drop synonym RMSH_CW.STC_ORDER_MESSAGE_HOME;
create synonym RMSH_CW.STC_ORDER_MESSAGE_HOME for CWH.STC_ORDER_MESSAGE_HOME@CWH_LINK;

drop synonym RMSH_CW.STC_SERVICE_PARAMETERS_HOME;
create synonym RMSH_CW.STC_SERVICE_PARAMETERS_HOME for CWH.STC_SERVICE_PARAMETERS_HOME@CWH_LINK;



-- executed as RMSW_CW user

drop synonym RMSW_CW.ORB_ORDER_HEADER;
create synonym RMSW_CW.ORB_ORDER_HEADER for CWW.ORB_ORDER_HEADER@CWW_LINK;



-- executed as RMS_PROD user

-- query used to find invalid objects: select * from all_objects where status = 'INVALID' order by object_name;

alter proceduce xxxxx compile;
alter view yyyyy compile;
alter package zzzz compile;


-- executed as SYS user

alter user rmse_cw account lock;
alter user rmsh_cw account lock;
alter user rmsw_cw account lock;
