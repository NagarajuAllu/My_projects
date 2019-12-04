-- Install: op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (11, 2, 'I', 0, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Change SIM: op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (12, 2, 'C', 0, 'CHANGE_SIM', 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Change Profile/BW: op 2 
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (13, 2, 'C', 0, 'CHANGE_PRFL', 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Suspend: op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (14, 2, 'D', 0, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Resume: op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (15, 2, 'E', 0, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Disconnect: op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (16, 2, 'O', 0, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

commit;
