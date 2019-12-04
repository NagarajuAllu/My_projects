create user rms_prod identified by rms_prod;
grant connect to rms_prod;
grant resource to rms_prod;
grant create synonym to rms_prod;

create public database link RMS_PROD_DB_LINK
connect to rms_prod identified by rms_prod
using 'rmsprod';

conn rms_prod/rms_prod

create or replace synonym WORK_ORDER_INST for WORK_ORDER_INST@RMS_PROD_DB_LINK;
create or replace synonym VAL_TASK_STATUS for VAL_TASK_STATUS@RMS_PROD_DB_LINK;
create or replace synonym WORKORDER_ATTR_SETTINGS for WORKORDER_ATTR_SETTINGS@RMS_PROD_DB_LINK;
create or replace synonym VAL_ATTR_NAME for VAL_ATTR_NAME@RMS_PROD_DB_LINK;