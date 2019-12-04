prompt Importing table STCW_ATTR_SAME_VAL_IN_UPDATE...

-- Configure Attributes that have to be checked for OH for Revise
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerIdNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'accountNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerIDType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerName');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'orderNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'orderType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'createdBy');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'priority');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'customerSegmentation');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'businessUnit');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'icmsSalesOrderNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'referenceTelNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '0', 'salesRepresentative');

-- Configure Attributes that have to be checked for OH for Cancel
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '1', 'orderNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '1', 'orderType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('OH', '1', 'businessUnit');

-- Configure Attributes that have to be checked for LI for Revise
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'lineItemIdentifier');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'lineItemType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'priority');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'orderRowItemId');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'serviceType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'serviceNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'oldServiceNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'reservationNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'description');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'reasonCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'changeRequestType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'disconnectionReason');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'segmentFlag');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'productCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'restoration');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'numberOfChannels');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'primaryAssetNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'quantity');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'icmsSONumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'fictBillingNumber');
-- insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'bandwidth');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'accountNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'oldAccountNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'projectId');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationACity');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationACCLICode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAAccessCircuit');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAJVCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAExchangeSwitchCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAAccessType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAPlateID');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAOldPlateID');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAUnitNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationAInterface');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationARemarks');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBCity');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBCCLICode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBAccessCircuit');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBJVCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBExchangeSwitchCode');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBAccessType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBPlateID');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBOldPlateID');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBUnitNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBInterface');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'locationBRemarks');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'wires');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'referenceTelNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '0', 'serviceDescription');

-- Configure Attributes that have to be checked for LI for Cancel
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'lineItemIdentifier');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'lineItemType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'priority');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'serviceType');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'serviceNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'oldServiceNumber');
insert into STCW_ATTR_SAME_VAL_IN_UPDATE (ELEMENT_TYPE, IS_CANCEL, ATTRIBUTE_NAME) values ('LI', '1', 'productCode');


commit;

prompt Done.

