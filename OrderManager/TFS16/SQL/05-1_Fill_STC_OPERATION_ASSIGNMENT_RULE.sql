-- INSERT THE RECORDS FOR 
-- STC_OPERATION_ASSIGNMENT_RULE TABLE
-- FOR ALL THE OPERATIONS OF ALL THE PROCESSES 
-- (check datatype workflow.processName and workflow.operation)

prompt Filling table STC_OPERATION_ASSIGNMENT_RULE...

insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'submitPRNR', 'STC_NetwDesPriv', 'NetworkDesign', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'crossConnectionRequired', 'STC_XCPriv', 'XC', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'issueFixed', 'STC_IOrdInitPriv', 'OrderInitiator', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'rejectAnalys', 'STC_IOrdInitPriv', 'OrderInitiator', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'rejectionProcessCompleted', 'STC_IntegPriv', 'Integration', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'submitTFR', 'STC_FacilityDes', 'FacilityDesign', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'acceptReservationOnGranite', 'STC_FacilityDes', 'FacilityDesign', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'tasksForIntermediateSitesLoaded', 'STC_QualityPriv', 'Quality', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'rejectToInitiator', 'STC_IOrdInitPriv', 'OrderInitiator', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'crossConnectionNotRequired', 'STC_QualityPriv', 'Quality', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'reviseTFR', 'STC_FacilityDes', 'FacilityDesign', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'rejectPRNR', 'STC_IOrdInitPriv', 'OrderInitiator', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'acceptPRNR', 'STC_NetwDesPriv', 'NetworkDesign', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'switchActivationRequired', 'STC_SwchActvPriv', 'SwitchActivation', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('installOrderProcess', 'switchActivationCompleted', 'STC_XCPriv', 'XC', 'Load Balancing', 0);


insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('blockingIssueProcess','assignBIToProperGroup','STC_BBTransPriv','BB_Transport_Design','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('blockingIssueProcess','assignedToTFAModSquad','STC_TFAModSqPriv','TFA_ModSquad','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('blockingIssueProcess','assignedToFATxTeam','STC_FATxPriv','FA_Tx','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('blockingIssueProcess','assignedToFNITeam','STC_FNIPriv','FNI','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('blockingIssueProcess','mopIssued','STC_BIPriv','BI','Load Balancing',0);


insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','validationOfCancellation','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','cancelCircuitInRDTTool','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','cancellationReservationInGranite','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','cancelExistingPRNandPRNR','STC_NetwDesPriv','NetworkDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','acknowledgeRejection','STC_IOrdInitPriv','OrderInitiator','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','approveCancellation','STC_IOrdInitPriv','OrderInitiator','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelInstallOrderProcess','requestCancelPRNorPRNR','STC_FacilityDes','FacilityDesign','Load Balancing', 0);


insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','cancelDisconnect','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','approveDisconnectCancellation','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','rejectDisconnectCancellation','STC_IOrdInitPriv','OrderInitiator','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','xcNotRequiredCancelDisconnect','STC_IOrdInitPriv','OrderInitiator','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','xcRequiredCancelDisconnect','STC_XCPriv','XC','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('cancelDisconnectOrderProcess','cancelledXCForCancelDisconnect','STC_IOrdInitPriv','OrderInitiator','Load Balancing',0);
	

insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('taskManagementProcess','acceptingTask_Site','STC_SitePriv','Site','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('taskManagementProcess','acceptingTask_Quality','STC_QualityPriv','Quality','Load Balancing',0);


insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('disconnectOrderProcess','submitDisconnectTFR','STC_FacilityDes','FacilityDesign','Load Balancing',0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('disconnectOrderProcess','releasedReservationInGranite', 'STC_IOrdInitPriv', 'OrderInitiator', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('disconnectOrderProcess','taskManagementCompleted', 'STC_VerificPriv', 'Verification', 'Load Balancing', 0);

insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('biAssociationProcess', 'startBIAssociation', 'STC_BIPriv', 'BI', 'Load Balancing', 0);
insert into stc_operation_assignment_rule (PROCESS_NAME, OPERATION_NAME, PRIVILEGE_CODE, INTERNAL_PARTICIPANT_NAME, ASSIGNMENT, EMAIL_NOTIFICATION) values ('biAssociationProcess', 'prepareToCompleteBIMgmt', 'STC_BIPriv', 'BI', 'Load Balancing', 0);

commit;
