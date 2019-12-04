set define OFF

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
values ('1', 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'E', null, null, null, 'AIM_REQ%');

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'E', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'D', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'D', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'C', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'C', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'O', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_ESP_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', null, 'O', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'EASTERN', 'I', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'EASTERN', 'I', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'EASTERN', 'T', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'EASTERN', 'T', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'CENTRAL', 'I', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'CENTRAL', 'I', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'CENTRAL', 'T', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_C&E_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'CENTRAL', 'T', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'WESTERN', 'I', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'WESTERN', 'I', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'WESTERN', 'T', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'WESTERN', 'T', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'SOUTHERN', 'I', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'SOUTHERN', 'I', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'SOUTHERN', 'T', null, null, null, 'AIM_REQ%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'CSDD_Pioneers_W&S_FTTx_OLO', 'REJECT_FTTH_ORDER', '4', 'SOUTHERN', 'T', null, null, null, '.:NOT_FOUND%' from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'SUBMIT_TASK', '9', null, null, null, null, null, null from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'TASK_UPDATE_HSI', '9', null, null, null, null, null, null from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'PP-DESIGN-TASK', '9', null, null, null, null, null, null from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'CONTACTS-REVISE', '9', null, null, null, null, null, null from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'CANCEL-FTTH-ORDER', '9', null, null, null, null, null, null from stcw_group_configuration;
  
insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'REJECT_FTTH_ORDER', '4', null, null, null, null, 'AIM_REQ%', null from stcw_group_configuration;

insert into stcw_group_configuration (CWDOCID, GROUPNAME, TASKOPERATION, TASKSTATUSCODE, REGION, ORDERTYPE, REASONCODE, REASONCODENOT, REASONDESCR, REASONDESCRNOT)
  select max(to_number(cwdocid)) + 1, 'TECH_FAILURE', 'REJECT_FTTH_ORDER', '4', null, null, null, null, '.:NOT_FOUND%', null from stcw_group_configuration;

commit;