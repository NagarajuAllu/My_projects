insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  values ('1', 'SUBMIT_TASK', '9', 0, null, 1, 0, 1, 0, null);

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'WAIT_FOR_SSN_ONT', '4', 0, 'SUBMIT_TASK', 0, 0, 1, 1, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'CREATE_ONT_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'CREATE_HSI_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'TASK_UPDATE_HSI', '9', 0, null, 1, 0, 1, 0, null from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'PP-DESIGN-TASK', '9', 0, null, 1, 0, 0, 0, null from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'CONTACTS-REVISE', '9', 0, null, 1, 0, 0, 0, null from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'MODIFY_HSI_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'SUSPEND_HSI_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'RESUME_HSI_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'DELETE_HSI_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'DELETE_ONT_FTTH', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'CANCEL-FTTH-ORDER', '9', 0, null, 1, 0, 1, 0, null from stcw_task_2_reproc_behavior;

commit;

