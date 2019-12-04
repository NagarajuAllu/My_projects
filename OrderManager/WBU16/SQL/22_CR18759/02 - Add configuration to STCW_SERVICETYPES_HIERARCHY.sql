insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'D061', null, 1, 1 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'C032', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'C033', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'C034', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'C035', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'D052', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;
insert into STCW_SERVICETYPES_HIERARCHY(CWDOCID, PARENT_SERVICETYPE, CHILD_SERVICETYPE, TASK_OPERATION, IS_SIBLING, IS_MANDATORY) select MAX(TO_NUMBER(CWDOCID)) + 1, 'D060', 'D053', null, 1, 0 from STCW_SERVICETYPES_HIERARCHY;

commit;
