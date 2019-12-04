alter table STC_LINEITEM add feasibilityType VARCHAR2(20);
alter table STC_LINEITEM add onHeld NUMBER(1);
alter table STC_LINEITEM add omOrderNumber VARCHAR2(50);
alter table STC_LINEITEM add reservationNumber VARCHAR2(50);
alter table STC_LINEITEM add feasible NUMBER(1);
alter table STC_LINEITEM add previousWONumber VARCHAR2(20);
alter table STC_LINEITEM add previousActiveDocId VARCHAR2(16);
alter table STC_LINEITEM add autoFeasibilityMode NUMBER(1);

update STC_LINEITEM set projectId = substr(projectId, 1, 30) where length(projectId) >30;
commit;

alter table STC_LINEITEM modify projectId NVARCHAR2(30);

alter table STC_DEL_LINEITEM add feasibilityType VARCHAR2(20);
alter table STC_DEL_LINEITEM add onHeld NUMBER(1);
alter table STC_DEL_LINEITEM add omOrderNumber VARCHAR2(50);
alter table STC_DEL_LINEITEM add reservationNumber VARCHAR2(50);
alter table STC_DEL_LINEITEM add feasible NUMBER(1);
alter table STC_DEL_LINEITEM add previousWONumber VARCHAR2(20);
alter table STC_DEL_LINEITEM add previousActiveDocId VARCHAR2(16);
alter table STC_DEL_LINEITEM add autoFeasibilityMode NUMBER(1);

update STC_DEL_LINEITEM set projectId = substr(projectId, 1, 30) where length(projectId) >30;
commit;

alter table STC_DEL_LINEITEM modify projectId NVARCHAR2(30);
