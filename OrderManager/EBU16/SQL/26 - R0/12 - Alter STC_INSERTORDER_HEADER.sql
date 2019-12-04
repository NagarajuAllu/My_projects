update STC_INSERTORDER_HEADER set PROJECT_ID = substr(PROJECT_ID, 1, 30) where length(PROJECT_ID) >30;
commit;

alter table STC_INSERTORDER_HEADER modify PROJECT_ID nvarchar2(30);