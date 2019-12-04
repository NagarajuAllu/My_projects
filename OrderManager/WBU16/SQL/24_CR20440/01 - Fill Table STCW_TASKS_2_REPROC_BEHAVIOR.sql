insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'ENABLE_PORT_4', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

insert into stcw_task_2_reproc_behavior (CWDOCID, TASK_OPERATION, STATUS_CODE, EXIST_DEPENDENT, ALREADY_COMPLETED_TASKOP, SUPPORT_RESEND, SUPPORT_RESEND_WINFO, SUPPORT_COMPLETE, REQUIRE_ONT, ADDITIONAL_INFO_DOC)
  select max(to_number(cwdocid)) + 1, 'DISABLE_PORT_4', '6', 1, null, 1, 1, 1, 0, 'failedOrders.additionalInfoForONTOLTDoc' from stcw_task_2_reproc_behavior;

commit;
