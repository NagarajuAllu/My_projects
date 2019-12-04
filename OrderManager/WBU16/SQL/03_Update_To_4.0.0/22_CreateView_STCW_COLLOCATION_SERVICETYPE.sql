-- create view STCW_COLLOCATION_SERVICETYPE (servicetype) as select product_code from CIMW.SERVICE_TYPES@RMS_PROD_DB_LINK where service_type = 'COLLOCATION';

drop materialized view STCW_COLLOCATION_SERVICETYPE;

create materialized view STCW_COLLOCATION_SERVICETYPE
refresh complete
as 
select product_code servicetype from CIMW.SERVICE_TYPES@RMS_PROD_DB_LINK where service_type = 'COLLOCATION';


alter materialized view STCW_COLLOCATION_SERVICETYPE
refresh
start with sysdate + 1/1440
next trunc(sysdate+1)+1/24;
