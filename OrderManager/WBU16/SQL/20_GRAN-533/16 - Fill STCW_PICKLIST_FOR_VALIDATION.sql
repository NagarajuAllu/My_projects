-- changeRequestType for FTTH
-- insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'RELOCATION' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'RELOCATION_BW' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'RELOCATION_NC' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'RELOCATION_ADD' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'RELOCATION_DEL' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'CHANGE_ONT' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'CHANGE_NUM' from stcw_picklist_for_validation;

-- changeRequestType for LTE
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'CHANGE_SIM' from stcw_picklist_for_validation;
insert into stcw_picklist_for_validation (cwdocid, datatypename, value) select max(to_number(cwdocid)) + 1, 'changeRequestType', 'CHANGE_PRFL' from stcw_picklist_for_validation;

commit;
