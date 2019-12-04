prompt Importing table STCW_COM_TO_GRANITE_DATA...

-- Fill OrderHeader for Order Wholesale   
--   Use Order Header data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerIdNumber', 'OH', 'AccountNumber', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('businessUnit', 'OH', 'BusinessUnit', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('createdBy', 'OH', 'CreatedBy', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'OH', 'CreationDate', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDate', 'OH', 'ExpectedDate', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('orderStatus', 'OH', 'OrderStatus', 'OH', 'W', 'O');

--   Use LineItem Data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('changeRequestType', 'LI', 'ChangeRequestType', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('remarks', 'LI', 'Comments', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('description', 'LI', 'Description', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('disconnectionReason', 'LI', 'DisconnectionReason', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('restoration', 'LI', 'Restoration', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('segmentFlag', 'LI', 'SegmentFlag', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('workOrderNumber', 'LI', 'OrderNumber', 'OH', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('workOrderType', 'LI', 'OrderType', 'OH', 'W', 'O');


-- Fill LineItem for Order Wholesale   
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('bandwidth', 'LI', 'Bandwidth', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'LI', 'CreationDate', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceType', 'LI', 'ProductCode', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservationNumber', 'LI', 'ReservationNumber', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('segmentFlag', 'LI', 'SegmentFlag', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDate', 'LI', 'ServiceDate', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceNumber', 'LI', 'AssetNumber', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('primaryAssetNumber', 'LI', 'PrimaryAssetNumber', 'LI', 'W', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('numberOfChannels', 'LI', 'NumberOfChannels', 'LI', 'W', 'O');





-- Fill OrderHeader for Quote Wholesale
--   Use Order Header data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerIdNumber', 'OH', 'AccountNumber', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('businessUnit', 'OH', 'BusinessUnit', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'OH', 'CreationDate', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('orderNumber', 'OH', 'ParentQuoteNumber', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservation', 'OH', 'QuoteStatus', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('feasibilityFor', 'OH', 'QuoteType', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('salesRepresentative', 'OH', 'SalesRepresentative', 'OH', 'W', 'Q');

--   Use LineItem Data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('remarks', 'LI', 'Comments', 'OH', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('workOrderNumber', 'LI', 'QuoteNumber', 'OH', 'W', 'Q');


-- Fill LineItem for Quote Wholesale   
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('bandwidth', 'LI', 'Bandwidth', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'LI', 'CreationDate', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceType', 'LI', 'ProductCode', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('segmentFlag', 'LI', 'SegmentFlag', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDate', 'LI', 'ServiceDate', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceNumber', 'LI', 'AssetNumber', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('primaryAssetNumber', 'LI', 'PrimaryAssetNumber', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('numberOfChannels', 'LI', 'NumberOfChannels', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('orderRowItemId', 'LI', 'OrderRowItemId', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('quantity', 'LI', 'Quantity', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservationDays', 'LI', 'ReservationExpiry', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('restoration', 'LI', 'Restoration', 'LI', 'W', 'Q');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservationNumber', 'LI', 'ReservationNumber', 'LI', 'W', 'Q');





-- Fill OrderHeader for Order Enterprise   
--   Use Order Header data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerIdNumber', 'OH', 'customerIdNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('accountNumber', 'OH', 'accountNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerType', 'OH', 'customerType', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerIDType', 'OH', 'customerIDType', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerContact', 'OH', 'customerContact', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerContactName', 'OH', 'customerContactName', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerName', 'OH', 'customerName', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerNumber', 'OH', 'customerNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('orderNumber', 'OH', 'crmOrderNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('orderStatus', 'OH', 'orderStatus', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'OH', 'creationDate', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('createdBy', 'OH', 'createdBy', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('createdByName', 'OH', 'createdByName', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('createdByContactName', 'OH', 'createdByContactName', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDate', 'OH', 'serviceDate', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('priority', 'OH', 'priority', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('referenceTelNumber', 'OH', 'referenceTelNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('customerSegmentation', 'OH', 'customerSegmentation', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('feasibilityFor', 'OH', 'feasibilityFor', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservation', 'OH', 'reservation', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('icmsSalesOrderNumber', 'OH', 'icmsSalesOrderNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('businessUnit', 'OH', 'businessUnit', 'OH', 'E', 'O');

--   Use LineItem Data
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reservationNumber', 'LI', 'reservationNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('workOrderType', 'LI', 'workOrderType', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('workOrderNumber', 'LI', 'workOrderNumber', 'OH', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('remarks', 'LI', 'remarks', 'OH', 'E', 'O');


-- Fill LineItem for Order Enterprise   
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('lineItemIdentifier', 'LI', 'lineItemIdentifier', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('lineItemType', 'LI', 'lineItemType', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('action', 'LI', 'action', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceType', 'LI', 'serviceType', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceNumber', 'LI', 'serviceNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('oldServiceNumber', 'LI', 'oldServiceNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('reasonCode', 'LI', 'reasonCode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('productCode', 'LI', 'productType', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('remarks', 'LI', 'remarks', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('icmsSONumber', 'LI', 'icmsSONumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('fictBillingNumber', 'LI', 'fictBillingNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('bandwidth', 'LI', 'bandwidth', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('accountNumber', 'LI', 'accountNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('oldAccountNumber', 'LI', 'oldAccountNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('projectId', 'LI', 'projectId', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationACity', 'LI', 'locationACity', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationACCLICode', 'LI', 'locationACCLICode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAAccessCircuit', 'LI', 'locationAAccessCircuit', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAJVCode', 'LI', 'locationAJVCode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAExchangeSwitchCode', 'LI', 'locationAExchangeSwitchCode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAAccessType', 'LI', 'locationAAccessType', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAPlateID', 'LI', 'locationAPlateID', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAOldPlateID', 'LI', 'locationAOldPlateID', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAContactAddress', 'LI', 'locationAContactAddress', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAContactName', 'LI', 'locationAContactName', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAContactTel', 'LI', 'locationAContactTelNo', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAContactEmail', 'LI', 'locationAContactEmail', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAUnitNumber', 'LI', 'locationAUnitNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationAInterface', 'LI', 'locationAInterface', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationARemarks', 'LI', 'locationARemarks', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBCity', 'LI', 'locationBCity', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBCCLICode', 'LI', 'locationBCCLICode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBAccessCircuit', 'LI', 'locationBAccessCircuit', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBJVCode', 'LI', 'locationBJVCode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBExchangeSwitchCode', 'LI', 'locationBExchangeSwitchCode', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBAccessType', 'LI', 'locationBAccessType', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBPlateID', 'LI', 'locationBPlateID', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBOldPlateID', 'LI', 'locationBOldPlateID', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBContactAddress', 'LI', 'locationBContactAddress', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBContactName', 'LI', 'locationBContactName', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBContactTel', 'LI', 'locationBContactTelNo', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBContactEmail', 'LI', 'locationBContactEmail', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBUnitNumber', 'LI', 'locationBUnitNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBInterface', 'LI', 'locationBInterface', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('locationBRemarks', 'LI', 'locationBRemarks', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('wires', 'LI', 'wires', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('referenceTelNumber', 'LI', 'referenceTelNumber', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDescription', 'LI', 'serviceDescription', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('serviceDate', 'LI', 'serviceDate', 'LI', 'E', 'O');
insert into STCW_COM_TO_GRANITE_DATA (com_name, com_element, gi_name, gi_element, cim, o_q) values ('creationDate', 'LI', 'creationDate', 'LI', 'E', 'O');

commit;

prompt Done.