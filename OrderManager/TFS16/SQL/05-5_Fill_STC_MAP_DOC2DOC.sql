prompt Filling table STC_MAP_DOC2DOC...

-- PRNR => PRN
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'prnrId', 'PRNR', 'prnrId');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'customerName', 'PRNR', 'customerName');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'customerProject', 'PRNR', 'customerProject');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'customerProjectPhase', 'PRNR', 'customerProjectPhase');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteAName', 'PRNR', 'siteAName');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteAIF', 'PRNR', 'siteAIF');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteAJVC', 'PRNR', 'siteAJVC');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteZName', 'PRNR', 'siteZName');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteZIF', 'PRNR', 'siteZIF');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'siteZJVC', 'PRNR', 'siteZJVC');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'requirementType', 'PRNR', 'requirementType');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'quantity', 'PRNR', 'quantity');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'trafficDiversity', 'PRNR', 'trafficDiversity');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'protectionType', 'PRNR', 'protectionType');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'trafficType', 'PRNR', 'trafficType');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'plannedRFSDate', 'PRNR', 'plannedRFSDate');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'beneficiaryName', 'PRNR', 'beneficiaryName');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'beneficiaryContacts', 'PRNR', 'beneficiaryContacts');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'gsmCellId', 'PRNR', 'gsmCellId');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'gsmCellVendor', 'PRNR', 'gsmCellVendor');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'remarks', 'PRNR', 'remarks');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'tn', 'PRNR', 'tn');
insert into STC_MAP_DOC2DOC (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('PRN', 'tnPort', 'PRNR', 'tnPort');

-- PRN => TFR
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'customerName', 'PRN', 'customerName');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteAIF', 'PRN', 'siteAIF');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteAJVC', 'PRN', 'siteAJVC');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteAName', 'PRN', 'siteAName');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteZIF', 'PRN', 'siteZIF');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteZJVC', 'PRN', 'siteZJVC');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'siteZName', 'PRN', 'siteZName');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'requirementType', 'PRN', 'requirementType');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'required', 'PRN', 'quantity');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'peODF', 'PRN', 'peODF');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'peSlot', 'PRN', 'peSlot');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'pePort', 'PRN', 'pePort');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'tfrYear', 'PRN', 'prnYear');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'tfrMonth', 'PRN', 'prnMonth');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'plannedRFSDate', 'PRN', 'plannedRFSDate');
insert into stc_map_doc2doc (DEST_OBJECT, DEST_FIELD, SOURCE_OBJECT, SOURCE_FIELD) values ('TFR', 'businessUnit_Requester', 'PRN', 'businessUnit_Initiator');




commit;
