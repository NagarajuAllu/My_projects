-- Install: op 1, 2 and 3
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (1, 1, 'I', 1, null, 'nsmValidateInventoryWS.validateInventoryIF', 'validateInventory', 'nsmValidateInventoryWS.validateInventoryResponse_el');
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (2, 2, 'I', 1, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (3, 3, 'I', 1, null, 'nsmUpdateSIMStatusWS.updateSIMStatusIF', 'updateSIMStatus', 'nsmUpdateSIMStatusWS.updateSIMStatusResponse_el');

-- Change SIM: only op 2 and 3
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (4, 2, 'C', 1, 'CHANGE_SIM', 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (5, 3, 'C', 1, 'CHANGE_SIM', 'nsmChangeSIMDetailsWS.changeSIMDetailsIF', 'changeSIMDetails', 'nsmChangeSIMDetailsWS.changeSIMDetailsResponse_el');

-- Change Profile/BW: only op 2 
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (6, 2, 'C', 1, 'CHANGE_PRFL', 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Suspend: only op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (7, 2, 'D', 1, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Resume: only op 2
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (8, 2, 'E', 1, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');

-- Disconnect: only op 2 and 3
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (9, 2, 'O', 1, null, 'pnaSubmitPnAOrderWS:submitPnAOrderIF', 'submitPnAOrder', 'pnaSubmitPnAOrderWS.submitPnAOrderResponse_el');
insert into stcw_operation_lte (cwdocid, step, orderType, isSubmit, changeRequestType, interfaceName, operationName, outputDocName) 
                        values (10, 3, 'O', 1, null, 'nsmUpdateSIMStatusWS.updateSIMStatusIF', 'updateSIMStatus', 'nsmUpdateSIMStatusWS.updateSIMStatusResponse_el');

commit;
